-- ============================================================================
-- The reporting schema — the read-only copy
--
-- Served from the RDS read replica. Dashboards, Pulse exports and the Phase 2
-- intelligence layer read here through reporting_reader, which can only SELECT.
-- Nothing here is ever written by the application; everything is derived.
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS reporting;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'reporting_reader') THEN
    CREATE ROLE reporting_reader NOLOGIN;
  END IF;
END $$;

-- Four business days, per Dan: "let's just make it obvious. Let's just say four."
CREATE OR REPLACE FUNCTION reporting.add_business_days(start_date date, days integer)
RETURNS date LANGUAGE plpgsql IMMUTABLE AS $$
DECLARE d date := start_date; n integer := 0;
BEGIN
  IF start_date IS NULL THEN RETURN NULL; END IF;
  WHILE n < days LOOP
    d := d + 1;
    IF extract(isodow FROM d) < 6 THEN n := n + 1; END IF;
  END LOOP;
  RETURN d;
END $$;

-- Authorization Status as Dan reads it: Complete, or Need N.
CREATE OR REPLACE VIEW reporting.authorization_status AS
SELECT
  lr.loan_id,
  count(*) FILTER (WHERE lr.submission_state = 'not_received') AS outstanding,
  CASE WHEN count(*) FILTER (WHERE lr.submission_state = 'not_received') = 0 THEN 'Complete'
       ELSE 'Need ' || count(*) FILTER (WHERE lr.submission_state = 'not_received') END AS label
FROM loan_requirements lr
JOIN requirement_types rt ON rt.id = lr.requirement_type_id
WHERE rt.key = 'authorization' AND lr.not_needed_at IS NULL
GROUP BY lr.loan_id;

-- The pipeline. One row per loan, every column Dan reads off Pulse.
CREATE OR REPLACE VIEW reporting.pulse AS
SELECT
  l.id                                   AS loan_id,
  l.loan_number,
  lo.last_name                           AS lo_last_name,
  cm.display_name                        AS client_manager,
  cp.code                                AS capital_source,
  l.property_street, l.property_city, l.property_state,
  st.name                                AS stage,
  s.name                                 AS status,
  (current_date - l.status_since::date)  AS days_in_current_status,
  l.transaction_type, l.loan_type, l.property_type, l.channel,
  t.total_loan_amount, t.initial_loan_amount, t.holdback, t.interest_reserve, t.note_rate,
  l.target_submission_date, l.target_funding_date, l.loi_funding_date, l.psa_closing_date,
  ap.status                              AS appraisal_status,
  ap.promised_delivery_date              AS appraisal_promised,
  ap.target_delivery_date                AS appraisal_target,
  ap.vendor_needs                        AS appraiser_needs,
  apv.display_name                       AS appraisal_company,
  bu.status                              AS budget_status,
  bu.review_type                         AS budget_review_type,
  bu.promised_delivery_date              AS budget_promised,
  bu.vendor_needs                        AS budget_vendor_needs,
  (bu.sent_to_appraiser_at IS NOT NULL)  AS budget_to_appraiser,
  greatest(ap.promised_delivery_date, bu.promised_delivery_date)                                   AS calculated_submission_date,
  reporting.add_business_days(greatest(ap.promised_delivery_date, bu.promised_delivery_date), 4)  AS calculated_funding_date,
  l.vom_status, l.payoff_status, l.escrow_contact_provided, l.track_record_status,
  coalesce(auth.label, 'Complete')       AS authorization_status,
  l.portfolio_refinance, l.repeat_borrower, l.insurance_paid, l.rate_lock_expiration
FROM loans l
JOIN stages st ON st.id = l.stage_id
JOIN statuses s ON s.id = l.status_id
LEFT JOIN users lo ON lo.id = l.loan_officer_id
LEFT JOIN users cm ON cm.id = l.client_manager_id
LEFT JOIN capital_partners cp ON cp.id = l.capital_partner_id
LEFT JOIN loan_terms t ON t.id = l.current_terms_id
LEFT JOIN vendor_orders ap ON ap.loan_id = l.id AND ap.kind = 'appraisal'
LEFT JOIN parties apv ON apv.id = ap.vendor_party_id
LEFT JOIN vendor_orders bu ON bu.loan_id = l.id AND bu.kind = 'budget_review'
LEFT JOIN reporting.authorization_status auth ON auth.loan_id = l.id
WHERE l.deleted_at IS NULL;

-- Everything still open on every loan — the same list the recurring email sends,
-- in the four words the client sees.
CREATE OR REPLACE VIEW reporting.outstanding_items AS
SELECT
  lr.loan_id, l.loan_number,
  coalesce(lr.label_override, rt.label) AS item,
  rt.group_key,
  p.display_name                        AS guarantor,
  lr.borrower_facing,
  CASE
    WHEN lr.submission_state = 'not_received' THEN 'Outstanding'
    WHEN lr.spreo_state = 'rejected' OR lr.third_party_state = 'rejected' OR lr.underwriter_state = 'rejected' THEN 'Resubmission needed'
    WHEN lr.spreo_state = 'need_additional' OR lr.third_party_state = 'need_additional' OR lr.underwriter_state = 'need_additional' THEN 'More information needed'
    ELSE 'Under Review'
  END AS client_state,
  lr.submission_state, lr.spreo_state, lr.third_party_state,
  lr.released_to_client_at
FROM loan_requirements lr
JOIN loans l ON l.id = lr.loan_id
JOIN requirement_types rt ON rt.id = lr.requirement_type_id
LEFT JOIN parties p ON p.id = lr.party_id
WHERE lr.not_needed_at IS NULL
  AND NOT (lr.third_party_state = 'approved');

-- Every leg of every loan: how long it sat in each status, and who moved it.
-- "Time date in, time date out. And then time date back in, time date back out."
CREATE OR REPLACE VIEW reporting.cycle_times AS
SELECT
  h.loan_id, l.loan_number,
  s.name                                        AS status,
  h.changed_at                                  AS entered_at,
  lead(h.changed_at) OVER (PARTITION BY h.loan_id ORDER BY h.changed_at) AS left_at,
  lead(h.changed_at) OVER (PARTITION BY h.loan_id ORDER BY h.changed_at) - h.changed_at AS time_in_status,
  u.display_name                                AS moved_by,
  h.cause, h.override_reason
FROM loan_status_history h
JOIN loans l ON l.id = h.loan_id
JOIN statuses s ON s.id = h.to_status_id
LEFT JOIN users u ON u.id = h.changed_by;

-- How vendor dates drift — "every time you told us you'd get it by X, you missed it by two days."
CREATE OR REPLACE VIEW reporting.vendor_drift AS
SELECT
  vo.loan_id, l.loan_number, vo.kind, v.display_name AS vendor,
  c.field, c.old_value, c.new_value, (c.new_value - c.old_value) AS days_moved,
  c.changed_at, c.reason
FROM vendor_order_date_changes c
JOIN vendor_orders vo ON vo.id = c.vendor_order_id
JOIN loans l ON l.id = vo.loan_id
LEFT JOIN parties v ON v.id = vo.vendor_party_id;

GRANT USAGE ON SCHEMA reporting TO reporting_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA reporting TO reporting_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA reporting GRANT SELECT ON TABLES TO reporting_reader;
