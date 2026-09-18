-- Spreo OS — Phase 1 database schema (PostgreSQL 15+, Amazon RDS)
-- Generated from database/ (model held in the build repo)*.mjs by db/build.mjs — do not edit by hand; edit the model and rebuild.
--
-- 59 tables in 10 domains. Phase 1 uses 51;
-- 8 are defined now and left empty so Phase 2 is additions only.
--
-- Conventions: uuid keys · timestamptz · numeric(14,2) money · citext emails · lookup tables not enums ·
-- nothing hard-deleted (deleted_at / removed_at / is_current) · every write also lands in events.
-- Files live in S3; this database holds keys, versions and checksums only.

CREATE EXTENSION IF NOT EXISTS citext;     -- case-insensitive emails (gen_random_uuid() is core since PostgreSQL 13)
CREATE EXTENSION IF NOT EXISTS vector;     -- Phase 2 embeddings; remove this line and the embeddings table if not yet enabled on RDS


-- ============================================================================
-- Parties — people and companies
-- Every person and company the process touches, stored once and linked to loans. A guarantor who comes back a year later is the same row, so what Spreo already holds on them can be found. Brokers, AMCs, budget vendors, title, escrow, attorneys, capital partners and servicers are all parties too.
-- ============================================================================

-- A person or a company. One row, however many loans they appear on.
CREATE TABLE parties (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  party_type text NOT NULL CHECK (party_type IN ('person', 'organization')),
  organization_kind text CHECK (organization_kind IN ('broker_company', 'amc', 'budget_vendor', 'title_company', 'escrow_company', 'law_firm', 'flood_vendor', 'insurance_agency', 'capital_partner', 'servicer', 'lender', 'third_party_reviewer', 'borrowing_entity', 'other')),
  first_name text,
  last_name text,
  display_name text NOT NULL,
  organization_id uuid,
  email citext,
  phone text,
  address_line1 text,
  address_line2 text,
  city text,
  state char(2),
  postal_code text,
  license_type text,
  license_number text,
  aliases text[],
  date_of_birth date,
  ssn_last4 char(4),
  notes text,
  search tsvector,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
COMMENT ON TABLE parties IS 'A person or a company. One row, however many loans they appear on.';
COMMENT ON COLUMN parties.id IS 'Unique identifier';
COMMENT ON COLUMN parties.party_type IS 'Person or organization';
COMMENT ON COLUMN parties.organization_kind IS 'For companies: what kind — broker company, AMC, budget vendor, title, escrow, law firm, flood vendor, insurance, capital partner, servicer, lender, third-party reviewer, borrowing entity';
COMMENT ON COLUMN parties.first_name IS 'First name (people)';
COMMENT ON COLUMN parties.last_name IS 'Last name (people)';
COMMENT ON COLUMN parties.display_name IS 'The name shown everywhere — a person''s full name or the company name';
COMMENT ON COLUMN parties.organization_id IS 'The company this person belongs to, if any';
COMMENT ON COLUMN parties.email IS 'Email address — the key used to recognise a guarantor across loans';
COMMENT ON COLUMN parties.phone IS 'Phone number';
COMMENT ON COLUMN parties.address_line1 IS 'Street address';
COMMENT ON COLUMN parties.address_line2 IS 'Suite, unit';
COMMENT ON COLUMN parties.city IS 'City';
COMMENT ON COLUMN parties.state IS 'State';
COMMENT ON COLUMN parties.postal_code IS 'ZIP';
COMMENT ON COLUMN parties.license_type IS 'Broker or attorney licence type';
COMMENT ON COLUMN parties.license_number IS 'Broker or attorney licence number';
COMMENT ON COLUMN parties.aliases IS 'Other names this party is known by — used by the No Fly check';
COMMENT ON COLUMN parties.date_of_birth IS 'Date of birth — only if needed for identity matching [sensitive]';
COMMENT ON COLUMN parties.ssn_last4 IS 'Last four of SSN — only if needed for identity matching [sensitive]';
COMMENT ON COLUMN parties.notes IS 'Free notes about this party';
COMMENT ON COLUMN parties.search IS 'Full-text search index over the name, email and aliases';
COMMENT ON COLUMN parties.created_at IS 'When this row was created';
COMMENT ON COLUMN parties.updated_at IS 'When this row last changed';
COMMENT ON COLUMN parties.deleted_at IS 'Set instead of deleting — the row stays for history';

-- Who plays what role on a loan. Guarantor 1, 2, 3 — the broker — the AMC — the title company — and so on.
CREATE TABLE loan_parties (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  party_id uuid NOT NULL,
  role text NOT NULL CHECK (role IN ('guarantor', 'borrowing_entity', 'broker', 'amc', 'appraiser', 'budget_vendor', 'title', 'escrow', 'legal', 'flood', 'insurance', 'capital_partner', 'current_lender', 'servicer', 'third_party_reviewer')),
  is_primary boolean NOT NULL DEFAULT false,
  ordinal integer,
  ownership_pct numeric(5,2),
  broker_origination_fee_pct numeric(5,3),
  broker_processing_fee numeric(14,2),
  added_at timestamptz NOT NULL DEFAULT now(),
  added_by uuid,
  removed_at timestamptz,
  UNIQUE (loan_id, party_id, role)
);
COMMENT ON TABLE loan_parties IS 'Who plays what role on a loan. Guarantor 1, 2, 3 — the broker — the AMC — the title company — and so on.';
COMMENT ON COLUMN loan_parties.id IS 'Unique identifier';
COMMENT ON COLUMN loan_parties.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN loan_parties.party_id IS 'The person or company';
COMMENT ON COLUMN loan_parties.role IS 'The role on this loan';
COMMENT ON COLUMN loan_parties.is_primary IS 'Guarantor 1 — the one who signs the LOI and the disclosures';
COMMENT ON COLUMN loan_parties.ordinal IS 'Guarantor 1, 2, 3… in the order they were added';
COMMENT ON COLUMN loan_parties.ownership_pct IS 'Share of the project equity this guarantor holds';
COMMENT ON COLUMN loan_parties.broker_origination_fee_pct IS 'Broker only — origination fee, percent';
COMMENT ON COLUMN loan_parties.broker_processing_fee IS 'Broker only — processing fee, dollars';
COMMENT ON COLUMN loan_parties.added_at IS 'When this party joined the loan';
COMMENT ON COLUMN loan_parties.added_by IS 'Who added them';
COMMENT ON COLUMN loan_parties.removed_at IS 'Set when removed — the row stays so history and No Fly overrides survive';

-- The past projects a sponsor claims, and how each one was connected to a guarantor. Initial = the list is in hand; Complete = every row verified.
CREATE TABLE track_record_projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  party_id uuid NOT NULL,
  address text NOT NULL,
  owning_entity text,
  sold_or_stabilized text CHECK (sold_or_stabilized IN ('sold', 'stabilized')),
  completed_on date,
  value numeric(14,2),
  evidence_method text CHECK (evidence_method IN ('title_signature', 'secretary_of_state', 'operating_agreement', 'lease_or_rent_roll', 'jv_agreement')),
  evidence_file_id uuid,
  verified_at timestamptz,
  verified_by uuid,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE track_record_projects IS 'The past projects a sponsor claims, and how each one was connected to a guarantor. Initial = the list is in hand; Complete = every row verified.';
COMMENT ON COLUMN track_record_projects.id IS 'Unique identifier';
COMMENT ON COLUMN track_record_projects.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN track_record_projects.party_id IS 'The guarantor this project is credited to';
COMMENT ON COLUMN track_record_projects.address IS 'The project address';
COMMENT ON COLUMN track_record_projects.owning_entity IS 'The LLC that held it, from title';
COMMENT ON COLUMN track_record_projects.sold_or_stabilized IS 'Sold or stabilized';
COMMENT ON COLUMN track_record_projects.completed_on IS 'When it sold or stabilized — drives the 36-month window';
COMMENT ON COLUMN track_record_projects.value IS 'The project value, for the $10M test';
COMMENT ON COLUMN track_record_projects.evidence_method IS 'How the guarantor was connected to it';
COMMENT ON COLUMN track_record_projects.evidence_file_id IS 'The PDF saved as proof';
COMMENT ON COLUMN track_record_projects.verified_at IS 'When the connection was confirmed';
COMMENT ON COLUMN track_record_projects.verified_by IS 'Who confirmed it';
COMMENT ON COLUMN track_record_projects.notes IS 'Anything odd about this one';
COMMENT ON COLUMN track_record_projects.created_at IS 'When this row was created';


-- ============================================================================
-- Loans — the record
-- The loan itself: where the property is, what kind of loan it is, the permutations that drive the Needs List, where it sits in the process, who owns it, and the facts Dan reads off the pipeline. Terms are versioned so the LOI, the revised structure and the final terms all survive.
-- ============================================================================

-- One row per loan. The five creation fields, the permutations, the pipeline facts and the pointers to everything else.
CREATE TABLE loans (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_number text NOT NULL UNIQUE,
  stage_id uuid NOT NULL,
  status_id uuid NOT NULL,
  status_since timestamptz NOT NULL DEFAULT now(),
  loan_officer_id uuid,
  client_manager_id uuid,
  capital_partner_id uuid,
  current_terms_id uuid,
  property_street text NOT NULL,
  property_city text,
  property_state char(2),
  property_zip text,
  approximate_loan_amount numeric(14,2),
  transaction_type text CHECK (transaction_type IN ('purchase', 'cash_out_refi', 'no_cash_out_refi')),
  loan_type text CHECK (loan_type IN ('bridge', 'light_reno', 'heavy_reno', 'guc', 'dscr')),
  property_type text CHECK (property_type IN ('sfr', 'two_to_four', 'mfr')),
  channel text CHECK (channel IN ('direct', 'broker')),
  portfolio_refinance boolean NOT NULL DEFAULT false,
  repeat_borrower boolean NOT NULL DEFAULT false,
  repeat_broker boolean NOT NULL DEFAULT false,
  global_required boolean NOT NULL DEFAULT false,
  lot_split boolean NOT NULL DEFAULT false,
  condo_map boolean NOT NULL DEFAULT false,
  adus boolean NOT NULL DEFAULT false,
  adding_sf boolean NOT NULL DEFAULT false,
  mid_construction boolean NOT NULL DEFAULT false,
  weather_tight boolean NOT NULL DEFAULT false,
  extra_flags jsonb NOT NULL DEFAULT '{}'::jsonb,
  purchase_price numeric(14,2),
  purchase_date date,
  estimated_aiv numeric(14,2),
  estimated_arv numeric(14,2),
  appraised_aiv numeric(14,2),
  appraised_arv numeric(14,2),
  final_total_budget numeric(14,2),
  estimated_experience_tier text,
  minimum_fico integer,
  minimum_ownership_pct numeric(5,2),
  vom_status text CHECK (vom_status IN ('not_ordered', 'ordered', 'received')),
  payoff_status text CHECK (payoff_status IN ('not_ordered', 'ordered', 'received')),
  escrow_contact_provided boolean NOT NULL DEFAULT false,
  track_record_status text NOT NULL DEFAULT 'no_initial' CHECK (track_record_status IN ('no_initial', 'initial', 'complete')),
  target_submission_date date,
  target_funding_date date,
  loi_funding_date date,
  psa_closing_date date,
  rate_lock_expiration date,
  insurance_paid boolean NOT NULL DEFAULT false,
  created_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);
COMMENT ON TABLE loans IS 'One row per loan. The five creation fields, the permutations, the pipeline facts and the pointers to everything else.';
COMMENT ON COLUMN loans.id IS 'Unique identifier';
COMMENT ON COLUMN loans.loan_number IS 'The human loan number that goes in every email footer';
COMMENT ON COLUMN loans.stage_id IS 'Which of the six stages the loan is in';
COMMENT ON COLUMN loans.status_id IS 'The status within that stage';
COMMENT ON COLUMN loans.status_since IS 'When it entered the current status — days in status counts from here';
COMMENT ON COLUMN loans.loan_officer_id IS 'The LO who brought the deal';
COMMENT ON COLUMN loans.client_manager_id IS 'The CM who owns it from LOI Signed';
COMMENT ON COLUMN loans.capital_partner_id IS 'Fortress, SCIF, Churchill — set before the investor request';
COMMENT ON COLUMN loans.current_terms_id IS 'The terms version in force right now';
COMMENT ON COLUMN loans.property_street IS 'Street address';
COMMENT ON COLUMN loans.property_city IS 'City';
COMMENT ON COLUMN loans.property_state IS 'State — drives whether a Legal Kick-off fires';
COMMENT ON COLUMN loans.property_zip IS 'ZIP';
COMMENT ON COLUMN loans.approximate_loan_amount IS 'The LO''s first estimate — one of the five creation fields';
COMMENT ON COLUMN loans.transaction_type IS 'Purchase, cash-out refinance, no-cash-out refinance';
COMMENT ON COLUMN loans.loan_type IS 'Bridge, Light Reno, Heavy Reno, GUC, DSCR';
COMMENT ON COLUMN loans.property_type IS 'SFR, 2-4 unit, MFR';
COMMENT ON COLUMN loans.channel IS 'Direct or through a broker';
COMMENT ON COLUMN loans.portfolio_refinance IS 'Refinancing a loan Spreo already holds';
COMMENT ON COLUMN loans.repeat_borrower IS 'Spreo has lent to this guarantor before';
COMMENT ON COLUMN loans.repeat_broker IS 'This broker has brought deals before';
COMMENT ON COLUMN loans.global_required IS 'Exposure is large enough to ask for tax returns and investment statements';
COMMENT ON COLUMN loans.lot_split IS 'Add-on: lot split';
COMMENT ON COLUMN loans.condo_map IS 'Add-on: condo map';
COMMENT ON COLUMN loans.adus IS 'Add-on: ADUs';
COMMENT ON COLUMN loans.adding_sf IS 'Add-on: adding square footage — needs Plans';
COMMENT ON COLUMN loans.mid_construction IS 'Add-on: part-built — needs the previous lender''s draw report and spend to date';
COMMENT ON COLUMN loans.weather_tight IS 'Add-on: weather tight';
COMMENT ON COLUMN loans.extra_flags IS 'Any permutation added later without a schema change';
COMMENT ON COLUMN loans.purchase_price IS 'Purchase price';
COMMENT ON COLUMN loans.purchase_date IS 'Purchase date';
COMMENT ON COLUMN loans.estimated_aiv IS 'Estimated as-is value';
COMMENT ON COLUMN loans.estimated_arv IS 'Estimated after-repair value';
COMMENT ON COLUMN loans.appraised_aiv IS 'As-is value from the appraisal';
COMMENT ON COLUMN loans.appraised_arv IS 'After-repair value from the appraisal';
COMMENT ON COLUMN loans.final_total_budget IS 'The construction budget once approved';
COMMENT ON COLUMN loans.estimated_experience_tier IS 'Sponsor experience tier at pre-approval';
COMMENT ON COLUMN loans.minimum_fico IS 'Minimum FICO the deal was priced on';
COMMENT ON COLUMN loans.minimum_ownership_pct IS 'Guarantors must hold at least this share of equity';
COMMENT ON COLUMN loans.vom_status IS 'Verification of Mortgage — refinance only';
COMMENT ON COLUMN loans.payoff_status IS 'Payoff from the current lender — refinance only';
COMMENT ON COLUMN loans.escrow_contact_provided IS 'Purchase only — one of the four gate conditions';
COMMENT ON COLUMN loans.track_record_status IS 'No Initial, Initial, Complete — Initial is a gate condition';
COMMENT ON COLUMN loans.target_submission_date IS 'When the CM aims to submit for review';
COMMENT ON COLUMN loans.target_funding_date IS 'When the CM aims to fund';
COMMENT ON COLUMN loans.loi_funding_date IS 'The funding date written on the LOI';
COMMENT ON COLUMN loans.psa_closing_date IS 'Closing date on the purchase agreement';
COMMENT ON COLUMN loans.rate_lock_expiration IS 'When the rate lock expires';
COMMENT ON COLUMN loans.insurance_paid IS 'Insurance premium paid';
COMMENT ON COLUMN loans.created_by IS 'Who created the record';
COMMENT ON COLUMN loans.created_at IS 'When this row was created';
COMMENT ON COLUMN loans.updated_at IS 'When this row last changed';
COMMENT ON COLUMN loans.deleted_at IS 'Set instead of deleting';

-- The loan's terms, versioned. The LOI is version 1; the revised structure after appraisal and budget is version 2; the final approved terms are the last. Nothing is overwritten.
CREATE TABLE loan_terms (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  version integer NOT NULL,
  kind text NOT NULL CHECK (kind IN ('loi', 'revised', 'final')),
  initial_loan_amount numeric(14,2),
  holdback numeric(14,2),
  interest_reserve numeric(14,2),
  total_loan_amount numeric(14,2),
  note_rate numeric(6,4),
  term_months integer,
  extension_count integer,
  extension_months integer DEFAULT 3,
  extension_fee_pct numeric(6,4),
  origination_fee_pct numeric(6,4),
  processing_fee numeric(14,2),
  draw_fee numeric(14,2),
  recourse_type text CHECK (recourse_type IN ('full', 'limited')),
  prepayment_terms text,
  loi_expiration_date date,
  estimated_funding_date date,
  liquidity_requirement text,
  notes text,
  created_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  approved_internally_at timestamptz,
  approved_externally_at timestamptz,
  UNIQUE (loan_id, version)
);
COMMENT ON TABLE loan_terms IS 'The loan''s terms, versioned. The LOI is version 1; the revised structure after appraisal and budget is version 2; the final approved terms are the last. Nothing is overwritten.';
COMMENT ON COLUMN loan_terms.id IS 'Unique identifier';
COMMENT ON COLUMN loan_terms.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN loan_terms.version IS '1, 2, 3…';
COMMENT ON COLUMN loan_terms.kind IS 'Which version this is';
COMMENT ON COLUMN loan_terms.initial_loan_amount IS 'Funded at close';
COMMENT ON COLUMN loan_terms.holdback IS 'Held back for construction draws';
COMMENT ON COLUMN loan_terms.interest_reserve IS 'Interest reserve';
COMMENT ON COLUMN loan_terms.total_loan_amount IS 'Initial + holdback + interest reserve';
COMMENT ON COLUMN loan_terms.note_rate IS 'The interest rate, e.g. 0.0875';
COMMENT ON COLUMN loan_terms.term_months IS 'Loan term in months';
COMMENT ON COLUMN loan_terms.extension_count IS 'How many 3-month extensions are offered';
COMMENT ON COLUMN loan_terms.extension_months IS 'Length of each extension';
COMMENT ON COLUMN loan_terms.extension_fee_pct IS 'Fee per extension, percent';
COMMENT ON COLUMN loan_terms.origination_fee_pct IS 'Lender origination fee, percent';
COMMENT ON COLUMN loan_terms.processing_fee IS 'Loan docs / due diligence fee';
COMMENT ON COLUMN loan_terms.draw_fee IS 'Per draw';
COMMENT ON COLUMN loan_terms.recourse_type IS 'Full or limited recourse';
COMMENT ON COLUMN loan_terms.prepayment_terms IS 'Prepayment penalty wording';
COMMENT ON COLUMN loan_terms.loi_expiration_date IS 'Conditional offer valid until';
COMMENT ON COLUMN loan_terms.estimated_funding_date IS 'Estimated funding date on the letter';
COMMENT ON COLUMN loan_terms.liquidity_requirement IS 'The cash the guarantors must show, as it prints on the LOI';
COMMENT ON COLUMN loan_terms.notes IS 'The free notes box merged into the LOI';
COMMENT ON COLUMN loan_terms.created_by IS 'Who wrote this version';
COMMENT ON COLUMN loan_terms.created_at IS 'When this row was created';
COMMENT ON COLUMN loan_terms.approved_internally_at IS 'Revised terms: when the LO approved';
COMMENT ON COLUMN loan_terms.approved_externally_at IS 'Revised terms: when the client accepted';

-- Every status change, one row each, with who and why. "Time date in, time date out" — each leg of a back-and-forth is its own row.
CREATE TABLE loan_status_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  from_status_id uuid,
  to_status_id uuid NOT NULL,
  changed_at timestamptz NOT NULL DEFAULT now(),
  changed_by uuid,
  cause text,
  message_id uuid,
  override_reason text,
  correlation_id uuid
);
COMMENT ON TABLE loan_status_history IS 'Every status change, one row each, with who and why. "Time date in, time date out" — each leg of a back-and-forth is its own row.';
COMMENT ON COLUMN loan_status_history.id IS 'Unique identifier';
COMMENT ON COLUMN loan_status_history.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN loan_status_history.from_status_id IS 'Status before';
COMMENT ON COLUMN loan_status_history.to_status_id IS 'Status after';
COMMENT ON COLUMN loan_status_history.changed_at IS 'When';
COMMENT ON COLUMN loan_status_history.changed_by IS 'Who — empty when the system did it';
COMMENT ON COLUMN loan_status_history.cause IS 'What caused it — an email sent, a reply recorded, a gate passed, a manual move';
COMMENT ON COLUMN loan_status_history.message_id IS 'The email that caused it, if one did';
COMMENT ON COLUMN loan_status_history.override_reason IS 'Filled only when a manager overrode a gate';
COMMENT ON COLUMN loan_status_history.correlation_id IS 'Ties this to the request that caused it';

-- Who has owned the loan in each role, over time. Reassigning writes a new row; the old one is closed, not deleted.
CREATE TABLE loan_assignments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  role text NOT NULL CHECK (role IN ('loan_officer', 'client_manager', 'credit', 'closing')),
  user_id uuid NOT NULL,
  assigned_at timestamptz NOT NULL DEFAULT now(),
  unassigned_at timestamptz,
  assigned_by uuid,
  reason text
);
COMMENT ON TABLE loan_assignments IS 'Who has owned the loan in each role, over time. Reassigning writes a new row; the old one is closed, not deleted.';
COMMENT ON COLUMN loan_assignments.id IS 'Unique identifier';
COMMENT ON COLUMN loan_assignments.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN loan_assignments.role IS 'Which seat';
COMMENT ON COLUMN loan_assignments.user_id IS 'Who';
COMMENT ON COLUMN loan_assignments.assigned_at IS 'From';
COMMENT ON COLUMN loan_assignments.unassigned_at IS 'To — empty while current';
COMMENT ON COLUMN loan_assignments.assigned_by IS 'Who made the assignment';
COMMENT ON COLUMN loan_assignments.reason IS 'Why it changed';

-- [Phase 2 — defined now, empty in Phase 1] Reserved for Q15. If Dan wants an On Hold state, a hold is a row here — the loan keeps its stage and status underneath.
CREATE TABLE loan_holds (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  started_at timestamptz NOT NULL DEFAULT now(),
  ended_at timestamptz,
  reason text NOT NULL,
  placed_by uuid,
  lifted_by uuid
);
COMMENT ON TABLE loan_holds IS 'Reserved for Q15. If Dan wants an On Hold state, a hold is a row here — the loan keeps its stage and status underneath.';
COMMENT ON COLUMN loan_holds.id IS 'Unique identifier';
COMMENT ON COLUMN loan_holds.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN loan_holds.started_at IS 'When the hold began';
COMMENT ON COLUMN loan_holds.ended_at IS 'When it lifted';
COMMENT ON COLUMN loan_holds.reason IS 'Why';
COMMENT ON COLUMN loan_holds.placed_by IS 'Who placed it';
COMMENT ON COLUMN loan_holds.lifted_by IS 'Who lifted it';

-- Free-form notes on a loan, or on one thing inside it — a document, a party, a vendor order.
CREATE TABLE notes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  entity_type text CHECK (entity_type IN ('loan', 'loan_requirement', 'party', 'vendor_order', 'approval')),
  entity_id uuid,
  body text NOT NULL,
  pinned boolean NOT NULL DEFAULT false,
  created_by uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE notes IS 'Free-form notes on a loan, or on one thing inside it — a document, a party, a vendor order.';
COMMENT ON COLUMN notes.id IS 'Unique identifier';
COMMENT ON COLUMN notes.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN notes.entity_type IS 'What the note is about — the loan itself, or a requirement, party, order';
COMMENT ON COLUMN notes.entity_id IS 'The specific thing, if not the loan';
COMMENT ON COLUMN notes.body IS 'The note';
COMMENT ON COLUMN notes.pinned IS 'Keep it at the top';
COMMENT ON COLUMN notes.created_by IS 'Who wrote it';
COMMENT ON COLUMN notes.created_at IS 'When this row was created';


-- ============================================================================
-- Configuration — the process as data
-- The stages, statuses and the moves between them; the capital partners and who sends what to each; the attorney states; the No Fly lists; saved views. Phase 1 seeds these tables and shows no screens for them. Phase 2's admin studio is screens over these same tables.
-- ============================================================================

-- The six stages: Pre-Approval, Pre-Processing, Processing, Internal Review, Investor Review, Approved / Closing.
CREATE TABLE stages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text NOT NULL UNIQUE,
  name text NOT NULL,
  ordinal integer NOT NULL,
  owner_role_id uuid
);
COMMENT ON TABLE stages IS 'The six stages: Pre-Approval, Pre-Processing, Processing, Internal Review, Investor Review, Approved / Closing.';
COMMENT ON COLUMN stages.id IS 'Unique identifier';
COMMENT ON COLUMN stages.key IS 'Machine name';
COMMENT ON COLUMN stages.name IS 'Display name';
COMMENT ON COLUMN stages.ordinal IS 'Order across the top of every loan';
COMMENT ON COLUMN stages.owner_role_id IS 'Which role owns the stage';

-- Every status inside every stage, in order — Credit Review through Funded.
CREATE TABLE statuses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  stage_id uuid NOT NULL,
  key text NOT NULL UNIQUE,
  name text NOT NULL,
  ordinal integer NOT NULL,
  is_terminal boolean NOT NULL DEFAULT false
);
COMMENT ON TABLE statuses IS 'Every status inside every stage, in order — Credit Review through Funded.';
COMMENT ON COLUMN statuses.id IS 'Unique identifier';
COMMENT ON COLUMN statuses.stage_id IS 'Which stage it belongs to';
COMMENT ON COLUMN statuses.key IS 'Machine name';
COMMENT ON COLUMN statuses.name IS 'Display name — Dan''s words';
COMMENT ON COLUMN statuses.ordinal IS 'Order within the stage';
COMMENT ON COLUMN statuses.is_terminal IS 'The loan ends here — Not Pre-Approved';

-- Which status can move to which, what has to be true first, and whether a manager can override. The Processing gate is a row here.
CREATE TABLE status_transitions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  from_status_id uuid NOT NULL,
  to_status_id uuid NOT NULL,
  label text,
  trigger_kind text CHECK (trigger_kind IN ('manual', 'email_sent', 'reply_recorded', 'system')),
  gate jsonb NOT NULL DEFAULT '[]'::jsonb,
  allows_override boolean NOT NULL DEFAULT false,
  override_role_id uuid,
  UNIQUE (from_status_id, to_status_id)
);
COMMENT ON TABLE status_transitions IS 'Which status can move to which, what has to be true first, and whether a manager can override. The Processing gate is a row here.';
COMMENT ON COLUMN status_transitions.id IS 'Unique identifier';
COMMENT ON COLUMN status_transitions.from_status_id IS 'From';
COMMENT ON COLUMN status_transitions.to_status_id IS 'To';
COMMENT ON COLUMN status_transitions.label IS 'What the move is called on screen';
COMMENT ON COLUMN status_transitions.trigger_kind IS 'What normally causes it — a person, an email being sent, a reply recorded, the system';
COMMENT ON COLUMN status_transitions.gate IS 'Conditions that must hold — e.g. appraisal paid, escrow contact if purchase, all authorizations signed, track record Initial';
COMMENT ON COLUMN status_transitions.allows_override IS 'A manager may pass the gate with a recorded reason';
COMMENT ON COLUMN status_transitions.override_role_id IS 'Which role may override';

-- Fortress, SCIF, Churchill and any partner added later — with who sends the Final Approval request to each, and which extra documents each wants.
CREATE TABLE capital_partners (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  party_id uuid NOT NULL,
  code text NOT NULL UNIQUE,
  name text NOT NULL,
  final_approval_sender_role_id uuid,
  final_approval_sender_user_id uuid,
  pre_approval_recipients jsonb NOT NULL DEFAULT '[]'::jsonb,
  final_approval_recipients jsonb NOT NULL DEFAULT '[]'::jsonb,
  no_fly_list_id uuid,
  active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE capital_partners IS 'Fortress, SCIF, Churchill and any partner added later — with who sends the Final Approval request to each, and which extra documents each wants.';
COMMENT ON COLUMN capital_partners.id IS 'Unique identifier';
COMMENT ON COLUMN capital_partners.party_id IS 'The partner as an organization';
COMMENT ON COLUMN capital_partners.code IS 'Short code';
COMMENT ON COLUMN capital_partners.name IS 'Display name';
COMMENT ON COLUMN capital_partners.final_approval_sender_role_id IS 'Who sends Final Approval — Client Management for Churchill and SCIF';
COMMENT ON COLUMN capital_partners.final_approval_sender_user_id IS 'Or a named person — a principal for Fortress';
COMMENT ON COLUMN capital_partners.pre_approval_recipients IS 'Who receives the Investor Pre-Approval Request';
COMMENT ON COLUMN capital_partners.final_approval_recipients IS 'Who receives the Final Approval request';
COMMENT ON COLUMN capital_partners.no_fly_list_id IS 'The partner''s own No Fly list, if they supply one';
COMMENT ON COLUMN capital_partners.created_at IS 'When this row was created';
COMMENT ON COLUMN capital_partners.updated_at IS 'When this row last changed';

-- Extra Needs List items a particular capital partner asks for.
CREATE TABLE capital_partner_requirements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  capital_partner_id uuid NOT NULL,
  requirement_type_id uuid NOT NULL,
  condition jsonb,
  UNIQUE (capital_partner_id, requirement_type_id)
);
COMMENT ON TABLE capital_partner_requirements IS 'Extra Needs List items a particular capital partner asks for.';
COMMENT ON COLUMN capital_partner_requirements.id IS 'Unique identifier';
COMMENT ON COLUMN capital_partner_requirements.capital_partner_id IS 'The partner';
COMMENT ON COLUMN capital_partner_requirements.requirement_type_id IS 'The document they want';
COMMENT ON COLUMN capital_partner_requirements.condition IS 'Only when… e.g. global required';

-- The fifty states, flagged for whether an attorney is required — the nineteen attorney states get a Legal Kick-off with state-specific language.
CREATE TABLE jurisdictions (
  state char(2) PRIMARY KEY,
  name text NOT NULL,
  attorney_required boolean NOT NULL DEFAULT false,
  legal_kickoff_variant text,
  notes text
);
COMMENT ON TABLE jurisdictions IS 'The fifty states, flagged for whether an attorney is required — the nineteen attorney states get a Legal Kick-off with state-specific language.';
COMMENT ON COLUMN jurisdictions.state IS 'Two-letter state code';
COMMENT ON COLUMN jurisdictions.name IS 'State name';
COMMENT ON COLUMN jurisdictions.attorney_required IS 'Legal Kick-off fires here';
COMMENT ON COLUMN jurisdictions.legal_kickoff_variant IS 'Which wording variant of the Legal Kick-off to use';
COMMENT ON COLUMN jurisdictions.notes IS 'What the attorney is actually required for, where known';

-- The lists of people Spreo will not lend to. Churchill's and Spreo's own are separate, so a sync from Churchill only replaces Churchill's names.
CREATE TABLE no_fly_lists (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source text NOT NULL CHECK (source IN ('spreo', 'churchill', 'partner')),
  name text NOT NULL,
  capital_partner_id uuid,
  last_loaded_at timestamptz,
  loaded_by uuid
);
COMMENT ON TABLE no_fly_lists IS 'The lists of people Spreo will not lend to. Churchill''s and Spreo''s own are separate, so a sync from Churchill only replaces Churchill''s names.';
COMMENT ON COLUMN no_fly_lists.id IS 'Unique identifier';
COMMENT ON COLUMN no_fly_lists.source IS 'Whose list';
COMMENT ON COLUMN no_fly_lists.name IS 'Display name';
COMMENT ON COLUMN no_fly_lists.capital_partner_id IS 'The partner it belongs to, if any';
COMMENT ON COLUMN no_fly_lists.last_loaded_at IS 'When it was last uploaded or synced';
COMMENT ON COLUMN no_fly_lists.loaded_by IS 'Who loaded it';

-- One row per name on a list, with the aliases, email and phone that help the match.
CREATE TABLE no_fly_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  list_id uuid NOT NULL,
  full_name text NOT NULL,
  aliases text[],
  email citext,
  phone text,
  reason text,
  added_at timestamptz NOT NULL DEFAULT now(),
  added_by uuid,
  removed_at timestamptz
);
COMMENT ON TABLE no_fly_entries IS 'One row per name on a list, with the aliases, email and phone that help the match.';
COMMENT ON COLUMN no_fly_entries.id IS 'Unique identifier';
COMMENT ON COLUMN no_fly_entries.list_id IS 'Which list';
COMMENT ON COLUMN no_fly_entries.full_name IS 'The name as listed';
COMMENT ON COLUMN no_fly_entries.aliases IS 'Other spellings and names';
COMMENT ON COLUMN no_fly_entries.email IS 'Email, if known';
COMMENT ON COLUMN no_fly_entries.phone IS 'Phone, if known';
COMMENT ON COLUMN no_fly_entries.reason IS 'Why they are on the list';
COMMENT ON COLUMN no_fly_entries.removed_at IS 'Set instead of deleting';

-- A hit: this guarantor on this loan matched this entry. Raises the banner and blocks LOI generation until overridden.
CREATE TABLE no_fly_matches (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  party_id uuid NOT NULL,
  entry_id uuid NOT NULL,
  matched_on text NOT NULL CHECK (matched_on IN ('name', 'alias', 'email', 'phone')),
  score numeric(4,3),
  detected_at timestamptz NOT NULL DEFAULT now(),
  acknowledged_by uuid,
  acknowledged_at timestamptz,
  UNIQUE (loan_id, party_id, entry_id)
);
COMMENT ON TABLE no_fly_matches IS 'A hit: this guarantor on this loan matched this entry. Raises the banner and blocks LOI generation until overridden.';
COMMENT ON COLUMN no_fly_matches.id IS 'Unique identifier';
COMMENT ON COLUMN no_fly_matches.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN no_fly_matches.party_id IS 'The guarantor that matched';
COMMENT ON COLUMN no_fly_matches.entry_id IS 'The list entry they matched';
COMMENT ON COLUMN no_fly_matches.matched_on IS 'What matched';
COMMENT ON COLUMN no_fly_matches.score IS 'Match strength, 0–1 — exact in Phase 1, fuzzy later';
COMMENT ON COLUMN no_fly_matches.acknowledged_by IS 'Who acknowledged the pop-up';

-- A manager cleared a match, with a reason. Keeps a snapshot of the party so the record survives even if the guarantor is later removed.
CREATE TABLE no_fly_overrides (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  match_id uuid NOT NULL,
  party_snapshot jsonb NOT NULL,
  reason text NOT NULL,
  overridden_by uuid NOT NULL,
  overridden_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE no_fly_overrides IS 'A manager cleared a match, with a reason. Keeps a snapshot of the party so the record survives even if the guarantor is later removed.';
COMMENT ON COLUMN no_fly_overrides.id IS 'Unique identifier';
COMMENT ON COLUMN no_fly_overrides.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN no_fly_overrides.match_id IS 'The match being cleared';
COMMENT ON COLUMN no_fly_overrides.party_snapshot IS 'Name and details at the time — survives removal';
COMMENT ON COLUMN no_fly_overrides.reason IS 'Why it was cleared';
COMMENT ON COLUMN no_fly_overrides.overridden_by IS 'The manager or admin';

-- [Phase 2 — defined now, empty in Phase 1] Reserved for Q9. If CMs are assigned by rule — this LO always goes to this CM, or round-robin — the rule lives here.
CREATE TABLE assignment_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kind text NOT NULL CHECK (kind IN ('by_loan_officer', 'by_broker', 'round_robin', 'load_balanced')),
  match jsonb NOT NULL DEFAULT '{}'::jsonb,
  assign_role text NOT NULL,
  assign_user_id uuid,
  priority integer NOT NULL DEFAULT 100,
  active boolean NOT NULL DEFAULT true
);
COMMENT ON TABLE assignment_rules IS 'Reserved for Q9. If CMs are assigned by rule — this LO always goes to this CM, or round-robin — the rule lives here.';
COMMENT ON COLUMN assignment_rules.id IS 'Unique identifier';
COMMENT ON COLUMN assignment_rules.kind IS 'By loan officer, by broker, round-robin, load-balanced';
COMMENT ON COLUMN assignment_rules.match IS 'When this rule applies';
COMMENT ON COLUMN assignment_rules.assign_role IS 'Which seat it fills';
COMMENT ON COLUMN assignment_rules.assign_user_id IS 'Who gets it';
COMMENT ON COLUMN assignment_rules.priority IS 'Rules are tried in this order';

-- A person's own pipeline view — which columns, in what order, pinned, filtered, sorted. Shared views for the team.
CREATE TABLE saved_views (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  surface text NOT NULL,
  name text NOT NULL,
  columns jsonb NOT NULL,
  filters jsonb NOT NULL DEFAULT '{}'::jsonb,
  sort jsonb NOT NULL DEFAULT '[]'::jsonb,
  shared boolean NOT NULL DEFAULT false,
  is_default boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE saved_views IS 'A person''s own pipeline view — which columns, in what order, pinned, filtered, sorted. Shared views for the team.';
COMMENT ON COLUMN saved_views.id IS 'Unique identifier';
COMMENT ON COLUMN saved_views.user_id IS 'Whose view';
COMMENT ON COLUMN saved_views.surface IS 'Which screen — pipeline, documents, inboxes';
COMMENT ON COLUMN saved_views.name IS 'View name';
COMMENT ON COLUMN saved_views.columns IS 'Columns, order, pinned';
COMMENT ON COLUMN saved_views.filters IS 'Filters';
COMMENT ON COLUMN saved_views.sort IS 'Sort';
COMMENT ON COLUMN saved_views.shared IS 'Visible to the whole team';
COMMENT ON COLUMN saved_views.is_default IS 'Opens by default';
COMMENT ON COLUMN saved_views.created_at IS 'When this row was created';
COMMENT ON COLUMN saved_views.updated_at IS 'When this row last changed';

-- Small platform settings that are not worth a table of their own — the default recurring cadence, the four business days for the calculated funding date, the prior-evidence validity window.
CREATE TABLE settings (
  key text PRIMARY KEY,
  value jsonb NOT NULL,
  description text,
  updated_by uuid,
  updated_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE settings IS 'Small platform settings that are not worth a table of their own — the default recurring cadence, the four business days for the calculated funding date, the prior-evidence validity window.';
COMMENT ON COLUMN settings.key IS 'Setting name';
COMMENT ON COLUMN settings.value IS 'The value';
COMMENT ON COLUMN settings.description IS 'What it does';
COMMENT ON COLUMN settings.updated_at IS 'When this row last changed';


-- ============================================================================
-- Needs List and documents
-- The catalogue of things Spreo can ask for, the rules that turn permutations into a list, the list itself on each loan (one socket per item, per guarantor where it applies), the files that fill the sockets as S3 versions, the three review layers, follow-up questions, packages, and everything the system generates — LOI, summaries, tapes, loan documents.
-- ============================================================================

-- The document catalogue — every item Spreo could ask for: driver's licence, application, bank statements, PSA, VOM, draft budget… with who sees it and how it travels to third-party review.
CREATE TABLE requirement_types (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text NOT NULL UNIQUE,
  label text NOT NULL,
  group_key text NOT NULL CHECK (group_key IN ('guarantor', 'entity', 'project', 'purchase', 'refinance', 'construction', 'dscr', 'internal', 'closing', 'partner')),
  per_guarantor boolean NOT NULL DEFAULT false,
  borrower_facing boolean NOT NULL DEFAULT true,
  internal boolean NOT NULL DEFAULT false,
  default_routing text NOT NULL DEFAULT 'immediate' CHECK (default_routing IN ('immediate', 'package')),
  locked_to_borrower boolean NOT NULL DEFAULT false,
  validity_days integer,
  signature_channel text CHECK (signature_channel IN ('docusign', 'none')),
  source_note text,
  ordinal integer NOT NULL DEFAULT 100,
  active boolean NOT NULL DEFAULT true
);
COMMENT ON TABLE requirement_types IS 'The document catalogue — every item Spreo could ask for: driver''s licence, application, bank statements, PSA, VOM, draft budget… with who sees it and how it travels to third-party review.';
COMMENT ON COLUMN requirement_types.id IS 'Unique identifier';
COMMENT ON COLUMN requirement_types.key IS 'Machine name';
COMMENT ON COLUMN requirement_types.label IS 'What it is called on screen and in emails';
COMMENT ON COLUMN requirement_types.group_key IS 'Guarantor, entity, project, purchase, refinance, construction, internal, closing';
COMMENT ON COLUMN requirement_types.per_guarantor IS 'One socket per guarantor rather than one per loan';
COMMENT ON COLUMN requirement_types.borrower_facing IS 'The client sees it on their list';
COMMENT ON COLUMN requirement_types.internal IS 'Spreo pulls it itself — credit report, background, PACER, UCC, Google search';
COMMENT ON COLUMN requirement_types.default_routing IS 'Goes to third-party the moment Spreo approves, or waits for its package';
COMMENT ON COLUMN requirement_types.locked_to_borrower IS 'Only the client may upload this — staff cannot satisfy it on their behalf';
COMMENT ON COLUMN requirement_types.validity_days IS 'How long a prior copy stays good — 90 for a credit report';
COMMENT ON COLUMN requirement_types.signature_channel IS 'Sent for signature via DocuSign, or not signed';
COMMENT ON COLUMN requirement_types.source_note IS 'Who named it — Dan Sept, 31 Jul, Jonathan''s sheet';
COMMENT ON COLUMN requirement_types.ordinal IS 'Display order';

-- The rules: when a loan looks like this, add (or remove) that item. Purchase → PSA and escrow contact; refinance → VOM, payoff, mortgage statement; DSCR → leases…
CREATE TABLE needs_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  condition jsonb NOT NULL,
  action text NOT NULL DEFAULT 'add' CHECK (action IN ('add', 'remove')),
  requirement_type_id uuid NOT NULL,
  source_note text,
  ordinal integer NOT NULL DEFAULT 100,
  active boolean NOT NULL DEFAULT true
);
COMMENT ON TABLE needs_rules IS 'The rules: when a loan looks like this, add (or remove) that item. Purchase → PSA and escrow contact; refinance → VOM, payoff, mortgage statement; DSCR → leases…';
COMMENT ON COLUMN needs_rules.id IS 'Unique identifier';
COMMENT ON COLUMN needs_rules.name IS 'Plain-English name of the rule';
COMMENT ON COLUMN needs_rules.condition IS 'What must be true of the loan — e.g. {"transaction_type":"purchase"}';
COMMENT ON COLUMN needs_rules.action IS 'Add the item or remove it';
COMMENT ON COLUMN needs_rules.requirement_type_id IS 'The item';
COMMENT ON COLUMN needs_rules.source_note IS 'Where the rule came from';
COMMENT ON COLUMN needs_rules.ordinal IS 'Rules run in this order';

-- A group of items that travel to third-party review together — the sponsor package, for instance.
CREATE TABLE document_packages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  name text NOT NULL,
  sent_to_third_party_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE document_packages IS 'A group of items that travel to third-party review together — the sponsor package, for instance.';
COMMENT ON COLUMN document_packages.id IS 'Unique identifier';
COMMENT ON COLUMN document_packages.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN document_packages.name IS 'Package name';
COMMENT ON COLUMN document_packages.sent_to_third_party_at IS 'When the whole package went';
COMMENT ON COLUMN document_packages.created_at IS 'When this row was created';

-- The Needs List on a loan — one socket per item, per guarantor where it applies. Carries where the item came from, whether the client sees it, and its state in each of the three review layers.
CREATE TABLE loan_requirements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  requirement_type_id uuid NOT NULL,
  party_id uuid,
  label_override text,
  origin text NOT NULL CHECK (origin IN ('rule', 'partner', 'credit_added', 'cm_added', 'third_party_added', 'underwriter_added', 'carry_over')),
  needs_rule_id uuid,
  package_id uuid,
  routing text NOT NULL DEFAULT 'immediate' CHECK (routing IN ('immediate', 'package')),
  borrower_facing boolean NOT NULL DEFAULT true,
  locked_to_borrower boolean NOT NULL DEFAULT false,
  not_needed_reason text,
  not_needed_by uuid,
  not_needed_at timestamptz,
  restored_at timestamptz,
  carried_from_id uuid,
  submission_state text NOT NULL DEFAULT 'not_received' CHECK (submission_state IN ('not_received', 'received')),
  spreo_state text CHECK (spreo_state IN ('approved', 'rejected', 'need_additional')),
  third_party_state text CHECK (third_party_state IN ('approved', 'rejected', 'need_additional')),
  underwriter_state text CHECK (underwriter_state IN ('approved', 'rejected', 'need_additional')),
  released_to_client_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE loan_requirements IS 'The Needs List on a loan — one socket per item, per guarantor where it applies. Carries where the item came from, whether the client sees it, and its state in each of the three review layers.';
COMMENT ON COLUMN loan_requirements.id IS 'Unique identifier';
COMMENT ON COLUMN loan_requirements.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN loan_requirements.requirement_type_id IS 'What is being asked for';
COMMENT ON COLUMN loan_requirements.party_id IS 'Which guarantor, for per-guarantor items';
COMMENT ON COLUMN loan_requirements.label_override IS 'A one-off label — "LOE for background finding 7/11"';
COMMENT ON COLUMN loan_requirements.origin IS 'Where it came from';
COMMENT ON COLUMN loan_requirements.needs_rule_id IS 'The rule that produced it, if one did';
COMMENT ON COLUMN loan_requirements.package_id IS 'The package it belongs to, if any';
COMMENT ON COLUMN loan_requirements.routing IS 'Immediate or with its package';
COMMENT ON COLUMN loan_requirements.borrower_facing IS 'On the client''s list';
COMMENT ON COLUMN loan_requirements.locked_to_borrower IS 'Only the client may upload it';
COMMENT ON COLUMN loan_requirements.not_needed_reason IS 'Set when Credit marks it not needed — the item goes to the drawer, never deleted';
COMMENT ON COLUMN loan_requirements.restored_at IS 'Brought back from the drawer';
COMMENT ON COLUMN loan_requirements.carried_from_id IS 'The requirement on a prior loan this was carried over from';
COMMENT ON COLUMN loan_requirements.submission_state IS 'Not received, or received — automatic on upload';
COMMENT ON COLUMN loan_requirements.spreo_state IS 'Spreo review — the CM''s decision';
COMMENT ON COLUMN loan_requirements.third_party_state IS 'Third-party review — Setpoint or offshore';
COMMENT ON COLUMN loan_requirements.underwriter_state IS 'Set only when the underwriter asked for something on this item';
COMMENT ON COLUMN loan_requirements.released_to_client_at IS 'When the Kick-off made it visible';
COMMENT ON COLUMN loan_requirements.created_at IS 'When this row was created';
COMMENT ON COLUMN loan_requirements.updated_at IS 'When this row last changed';

-- Every file ever uploaded, as a version. A socket can hold several — three months of bank statements are three files. Replacing keeps the old one; nothing is deleted. The file itself lives in S3.
CREATE TABLE document_files (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  requirement_id uuid NOT NULL,
  s3_bucket text NOT NULL,
  s3_key text NOT NULL,
  s3_version_id text,
  file_name text NOT NULL,
  mime_type text,
  size_bytes bigint,
  sha256 text,
  version_no integer NOT NULL DEFAULT 1,
  mode text NOT NULL DEFAULT 'append' CHECK (mode IN ('append', 'replace')),
  supersedes_id uuid,
  is_current boolean NOT NULL DEFAULT true,
  uploaded_via text NOT NULL CHECK (uploaded_via IN ('portal', 'staff', 'email', 'carry_over', 'system')),
  uploaded_by_user_id uuid,
  uploaded_by_party_id uuid,
  uploaded_at timestamptz NOT NULL DEFAULT now(),
  legal_hold boolean NOT NULL DEFAULT false,
  retention_until date,
  extracted_text text,
  extraction_status text CHECK (extraction_status IN ('pending', 'done', 'failed'))
);
COMMENT ON TABLE document_files IS 'Every file ever uploaded, as a version. A socket can hold several — three months of bank statements are three files. Replacing keeps the old one; nothing is deleted. The file itself lives in S3.';
COMMENT ON COLUMN document_files.id IS 'Unique identifier';
COMMENT ON COLUMN document_files.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN document_files.requirement_id IS 'The socket it fills';
COMMENT ON COLUMN document_files.s3_bucket IS 'Bucket';
COMMENT ON COLUMN document_files.s3_key IS 'Object key';
COMMENT ON COLUMN document_files.s3_version_id IS 'S3 object version';
COMMENT ON COLUMN document_files.file_name IS 'Original file name';
COMMENT ON COLUMN document_files.mime_type IS 'File type';
COMMENT ON COLUMN document_files.size_bytes IS 'Size';
COMMENT ON COLUMN document_files.sha256 IS 'Checksum — detects the same file uploaded twice';
COMMENT ON COLUMN document_files.version_no IS 'Version within the socket';
COMMENT ON COLUMN document_files.mode IS 'Added alongside what was there, or replaced it';
COMMENT ON COLUMN document_files.supersedes_id IS 'The file this one replaced';
COMMENT ON COLUMN document_files.is_current IS 'Still part of what is in the socket';
COMMENT ON COLUMN document_files.uploaded_via IS 'Portal, staff on the client''s behalf, email, carried over, generated';
COMMENT ON COLUMN document_files.uploaded_by_user_id IS 'Staff member, if staff';
COMMENT ON COLUMN document_files.uploaded_by_party_id IS 'Guarantor, if through the portal';
COMMENT ON COLUMN document_files.legal_hold IS 'Must not be purged [Phase 2]';
COMMENT ON COLUMN document_files.retention_until IS 'Earliest date it may be purged [Phase 2]';
COMMENT ON COLUMN document_files.extracted_text IS 'Text pulled from the document for search and the AI layer [Phase 2]';
COMMENT ON COLUMN document_files.extraction_status IS 'Not run, done, failed [Phase 2]';

-- Every review decision on a file — which layer, what was decided, and the note that always goes with it.
CREATE TABLE document_reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  requirement_id uuid NOT NULL,
  file_id uuid,
  layer text NOT NULL CHECK (layer IN ('spreo', 'third_party', 'underwriter')),
  decision text NOT NULL CHECK (decision IN ('approved', 'rejected', 'need_additional')),
  note text NOT NULL,
  round integer NOT NULL DEFAULT 1,
  reviewed_by_user_id uuid,
  reviewed_by_party_id uuid,
  reviewed_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE document_reviews IS 'Every review decision on a file — which layer, what was decided, and the note that always goes with it.';
COMMENT ON COLUMN document_reviews.id IS 'Unique identifier';
COMMENT ON COLUMN document_reviews.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN document_reviews.requirement_id IS 'The socket';
COMMENT ON COLUMN document_reviews.file_id IS 'The specific file reviewed';
COMMENT ON COLUMN document_reviews.layer IS 'Spreo, third-party, or underwriter';
COMMENT ON COLUMN document_reviews.decision IS 'Approved, rejected, need additional';
COMMENT ON COLUMN document_reviews.note IS 'Every decision carries a note — even an approval';
COMMENT ON COLUMN document_reviews.round IS 'Which pass this is';
COMMENT ON COLUMN document_reviews.reviewed_by_user_id IS 'Staff reviewer';
COMMENT ON COLUMN document_reviews.reviewed_by_party_id IS 'Third-party reviewer, when it is Setpoint or offshore';

-- A follow-up question under an existing item — "letter of explanation for the background finding" — rather than a new item. Appears on the client's list in plain words.
CREATE TABLE requirement_followups (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  requirement_id uuid NOT NULL,
  question text NOT NULL,
  asked_by uuid NOT NULL,
  asked_at timestamptz NOT NULL DEFAULT now(),
  borrower_visible boolean NOT NULL DEFAULT true,
  answer_text text,
  answer_file_id uuid,
  answered_at timestamptz,
  resolved_at timestamptz,
  resolved_by uuid
);
COMMENT ON TABLE requirement_followups IS 'A follow-up question under an existing item — "letter of explanation for the background finding" — rather than a new item. Appears on the client''s list in plain words.';
COMMENT ON COLUMN requirement_followups.id IS 'Unique identifier';
COMMENT ON COLUMN requirement_followups.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN requirement_followups.requirement_id IS 'The item it sits under';
COMMENT ON COLUMN requirement_followups.question IS 'The question, in plain words';
COMMENT ON COLUMN requirement_followups.borrower_visible IS 'Shown to the client';
COMMENT ON COLUMN requirement_followups.answer_text IS 'A typed answer';
COMMENT ON COLUMN requirement_followups.answer_file_id IS 'An uploaded answer';
COMMENT ON COLUMN requirement_followups.resolved_at IS 'When Spreo was satisfied';

-- Everything the system produces: the LOI package, each guarantor 2+ authorization, the loan checklist, the loan summary, the investor tape, the servicing tape, the Lightning Docs output. With the exact data it was merged from.
CREATE TABLE generated_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  kind text NOT NULL CHECK (kind IN ('loi_package', 'guarantor_authorization', 'loan_checklist', 'loan_summary', 'investor_tape', 'servicing_tape', 'loan_docs', 'packet')),
  party_id uuid,
  terms_id uuid,
  template_version_id uuid,
  merge_snapshot jsonb NOT NULL,
  s3_key text NOT NULL,
  sha256 text,
  generated_by uuid,
  generated_at timestamptz NOT NULL DEFAULT now(),
  sent_message_id uuid,
  external_reference_id uuid
);
COMMENT ON TABLE generated_documents IS 'Everything the system produces: the LOI package, each guarantor 2+ authorization, the loan checklist, the loan summary, the investor tape, the servicing tape, the Lightning Docs output. With the exact data it was merged from.';
COMMENT ON COLUMN generated_documents.id IS 'Unique identifier';
COMMENT ON COLUMN generated_documents.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN generated_documents.kind IS 'Which document';
COMMENT ON COLUMN generated_documents.party_id IS 'For a per-guarantor document';
COMMENT ON COLUMN generated_documents.terms_id IS 'The terms version it was built from';
COMMENT ON COLUMN generated_documents.template_version_id IS 'Which template version';
COMMENT ON COLUMN generated_documents.merge_snapshot IS 'Every merged value at the moment of generation — so the document can always be explained';
COMMENT ON COLUMN generated_documents.s3_key IS 'The file in S3';
COMMENT ON COLUMN generated_documents.sha256 IS 'Checksum';
COMMENT ON COLUMN generated_documents.sent_message_id IS 'The email it went out on';
COMMENT ON COLUMN generated_documents.external_reference_id IS 'DocuSign envelope, Lightning Docs package';


-- ============================================================================
-- Vendor work — appraisal, budget, title, escrow, legal, flood
-- Every order placed with an outside vendor, in one shape. The appraisal and the budget review carry the most — invoice, inspection, what the vendor still needs, promised against target — because those are the dates Dan manages the business on.
-- ============================================================================

-- One order to one vendor on one loan. Kind says which: appraisal, budget review, title, escrow, legal, flood. Status values depend on the kind — the appraisal ladder is Requested → Invoice Sent → Paid → Received → Under Review → Challenged → Approved Pending Budget → Final.
CREATE TABLE vendor_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  kind text NOT NULL CHECK (kind IN ('appraisal', 'budget_review', 'title', 'escrow', 'legal', 'flood', 'insurance')),
  vendor_party_id uuid,
  status text NOT NULL,
  status_since timestamptz NOT NULL DEFAULT now(),
  ordered_by uuid,
  ordered_at timestamptz,
  order_message_id uuid,
  review_type text CHECK (review_type IN ('scrub', 'feasibility')),
  turnaround_days integer,
  invoice_link text,
  invoice_received_at timestamptz,
  invoice_sent_to_client_at timestamptz,
  invoice_paid_at timestamptz,
  promised_delivery_date date,
  target_delivery_date date,
  vendor_needs text CHECK (vendor_needs IN ('none', 'budget', 'plans', 'budget_and_plans')),
  needs_provided_at timestamptz,
  draft_budget_provided boolean NOT NULL DEFAULT false,
  draft_plans_provided boolean NOT NULL DEFAULT false,
  inspection_scheduled_date date,
  inspection_occurred_date date,
  received_at timestamptz,
  report_file_id uuid,
  under_review_at timestamptz,
  challenged_at timestamptz,
  challenge_note text,
  approved_pending_budget_at timestamptz,
  internally_approved_at timestamptz,
  sent_to_appraiser_at timestamptz,
  client_signoff_at timestamptz,
  final_at timestamptz,
  fee numeric(14,2),
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE vendor_orders IS 'One order to one vendor on one loan. Kind says which: appraisal, budget review, title, escrow, legal, flood. Status values depend on the kind — the appraisal ladder is Requested → Invoice Sent → Paid → Received → Under Review → Challenged → Approved Pending Budget → Final.';
COMMENT ON COLUMN vendor_orders.id IS 'Unique identifier';
COMMENT ON COLUMN vendor_orders.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN vendor_orders.kind IS 'Which vendor process';
COMMENT ON COLUMN vendor_orders.vendor_party_id IS 'The AMC, budget vendor, title company…';
COMMENT ON COLUMN vendor_orders.status IS 'Where the order stands — values per kind';
COMMENT ON COLUMN vendor_orders.status_since IS 'For days in this status';
COMMENT ON COLUMN vendor_orders.ordered_at IS 'When the order email went';
COMMENT ON COLUMN vendor_orders.order_message_id IS 'The order email';
COMMENT ON COLUMN vendor_orders.review_type IS 'Budget review only — Scrub or Feasibility';
COMMENT ON COLUMN vendor_orders.turnaround_days IS 'What the vendor said their turnaround is';
COMMENT ON COLUMN vendor_orders.invoice_link IS 'The AMC''s payment link';
COMMENT ON COLUMN vendor_orders.invoice_received_at IS 'When the AMC sent the invoice';
COMMENT ON COLUMN vendor_orders.invoice_sent_to_client_at IS 'When the CM forwarded it';
COMMENT ON COLUMN vendor_orders.invoice_paid_at IS 'When the client paid — the clock starts here; one of the four gate conditions';
COMMENT ON COLUMN vendor_orders.promised_delivery_date IS 'What the vendor promised';
COMMENT ON COLUMN vendor_orders.target_delivery_date IS 'What Spreo is aiming for';
COMMENT ON COLUMN vendor_orders.vendor_needs IS 'What the vendor still needs from us';
COMMENT ON COLUMN vendor_orders.needs_provided_at IS 'When we gave it to them';
COMMENT ON COLUMN vendor_orders.inspection_scheduled_date IS 'The site visit — the appraiser''s and the budget vendor''s are different visits';
COMMENT ON COLUMN vendor_orders.inspection_occurred_date IS 'When it actually happened';
COMMENT ON COLUMN vendor_orders.received_at IS 'When the report or review arrived';
COMMENT ON COLUMN vendor_orders.report_file_id IS 'The report itself';
COMMENT ON COLUMN vendor_orders.challenged_at IS 'Appraisal only — Spreo disputed the value; the order stays open';
COMMENT ON COLUMN vendor_orders.challenge_note IS 'Why';
COMMENT ON COLUMN vendor_orders.approved_pending_budget_at IS 'Appraisal only — settles to Final once the budget is approved';
COMMENT ON COLUMN vendor_orders.internally_approved_at IS 'Budget only';
COMMENT ON COLUMN vendor_orders.sent_to_appraiser_at IS 'Budget only — when the approved budget went to the appraiser';
COMMENT ON COLUMN vendor_orders.client_signoff_at IS 'Budget only';
COMMENT ON COLUMN vendor_orders.final_at IS 'Done';
COMMENT ON COLUMN vendor_orders.fee IS 'The fee — the appraisal fee shows as POC on the loan documents';
COMMENT ON COLUMN vendor_orders.created_at IS 'When this row was created';
COMMENT ON COLUMN vendor_orders.updated_at IS 'When this row last changed';

-- Every time a promised or target date on an order moves, the old and new values. Dan wants to see the drift so he can manage vendors — "every time you told us you'd get it by X, you missed it by two days."
CREATE TABLE vendor_order_date_changes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  vendor_order_id uuid NOT NULL,
  field text NOT NULL CHECK (field IN ('promised_delivery_date', 'target_delivery_date', 'inspection_scheduled_date')),
  old_value date,
  new_value date,
  changed_at timestamptz NOT NULL DEFAULT now(),
  changed_by uuid,
  reason text
);
COMMENT ON TABLE vendor_order_date_changes IS 'Every time a promised or target date on an order moves, the old and new values. Dan wants to see the drift so he can manage vendors — "every time you told us you''d get it by X, you missed it by two days."';
COMMENT ON COLUMN vendor_order_date_changes.id IS 'Unique identifier';
COMMENT ON COLUMN vendor_order_date_changes.vendor_order_id IS 'The order';
COMMENT ON COLUMN vendor_order_date_changes.field IS 'Which date moved';
COMMENT ON COLUMN vendor_order_date_changes.old_value IS 'Was';
COMMENT ON COLUMN vendor_order_date_changes.new_value IS 'Is';
COMMENT ON COLUMN vendor_order_date_changes.reason IS 'What the vendor or client said';


-- ============================================================================
-- Approvals and reviews
-- Every ask-and-answer loop in the process, in one shape: the Pre-Pre-Approval to Dan, the investor pre-approval, the two loan-structure approvals, the Setpoint request, the internal final approval, the investor final approval. Each round is a row with the request stamped on one side and the reply on the other — so "it took you four days" can always be shown.
-- ============================================================================

-- One round of one approval loop on one loan. Round 2 is a new row. The request email and the recorded reply are both linked.
CREATE TABLE approvals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  kind text NOT NULL CHECK (kind IN ('internal_pre_approval', 'investor_pre_approval', 'structure_internal', 'structure_external', 'third_party_review', 'internal_final', 'investor_final')),
  round integer NOT NULL DEFAULT 1,
  terms_id uuid,
  requested_by uuid NOT NULL,
  requested_at timestamptz NOT NULL DEFAULT now(),
  request_message_id uuid,
  requested_to_user_id uuid,
  requested_to_party_id uuid,
  responded_at timestamptz,
  decision text CHECK (decision IN ('approved', 'not_approved', 'conditionally_approved', 'items_requested', 'feedback_requested', 'accepted', 'declined')),
  decision_note text,
  reply_message_id uuid,
  recorded_by uuid,
  recorded_at timestamptz,
  closed_at timestamptz,
  UNIQUE (loan_id, kind, round)
);
COMMENT ON TABLE approvals IS 'One round of one approval loop on one loan. Round 2 is a new row. The request email and the recorded reply are both linked.';
COMMENT ON COLUMN approvals.id IS 'Unique identifier';
COMMENT ON COLUMN approvals.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN approvals.kind IS 'Which loop';
COMMENT ON COLUMN approvals.round IS '1, 2, 3… each time it goes back and comes again';
COMMENT ON COLUMN approvals.terms_id IS 'The terms version being approved, for the structure and final loops';
COMMENT ON COLUMN approvals.requested_by IS 'Who sent the request';
COMMENT ON COLUMN approvals.requested_at IS 'Time date out';
COMMENT ON COLUMN approvals.request_message_id IS 'The request email';
COMMENT ON COLUMN approvals.requested_to_user_id IS 'An internal approver — Dan, the LO, the underwriter';
COMMENT ON COLUMN approvals.requested_to_party_id IS 'An outside approver — the capital partner, the client, Setpoint';
COMMENT ON COLUMN approvals.responded_at IS 'Time date back in — when the reply arrived';
COMMENT ON COLUMN approvals.decision IS 'The outcome';
COMMENT ON COLUMN approvals.decision_note IS 'What they said';
COMMENT ON COLUMN approvals.reply_message_id IS 'The reply, when it was recorded as a message';
COMMENT ON COLUMN approvals.recorded_by IS 'Who recorded the reply — a person, never a mailbox reader';
COMMENT ON COLUMN approvals.recorded_at IS 'When it was recorded';
COMMENT ON COLUMN approvals.closed_at IS 'When this round was done with';

-- The underwriter's numbered list of what is wrong with the loan as a whole — in their own words, not marks on documents. Nothing approves while one is open. Clearing one needs a note.
CREATE TABLE findings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  approval_id uuid NOT NULL,
  number integer NOT NULL,
  text text NOT NULL,
  raised_by uuid,
  raised_at timestamptz NOT NULL DEFAULT now(),
  resolved_at timestamptz,
  resolved_by uuid,
  resolution_note text,
  category text
);
COMMENT ON TABLE findings IS 'The underwriter''s numbered list of what is wrong with the loan as a whole — in their own words, not marks on documents. Nothing approves while one is open. Clearing one needs a note.';
COMMENT ON COLUMN findings.id IS 'Unique identifier';
COMMENT ON COLUMN findings.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN findings.approval_id IS 'The review round that raised it';
COMMENT ON COLUMN findings.number IS 'Finding 1, 2, 3… as they read in the email';
COMMENT ON COLUMN findings.text IS 'The finding';
COMMENT ON COLUMN findings.resolved_at IS 'When the CM cleared it';
COMMENT ON COLUMN findings.resolution_note IS 'How it was resolved — required to clear';
COMMENT ON COLUMN findings.category IS 'Phase 2 — a category for recurrence reporting [Phase 2]';


-- ============================================================================
-- Communications
-- Every email the system sends, and every reply a person records, on one loan thread with the tracking tag Dan asked for. Templates are versioned so an email can always be reproduced. The recurring Needs List and the vendor triggers live here too. Phase 2's inbound mail, texts and chat land in the same messages table with a different channel.
-- ============================================================================

-- The named emails — Internal Pre-Approval Request, LOI Issue, Appraisal Order, Hand-off, Pre-Processing, Kick-off, Title Kick-off… about thirty. Two are body-typed rather than composed.
CREATE TABLE email_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text NOT NULL UNIQUE,
  name text NOT NULL,
  stage_id uuid,
  sender_role_id uuid,
  body_mode text NOT NULL DEFAULT 'composed' CHECK (body_mode IN ('composed', 'manual')),
  category text NOT NULL CHECK (category IN ('approval', 'order', 'kickoff', 'client', 'vendor', 'review', 'closing', 'automatic')),
  one_off boolean NOT NULL DEFAULT false,
  moves_status_to_id uuid,
  active boolean NOT NULL DEFAULT true
);
COMMENT ON TABLE email_templates IS 'The named emails — Internal Pre-Approval Request, LOI Issue, Appraisal Order, Hand-off, Pre-Processing, Kick-off, Title Kick-off… about thirty. Two are body-typed rather than composed.';
COMMENT ON COLUMN email_templates.id IS 'Unique identifier';
COMMENT ON COLUMN email_templates.key IS 'Machine name';
COMMENT ON COLUMN email_templates.name IS 'Dan''s name for it';
COMMENT ON COLUMN email_templates.stage_id IS 'The stage it belongs to';
COMMENT ON COLUMN email_templates.sender_role_id IS 'Who normally sends it';
COMMENT ON COLUMN email_templates.body_mode IS 'Composed by the template, or the subject only with the body typed by the sender';
COMMENT ON COLUMN email_templates.category IS 'Approval, order, kick-off, client, vendor, review, closing, automatic';
COMMENT ON COLUMN email_templates.one_off IS 'Available any time rather than at a step — Request LOE';
COMMENT ON COLUMN email_templates.moves_status_to_id IS 'Sending it moves the loan to this status, if any';

-- The wording of a template at a point in time. A sent email always points at the exact version it used.
CREATE TABLE email_template_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id uuid NOT NULL,
  version integer NOT NULL,
  subject_template text NOT NULL,
  body_template text,
  recipient_rules jsonb NOT NULL DEFAULT '{}'::jsonb,
  attachment_rules jsonb NOT NULL DEFAULT '[]'::jsonb,
  variants jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  published_at timestamptz,
  UNIQUE (template_id, version)
);
COMMENT ON TABLE email_template_versions IS 'The wording of a template at a point in time. A sent email always points at the exact version it used.';
COMMENT ON COLUMN email_template_versions.id IS 'Unique identifier';
COMMENT ON COLUMN email_template_versions.template_id IS 'The template';
COMMENT ON COLUMN email_template_versions.subject_template IS 'Subject with merge fields — always carries the address';
COMMENT ON COLUMN email_template_versions.body_template IS 'Body with merge fields — the footer always carries the loan number';
COMMENT ON COLUMN email_template_versions.recipient_rules IS 'To, cc, bcc as tokens — lo, cm, guarantor1, guarantors, broker, amc, title…';
COMMENT ON COLUMN email_template_versions.attachment_rules IS 'What to attach — the LOI package, the loan summary, the files';
COMMENT ON COLUMN email_template_versions.variants IS 'Wording variants — the Legal Kick-off by state, the budget order by transaction type';
COMMENT ON COLUMN email_template_versions.created_at IS 'When this row was created';
COMMENT ON COLUMN email_template_versions.published_at IS 'When this version became the live one';

-- A conversation on a loan. Carries the tracking tag that lets a reply be matched back — the building block Dan asked for so Phase 2 can read replies.
CREATE TABLE threads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  subject text NOT NULL,
  tracking_tag text NOT NULL UNIQUE,
  kind text CHECK (kind IN ('approval', 'order', 'client', 'vendor', 'review', 'internal', 'other')),
  created_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE threads IS 'A conversation on a loan. Carries the tracking tag that lets a reply be matched back — the building block Dan asked for so Phase 2 can read replies.';
COMMENT ON COLUMN threads.id IS 'Unique identifier';
COMMENT ON COLUMN threads.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN threads.subject IS 'Thread subject';
COMMENT ON COLUMN threads.tracking_tag IS 'The tag in every subject and footer';
COMMENT ON COLUMN threads.kind IS 'What the thread is about';
COMMENT ON COLUMN threads.created_at IS 'When this row was created';

-- Every message, out or in. Phase 1 sends email and records replies by hand; Phase 2 adds inbound email, text and chat as new channels on the same table.
CREATE TABLE messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  thread_id uuid,
  direction text NOT NULL CHECK (direction IN ('outbound', 'inbound')),
  channel text NOT NULL DEFAULT 'email' CHECK (channel IN ('email', 'portal', 'sms', 'chat')),
  template_version_id uuid,
  subject text NOT NULL,
  body_html text,
  body_text text,
  from_address citext,
  from_user_id uuid,
  sent_at timestamptz,
  delivery_state text NOT NULL DEFAULT 'draft' CHECK (delivery_state IN ('draft', 'queued', 'sent', 'delivered', 'failed', 'simulated')),
  provider_message_id text,
  in_reply_to_id uuid,
  received_at timestamptz,
  recorded_by uuid,
  correlation_id uuid,
  created_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE messages IS 'Every message, out or in. Phase 1 sends email and records replies by hand; Phase 2 adds inbound email, text and chat as new channels on the same table.';
COMMENT ON COLUMN messages.id IS 'Unique identifier';
COMMENT ON COLUMN messages.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN messages.thread_id IS 'The thread';
COMMENT ON COLUMN messages.direction IS 'Outbound or inbound';
COMMENT ON COLUMN messages.channel IS 'Email in Phase 1; portal, SMS and chat later';
COMMENT ON COLUMN messages.template_version_id IS 'The exact template wording used';
COMMENT ON COLUMN messages.subject IS 'As sent — address first';
COMMENT ON COLUMN messages.body_html IS 'The body as sent';
COMMENT ON COLUMN messages.body_text IS 'Plain-text body';
COMMENT ON COLUMN messages.from_address IS 'Sender address';
COMMENT ON COLUMN messages.from_user_id IS 'The staff member who sent it';
COMMENT ON COLUMN messages.sent_at IS 'When it left';
COMMENT ON COLUMN messages.delivery_state IS 'Draft, queued, sent, delivered, failed — simulated in the prototype';
COMMENT ON COLUMN messages.provider_message_id IS 'The mail provider''s id';
COMMENT ON COLUMN messages.in_reply_to_id IS 'The message this answers';
COMMENT ON COLUMN messages.received_at IS 'Inbound — when it arrived';
COMMENT ON COLUMN messages.recorded_by IS 'Inbound in Phase 1 — the person who recorded the reply';
COMMENT ON COLUMN messages.correlation_id IS 'Ties the send to the status change and the audit rows it caused';
COMMENT ON COLUMN messages.created_at IS 'When this row was created';

-- Who each message went to — resolved from the loan's own parties and staff, never typed. What could not be resolved is reported, not dropped.
CREATE TABLE message_recipients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id uuid NOT NULL,
  kind text NOT NULL CHECK (kind IN ('to', 'cc', 'bcc')),
  party_id uuid,
  user_id uuid,
  address citext NOT NULL,
  resolved_from text
);
COMMENT ON TABLE message_recipients IS 'Who each message went to — resolved from the loan''s own parties and staff, never typed. What could not be resolved is reported, not dropped.';
COMMENT ON COLUMN message_recipients.id IS 'Unique identifier';
COMMENT ON COLUMN message_recipients.kind IS 'To, cc or bcc — the only bcc in the system is the LO on the budget order';
COMMENT ON COLUMN message_recipients.party_id IS 'An outside recipient';
COMMENT ON COLUMN message_recipients.user_id IS 'A staff recipient';
COMMENT ON COLUMN message_recipients.address IS 'The address it was sent to';
COMMENT ON COLUMN message_recipients.resolved_from IS 'The token that produced it — guarantor1, broker, amc…';

-- What was attached — a generated document, a file from a socket, or something added by hand.
CREATE TABLE message_attachments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id uuid NOT NULL,
  generated_document_id uuid,
  document_file_id uuid,
  s3_key text,
  file_name text NOT NULL
);
COMMENT ON TABLE message_attachments IS 'What was attached — a generated document, a file from a socket, or something added by hand.';
COMMENT ON COLUMN message_attachments.id IS 'Unique identifier';
COMMENT ON COLUMN message_attachments.generated_document_id IS 'The LOI package, the loan summary…';
COMMENT ON COLUMN message_attachments.document_file_id IS 'A file from a socket';
COMMENT ON COLUMN message_attachments.s3_key IS 'Something attached by hand';

-- The recurring Needs List cadence, per loan: daily at a set time, every workday, or chosen days and times each week. Mon/Wed/Fri 8am by default.
CREATE TABLE send_schedules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  template_id uuid NOT NULL,
  cadence text NOT NULL CHECK (cadence IN ('daily', 'workdays', 'weekly_days')),
  days_of_week integer[],
  send_time time NOT NULL,
  timezone text NOT NULL DEFAULT 'America/Los_Angeles',
  active boolean NOT NULL DEFAULT true,
  next_run_at timestamptz,
  last_sent_at timestamptz,
  last_message_id uuid,
  created_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (loan_id, template_id)
);
COMMENT ON TABLE send_schedules IS 'The recurring Needs List cadence, per loan: daily at a set time, every workday, or chosen days and times each week. Mon/Wed/Fri 8am by default.';
COMMENT ON COLUMN send_schedules.id IS 'Unique identifier';
COMMENT ON COLUMN send_schedules.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN send_schedules.template_id IS 'The recurring template';
COMMENT ON COLUMN send_schedules.cadence IS 'Daily, workdays, or specific days';
COMMENT ON COLUMN send_schedules.days_of_week IS '0–6 when weekly_days';
COMMENT ON COLUMN send_schedules.send_time IS 'Local time of day';
COMMENT ON COLUMN send_schedules.active IS 'Off once nothing is outstanding, or paused by hand';
COMMENT ON COLUMN send_schedules.next_run_at IS 'Computed';
COMMENT ON COLUMN send_schedules.last_message_id IS 'The last one that went';
COMMENT ON COLUMN send_schedules.created_at IS 'When this row was created';
COMMENT ON COLUMN send_schedules.updated_at IS 'When this row last changed';

-- The vendor trigger emails and their conditions — invoice unpaid 48 hours after sending, inspection confirmation the day after, needs outstanding, delivery check-in. Not SLAs; just triggers.
CREATE TABLE triggers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text NOT NULL UNIQUE,
  name text NOT NULL,
  template_id uuid NOT NULL,
  applies_to_kind text NOT NULL CHECK (applies_to_kind IN ('appraisal', 'budget_review')),
  condition jsonb NOT NULL,
  repeat_hours integer,
  active boolean NOT NULL DEFAULT true,
  source_note text
);
COMMENT ON TABLE triggers IS 'The vendor trigger emails and their conditions — invoice unpaid 48 hours after sending, inspection confirmation the day after, needs outstanding, delivery check-in. Not SLAs; just triggers.';
COMMENT ON COLUMN triggers.id IS 'Unique identifier';
COMMENT ON COLUMN triggers.template_id IS 'What to send';
COMMENT ON COLUMN triggers.applies_to_kind IS 'Appraisal or budget review';
COMMENT ON COLUMN triggers.condition IS 'The rule — field, comparison, offset';
COMMENT ON COLUMN triggers.repeat_hours IS 'Fire again after this many hours while still true — empty means once';
COMMENT ON COLUMN triggers.source_note IS 'Where it came from';

-- Each time a trigger fired, on which order, and the email it produced — so nothing fires twice and the history is visible.
CREATE TABLE trigger_firings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trigger_id uuid NOT NULL,
  loan_id uuid NOT NULL,
  vendor_order_id uuid NOT NULL,
  fired_at timestamptz NOT NULL DEFAULT now(),
  message_id uuid,
  condition_snapshot jsonb
);
COMMENT ON TABLE trigger_firings IS 'Each time a trigger fired, on which order, and the email it produced — so nothing fires twice and the history is visible.';
COMMENT ON COLUMN trigger_firings.id IS 'Unique identifier';
COMMENT ON COLUMN trigger_firings.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN trigger_firings.vendor_order_id IS 'The order it was about';
COMMENT ON COLUMN trigger_firings.message_id IS 'The email';
COMMENT ON COLUMN trigger_firings.condition_snapshot IS 'What was true at the moment';


-- ============================================================================
-- Closing and funding
-- What Closing needs to run Lightning Docs — Closing's field set — and what is captured after: the five closing statuses as dates, the wire reference, the funding date, the tapes. Phase 2's construction draws, servicing, extensions and payoff attach to the loan from here as new tables; nothing here changes.
-- ============================================================================

-- One row per loan. The Lightning Docs field set, filled by Closing once the capital partner has approved, then the closing milestones as they happen.
CREATE TABLE loan_closing (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  funding_entity text,
  loan_servicer_party_id uuid,
  borrower_notice_address text,
  borrower_signatories jsonb,
  guaranty_type text CHECK (guaranty_type IN ('full', 'limited')),
  guarantor_details jsonb,
  lien_position text,
  broker_license_number text,
  broker_address text,
  property_apn text,
  release_pricing text,
  governing_law_state char(2),
  governing_law_county text,
  default_interest_rate numeric(6,4),
  interest_only boolean,
  amortization_term_months integer,
  mers_id text,
  construction_reserve_type text,
  dutch_interest boolean,
  prepayment_premium text,
  escrows jsonb,
  title_report_number text,
  title_report_effective_date date,
  title_exceptions_to_remove text,
  appraisal_fee numeric(14,2),
  signature_affidavit_info text,
  lightning_docs_generated_at timestamptz,
  docs_approved_at timestamptz,
  docs_sent_at timestamptz,
  docs_signed_at timestamptz,
  cleared_to_close_at timestamptz,
  funded_at timestamptz,
  wire_reference text,
  funding_date date,
  servicing_tape_generated_at timestamptz,
  updated_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (loan_id)
);
COMMENT ON TABLE loan_closing IS 'One row per loan. The Lightning Docs field set, filled by Closing once the capital partner has approved, then the closing milestones as they happen.';
COMMENT ON COLUMN loan_closing.id IS 'Unique identifier';
COMMENT ON COLUMN loan_closing.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN loan_closing.funding_entity IS 'Which Spreo entity funds';
COMMENT ON COLUMN loan_closing.loan_servicer_party_id IS 'Who services the loan after funding';
COMMENT ON COLUMN loan_closing.borrower_signatories IS 'Names and titles of who signs for the borrowing entity';
COMMENT ON COLUMN loan_closing.guaranty_type IS 'Full or limited recourse';
COMMENT ON COLUMN loan_closing.guarantor_details IS 'Per guarantor: marital status, notice address [sensitive]';
COMMENT ON COLUMN loan_closing.broker_license_number IS 'On the documents';
COMMENT ON COLUMN loan_closing.property_apn IS 'Assessor''s parcel number';
COMMENT ON COLUMN loan_closing.release_pricing IS 'If applicable';
COMMENT ON COLUMN loan_closing.governing_law_county IS 'County, not country — a known typo in the source';
COMMENT ON COLUMN loan_closing.mers_id IS 'If applicable';
COMMENT ON COLUMN loan_closing.dutch_interest IS 'Dutch or non-Dutch interest';
COMMENT ON COLUMN loan_closing.escrows IS 'Tax, insurance, PITI escrows, if applicable';
COMMENT ON COLUMN loan_closing.appraisal_fee IS 'Shown as POC';
COMMENT ON COLUMN loan_closing.signature_affidavit_info IS 'AKA statement details where the legal name differs';
COMMENT ON COLUMN loan_closing.lightning_docs_generated_at IS 'When the documents were generated';
COMMENT ON COLUMN loan_closing.docs_approved_at IS 'Docs Approved';
COMMENT ON COLUMN loan_closing.docs_sent_at IS 'Docs Sent — to Escrow';
COMMENT ON COLUMN loan_closing.docs_signed_at IS 'Docs Signed';
COMMENT ON COLUMN loan_closing.cleared_to_close_at IS 'Cleared to Close';
COMMENT ON COLUMN loan_closing.funded_at IS 'Funded';
COMMENT ON COLUMN loan_closing.wire_reference IS 'Captured after funding';
COMMENT ON COLUMN loan_closing.funding_date IS 'Captured after funding';
COMMENT ON COLUMN loan_closing.servicing_tape_generated_at IS 'Only possible once Funded';
COMMENT ON COLUMN loan_closing.created_at IS 'When this row was created';
COMMENT ON COLUMN loan_closing.updated_at IS 'When this row last changed';

-- [Phase 2 — defined now, empty in Phase 1] Reserved for Q16 — Closing's post-Lightning-Docs review and QC checklist, once it reaches us. Each item ticked with who and when.
CREATE TABLE closing_checklist_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_id uuid NOT NULL,
  item_key text NOT NULL,
  label text NOT NULL,
  required boolean NOT NULL DEFAULT true,
  completed_at timestamptz,
  completed_by uuid,
  note text,
  UNIQUE (loan_id, item_key)
);
COMMENT ON TABLE closing_checklist_items IS 'Reserved for Q16 — Closing''s post-Lightning-Docs review and QC checklist, once it reaches us. Each item ticked with who and when.';
COMMENT ON COLUMN closing_checklist_items.id IS 'Unique identifier';
COMMENT ON COLUMN closing_checklist_items.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN closing_checklist_items.item_key IS 'Which checklist item';


-- ============================================================================
-- People, roles and who sees what
-- Staff accounts, the seven roles and what each may do, which fields appear at which stage to which role, and the personal links guarantors use to reach their portal. The role matrix is data, enforced in one place, so Phase 2 can edit it without a release.
-- ============================================================================

-- A member of Spreo staff — LO, Credit, CM, underwriter, Closing, admin. Outside parties are never users; they get links.
CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email citext NOT NULL UNIQUE,
  first_name text NOT NULL,
  last_name text NOT NULL,
  display_name text NOT NULL,
  title text,
  phone text,
  active boolean NOT NULL DEFAULT true,
  last_login_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE users IS 'A member of Spreo staff — LO, Credit, CM, underwriter, Closing, admin. Outside parties are never users; they get links.';
COMMENT ON COLUMN users.id IS 'Unique identifier';
COMMENT ON COLUMN users.email IS 'Login and address';
COMMENT ON COLUMN users.display_name IS 'As shown on screen and in email signatures';
COMMENT ON COLUMN users.title IS 'Job title';
COMMENT ON COLUMN users.active IS 'Deactivated staff keep their history';
COMMENT ON COLUMN users.created_at IS 'When this row was created';
COMMENT ON COLUMN users.updated_at IS 'When this row last changed';

-- The roles: Loan Officer, Credit, Client Management, Third-Party Review, Internal Underwrite, Closing, Admin — and the permission matrix as data. Q13 may add Management.
CREATE TABLE roles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text NOT NULL UNIQUE,
  name text NOT NULL,
  description text,
  permissions jsonb NOT NULL DEFAULT '{}'::jsonb,
  is_system boolean NOT NULL DEFAULT true
);
COMMENT ON TABLE roles IS 'The roles: Loan Officer, Credit, Client Management, Third-Party Review, Internal Underwrite, Closing, Admin — and the permission matrix as data. Q13 may add Management.';
COMMENT ON COLUMN roles.id IS 'Unique identifier';
COMMENT ON COLUMN roles.description IS 'What this role owns, in a sentence';
COMMENT ON COLUMN roles.permissions IS 'The matrix: surface → read / edit / act. One place; the API refuses what it does not grant';
COMMENT ON COLUMN roles.is_system IS 'Cannot be deleted';

-- Who holds which role. A person can hold more than one.
CREATE TABLE user_roles (
  user_id uuid NOT NULL,
  role_id uuid NOT NULL,
  granted_at timestamptz NOT NULL DEFAULT now(),
  granted_by uuid,
  PRIMARY KEY (user_id, role_id)
);
COMMENT ON TABLE user_roles IS 'Who holds which role. A person can hold more than one.';

-- Every field on the loan record: which tab it sits on, from which stage it appears, which roles see it, which may edit it, and what it is required for. This is how the tabs stay clean — the direct fix for LendingWise.
CREATE TABLE field_definitions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  entity text NOT NULL CHECK (entity IN ('loans', 'loan_terms', 'loan_closing', 'vendor_orders', 'loan_parties', 'parties')),
  field text NOT NULL,
  label text NOT NULL,
  tab text NOT NULL CHECK (tab IN ('sponsor', 'project', 'loan', 'transaction', 'contacts', 'uw_material', 'communications', 'reporting', 'pulse')),
  group_key text,
  stage_from_id uuid,
  visible_roles text[] NOT NULL,
  editable_roles text[] NOT NULL,
  required_for text[],
  conditions jsonb NOT NULL DEFAULT '{}'::jsonb,
  ordinal integer NOT NULL DEFAULT 100,
  source_note text,
  UNIQUE (entity, field)
);
COMMENT ON TABLE field_definitions IS 'Every field on the loan record: which tab it sits on, from which stage it appears, which roles see it, which may edit it, and what it is required for. This is how the tabs stay clean — the direct fix for LendingWise.';
COMMENT ON COLUMN field_definitions.id IS 'Unique identifier';
COMMENT ON COLUMN field_definitions.entity IS 'Which table the field is on';
COMMENT ON COLUMN field_definitions.field IS 'The column name';
COMMENT ON COLUMN field_definitions.label IS 'What it is called on screen — Dan''s words';
COMMENT ON COLUMN field_definitions.tab IS 'Sponsor, Project, Loan, Transaction, Contacts, UW Material, Communications, Reporting, Pulse';
COMMENT ON COLUMN field_definitions.group_key IS 'The popup it opens in';
COMMENT ON COLUMN field_definitions.stage_from_id IS 'Hidden until this stage is reached';
COMMENT ON COLUMN field_definitions.visible_roles IS 'Roles that see it';
COMMENT ON COLUMN field_definitions.editable_roles IS 'Roles that may edit it';
COMMENT ON COLUMN field_definitions.required_for IS 'What it blocks if empty — loi_generation, lightning_docs';
COMMENT ON COLUMN field_definitions.conditions IS 'Only shown when… e.g. transaction_type = refinance';
COMMENT ON COLUMN field_definitions.source_note IS 'Jonathan''s sheet row, Dan''s document';

-- A guarantor's personal link to their portal — no username or password. One per guarantor per loan, revocable, expiring.
CREATE TABLE portal_links (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  loan_party_id uuid NOT NULL,
  token_hash text NOT NULL UNIQUE,
  issued_at timestamptz NOT NULL DEFAULT now(),
  expires_at timestamptz,
  revoked_at timestamptz,
  last_used_at timestamptz,
  use_count integer NOT NULL DEFAULT 0
);
COMMENT ON TABLE portal_links IS 'A guarantor''s personal link to their portal — no username or password. One per guarantor per loan, revocable, expiring.';
COMMENT ON COLUMN portal_links.id IS 'Unique identifier';
COMMENT ON COLUMN portal_links.loan_party_id IS 'The guarantor on the loan';
COMMENT ON COLUMN portal_links.token_hash IS 'The link token, hashed — the plain token is only ever in the email';

-- [Phase 2 — defined now, empty in Phase 1] Reserved. Cover-for-me: one person acting in another's role for a period.
CREATE TABLE delegations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  from_user_id uuid NOT NULL,
  to_user_id uuid NOT NULL,
  role_id uuid NOT NULL,
  starts_at timestamptz NOT NULL,
  ends_at timestamptz NOT NULL,
  created_by uuid
);
COMMENT ON TABLE delegations IS 'Reserved. Cover-for-me: one person acting in another''s role for a period.';
COMMENT ON COLUMN delegations.id IS 'Unique identifier';
COMMENT ON COLUMN delegations.from_user_id IS 'Who is away';
COMMENT ON COLUMN delegations.to_user_id IS 'Who covers';
COMMENT ON COLUMN delegations.role_id IS 'For which role';


-- ============================================================================
-- Platform — audit, integrations, intelligence
-- The append-only record of everything that happened; the outbox that makes every call to DocuSign, Lightning Docs and the mail provider durable and never duplicated; the ids other systems know our records by; and the tables the Phase 2 intelligence layer writes to — kept apart from the core so AI never touches the transactional tables directly.
-- ============================================================================

-- The audit trail. One row per thing that happened: who, when, to what, before and after. Never updated, never deleted. Every report about accountability reads this.
CREATE TABLE events (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  occurred_at timestamptz NOT NULL DEFAULT now(),
  actor_kind text NOT NULL CHECK (actor_kind IN ('user', 'party', 'system')),
  actor_user_id uuid,
  actor_party_id uuid,
  loan_id uuid,
  entity_type text NOT NULL,
  entity_id text NOT NULL,
  action text NOT NULL,
  before jsonb,
  after jsonb,
  correlation_id uuid,
  request_id text,
  note text
);
COMMENT ON TABLE events IS 'The audit trail. One row per thing that happened: who, when, to what, before and after. Never updated, never deleted. Every report about accountability reads this.';
COMMENT ON COLUMN events.id IS 'Sequence';
COMMENT ON COLUMN events.actor_kind IS 'A staff member, an outside party through the portal, or the system';
COMMENT ON COLUMN events.loan_id IS 'The loan, when there is one — for fast lookup';
COMMENT ON COLUMN events.entity_type IS 'Which table';
COMMENT ON COLUMN events.entity_id IS 'Which row';
COMMENT ON COLUMN events.action IS 'Created, updated, status changed, sent, uploaded, reviewed, override…';
COMMENT ON COLUMN events.before IS 'The changed fields, before';
COMMENT ON COLUMN events.after IS 'The changed fields, after';
COMMENT ON COLUMN events.correlation_id IS 'Groups everything one request caused';
COMMENT ON COLUMN events.request_id IS 'The API request';
COMMENT ON COLUMN events.note IS 'The reason, when one was given';

-- Work for the outside world, queued durably: send this email, create this DocuSign envelope, generate these documents. Picked up by the background worker over SQS; retried; dead-lettered if it keeps failing; never done twice thanks to the idempotency key.
CREATE TABLE integration_outbox (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  kind text NOT NULL CHECK (kind IN ('email_send', 'docusign_envelope', 'lightning_docs_generate', 'setpoint_push', 'streamline_push', 'webhook')),
  entity_type text NOT NULL,
  entity_id uuid NOT NULL,
  idempotency_key text NOT NULL UNIQUE,
  payload jsonb NOT NULL,
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'in_flight', 'done', 'failed', 'dead')),
  attempts integer NOT NULL DEFAULT 0,
  next_attempt_at timestamptz,
  last_error text,
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz
);
COMMENT ON TABLE integration_outbox IS 'Work for the outside world, queued durably: send this email, create this DocuSign envelope, generate these documents. Picked up by the background worker over SQS; retried; dead-lettered if it keeps failing; never done twice thanks to the idempotency key.';
COMMENT ON COLUMN integration_outbox.id IS 'Unique identifier';
COMMENT ON COLUMN integration_outbox.kind IS 'What to do';
COMMENT ON COLUMN integration_outbox.entity_type IS 'What it is about';
COMMENT ON COLUMN integration_outbox.idempotency_key IS 'Same key, same job — never duplicated';
COMMENT ON COLUMN integration_outbox.payload IS 'Everything the worker needs';
COMMENT ON COLUMN integration_outbox.created_at IS 'When this row was created';

-- What the outside world tells us: DocuSign says an envelope was signed; later, a vendor form was submitted or an email arrived. Stored raw first, then processed.
CREATE TABLE integration_inbox (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  provider text NOT NULL CHECK (provider IN ('docusign', 'lightning_docs', 'mail', 'vendor_form', 'setpoint')),
  external_event_id text NOT NULL UNIQUE,
  received_at timestamptz NOT NULL DEFAULT now(),
  payload jsonb NOT NULL,
  processed_at timestamptz,
  outcome text,
  error text
);
COMMENT ON TABLE integration_inbox IS 'What the outside world tells us: DocuSign says an envelope was signed; later, a vendor form was submitted or an email arrived. Stored raw first, then processed.';
COMMENT ON COLUMN integration_inbox.id IS 'Unique identifier';
COMMENT ON COLUMN integration_inbox.external_event_id IS 'The provider''s id — stops the same event being processed twice';
COMMENT ON COLUMN integration_inbox.payload IS 'The raw event';
COMMENT ON COLUMN integration_inbox.outcome IS 'What we did with it';

-- The id another system uses for one of our records — the DocuSign envelope for an LOI, the Lightning Docs package, the Box folder for Setpoint, the Streamline folder later.
CREATE TABLE external_references (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type text NOT NULL,
  entity_id uuid NOT NULL,
  provider text NOT NULL CHECK (provider IN ('docusign', 'lightning_docs', 'box', 'streamline', 'amc', 'setpoint', 'other')),
  external_id text NOT NULL,
  external_url text,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (provider, external_id)
);
COMMENT ON TABLE external_references IS 'The id another system uses for one of our records — the DocuSign envelope for an LOI, the Lightning Docs package, the Box folder for Setpoint, the Streamline folder later.';
COMMENT ON COLUMN external_references.id IS 'Unique identifier';
COMMENT ON COLUMN external_references.external_url IS 'A link, when there is one';
COMMENT ON COLUMN external_references.created_at IS 'When this row was created';

-- [Phase 2 — defined now, empty in Phase 1] Reserved. What a model proposed about a message or a document — a classification, extracted dates, a check that the file is what was asked for — with confidence, and whether a person accepted it. AI proposes here; it never writes to the core tables.
CREATE TABLE ai_extractions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_type text NOT NULL CHECK (source_type IN ('message', 'document_file', 'loan')),
  source_id uuid NOT NULL,
  loan_id uuid NOT NULL,
  task text NOT NULL CHECK (task IN ('classify', 'extract', 'verify_document', 'draft_narrative', 'answer')),
  model text NOT NULL,
  prompt_version text,
  output jsonb NOT NULL,
  confidence numeric(4,3),
  status text NOT NULL DEFAULT 'proposed' CHECK (status IN ('proposed', 'accepted', 'rejected', 'auto_applied')),
  reviewed_by uuid,
  reviewed_at timestamptz,
  applied_changes jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE ai_extractions IS 'Reserved. What a model proposed about a message or a document — a classification, extracted dates, a check that the file is what was asked for — with confidence, and whether a person accepted it. AI proposes here; it never writes to the core tables.';
COMMENT ON COLUMN ai_extractions.id IS 'Unique identifier';
COMMENT ON COLUMN ai_extractions.source_type IS 'What was read';
COMMENT ON COLUMN ai_extractions.loan_id IS 'The loan this belongs to';
COMMENT ON COLUMN ai_extractions.task IS 'Classify, extract, verify document, draft narrative';
COMMENT ON COLUMN ai_extractions.model IS 'Which model and version';
COMMENT ON COLUMN ai_extractions.output IS 'What it proposed';
COMMENT ON COLUMN ai_extractions.confidence IS '0–1';
COMMENT ON COLUMN ai_extractions.status IS 'Proposed, accepted, rejected, auto-applied above the threshold';
COMMENT ON COLUMN ai_extractions.applied_changes IS 'What was written to the core tables once accepted';
COMMENT ON COLUMN ai_extractions.created_at IS 'When this row was created';

-- [Phase 2 — defined now, empty in Phase 1] Reserved. Proposals below the confidence threshold wait here for a person.
CREATE TABLE ai_review_queue (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  extraction_id uuid NOT NULL,
  loan_id uuid NOT NULL,
  assigned_to uuid,
  priority integer NOT NULL DEFAULT 100,
  opened_at timestamptz NOT NULL DEFAULT now(),
  closed_at timestamptz,
  outcome text
);
COMMENT ON TABLE ai_review_queue IS 'Reserved. Proposals below the confidence threshold wait here for a person.';
COMMENT ON COLUMN ai_review_queue.id IS 'Unique identifier';
COMMENT ON COLUMN ai_review_queue.loan_id IS 'The loan this belongs to';

-- [Phase 2 — defined now, empty in Phase 1] Reserved. Vector embeddings of documents, messages and notes for search and plain-language questions across the book. Needs the pgvector extension.
CREATE TABLE embeddings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type text NOT NULL CHECK (entity_type IN ('document_file', 'message', 'note', 'loan')),
  entity_id uuid NOT NULL,
  chunk_no integer NOT NULL DEFAULT 0,
  content_hash text NOT NULL,
  embedding vector(1536) NOT NULL,
  model text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (entity_type, entity_id, chunk_no, model)
);
COMMENT ON TABLE embeddings IS 'Reserved. Vector embeddings of documents, messages and notes for search and plain-language questions across the book. Needs the pgvector extension.';
COMMENT ON COLUMN embeddings.id IS 'Unique identifier';
COMMENT ON COLUMN embeddings.chunk_no IS 'Which slice of the text';
COMMENT ON COLUMN embeddings.content_hash IS 'So unchanged text is not re-embedded';
COMMENT ON COLUMN embeddings.embedding IS 'The vector';
COMMENT ON COLUMN embeddings.created_at IS 'When this row was created';

-- [Phase 2 — defined now, empty in Phase 1] Reserved. Values for fields added through configuration after go-live, without a schema change.
CREATE TABLE custom_field_values (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_type text NOT NULL,
  entity_id uuid NOT NULL,
  field_definition_id uuid NOT NULL,
  value jsonb NOT NULL,
  updated_by uuid,
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (entity_type, entity_id, field_definition_id)
);
COMMENT ON TABLE custom_field_values IS 'Reserved. Values for fields added through configuration after go-live, without a schema change.';
COMMENT ON COLUMN custom_field_values.id IS 'Unique identifier';
COMMENT ON COLUMN custom_field_values.updated_at IS 'When this row last changed';


-- ============================================================================
-- Foreign keys — added last so table order never matters
-- ============================================================================

ALTER TABLE parties ADD CONSTRAINT fk_parties_organization_id FOREIGN KEY (organization_id) REFERENCES parties (id);
ALTER TABLE loan_parties ADD CONSTRAINT fk_loan_parties_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE loan_parties ADD CONSTRAINT fk_loan_parties_party_id FOREIGN KEY (party_id) REFERENCES parties (id);
ALTER TABLE loan_parties ADD CONSTRAINT fk_loan_parties_added_by FOREIGN KEY (added_by) REFERENCES users (id);
ALTER TABLE track_record_projects ADD CONSTRAINT fk_track_record_projects_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE track_record_projects ADD CONSTRAINT fk_track_record_projects_party_id FOREIGN KEY (party_id) REFERENCES parties (id);
ALTER TABLE track_record_projects ADD CONSTRAINT fk_track_record_projects_evidence_file_id FOREIGN KEY (evidence_file_id) REFERENCES document_files (id);
ALTER TABLE track_record_projects ADD CONSTRAINT fk_track_record_projects_verified_by FOREIGN KEY (verified_by) REFERENCES users (id);
ALTER TABLE loans ADD CONSTRAINT fk_loans_stage_id FOREIGN KEY (stage_id) REFERENCES stages (id);
ALTER TABLE loans ADD CONSTRAINT fk_loans_status_id FOREIGN KEY (status_id) REFERENCES statuses (id);
ALTER TABLE loans ADD CONSTRAINT fk_loans_loan_officer_id FOREIGN KEY (loan_officer_id) REFERENCES users (id);
ALTER TABLE loans ADD CONSTRAINT fk_loans_client_manager_id FOREIGN KEY (client_manager_id) REFERENCES users (id);
ALTER TABLE loans ADD CONSTRAINT fk_loans_capital_partner_id FOREIGN KEY (capital_partner_id) REFERENCES capital_partners (id);
ALTER TABLE loans ADD CONSTRAINT fk_loans_current_terms_id FOREIGN KEY (current_terms_id) REFERENCES loan_terms (id);
ALTER TABLE loans ADD CONSTRAINT fk_loans_property_state FOREIGN KEY (property_state) REFERENCES jurisdictions (state);
ALTER TABLE loans ADD CONSTRAINT fk_loans_created_by FOREIGN KEY (created_by) REFERENCES users (id);
ALTER TABLE loan_terms ADD CONSTRAINT fk_loan_terms_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE loan_terms ADD CONSTRAINT fk_loan_terms_created_by FOREIGN KEY (created_by) REFERENCES users (id);
ALTER TABLE loan_status_history ADD CONSTRAINT fk_loan_status_history_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE loan_status_history ADD CONSTRAINT fk_loan_status_history_from_status_id FOREIGN KEY (from_status_id) REFERENCES statuses (id);
ALTER TABLE loan_status_history ADD CONSTRAINT fk_loan_status_history_to_status_id FOREIGN KEY (to_status_id) REFERENCES statuses (id);
ALTER TABLE loan_status_history ADD CONSTRAINT fk_loan_status_history_changed_by FOREIGN KEY (changed_by) REFERENCES users (id);
ALTER TABLE loan_status_history ADD CONSTRAINT fk_loan_status_history_message_id FOREIGN KEY (message_id) REFERENCES messages (id);
ALTER TABLE loan_assignments ADD CONSTRAINT fk_loan_assignments_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE loan_assignments ADD CONSTRAINT fk_loan_assignments_user_id FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE loan_assignments ADD CONSTRAINT fk_loan_assignments_assigned_by FOREIGN KEY (assigned_by) REFERENCES users (id);
ALTER TABLE loan_holds ADD CONSTRAINT fk_loan_holds_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE loan_holds ADD CONSTRAINT fk_loan_holds_placed_by FOREIGN KEY (placed_by) REFERENCES users (id);
ALTER TABLE loan_holds ADD CONSTRAINT fk_loan_holds_lifted_by FOREIGN KEY (lifted_by) REFERENCES users (id);
ALTER TABLE notes ADD CONSTRAINT fk_notes_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE notes ADD CONSTRAINT fk_notes_created_by FOREIGN KEY (created_by) REFERENCES users (id);
ALTER TABLE stages ADD CONSTRAINT fk_stages_owner_role_id FOREIGN KEY (owner_role_id) REFERENCES roles (id);
ALTER TABLE statuses ADD CONSTRAINT fk_statuses_stage_id FOREIGN KEY (stage_id) REFERENCES stages (id);
ALTER TABLE status_transitions ADD CONSTRAINT fk_status_transitions_from_status_id FOREIGN KEY (from_status_id) REFERENCES statuses (id);
ALTER TABLE status_transitions ADD CONSTRAINT fk_status_transitions_to_status_id FOREIGN KEY (to_status_id) REFERENCES statuses (id);
ALTER TABLE status_transitions ADD CONSTRAINT fk_status_transitions_override_role_id FOREIGN KEY (override_role_id) REFERENCES roles (id);
ALTER TABLE capital_partners ADD CONSTRAINT fk_capital_partners_party_id FOREIGN KEY (party_id) REFERENCES parties (id);
ALTER TABLE capital_partners ADD CONSTRAINT fk_capital_partners_final_approval_sender_role_id FOREIGN KEY (final_approval_sender_role_id) REFERENCES roles (id);
ALTER TABLE capital_partners ADD CONSTRAINT fk_capital_partners_final_approval_sender_user_id FOREIGN KEY (final_approval_sender_user_id) REFERENCES users (id);
ALTER TABLE capital_partners ADD CONSTRAINT fk_capital_partners_no_fly_list_id FOREIGN KEY (no_fly_list_id) REFERENCES no_fly_lists (id);
ALTER TABLE capital_partner_requirements ADD CONSTRAINT fk_capital_partner_requirements_capital_partner_id FOREIGN KEY (capital_partner_id) REFERENCES capital_partners (id);
ALTER TABLE capital_partner_requirements ADD CONSTRAINT fk_capital_partner_requirements_requirement_type_id FOREIGN KEY (requirement_type_id) REFERENCES requirement_types (id);
ALTER TABLE no_fly_lists ADD CONSTRAINT fk_no_fly_lists_capital_partner_id FOREIGN KEY (capital_partner_id) REFERENCES capital_partners (id);
ALTER TABLE no_fly_lists ADD CONSTRAINT fk_no_fly_lists_loaded_by FOREIGN KEY (loaded_by) REFERENCES users (id);
ALTER TABLE no_fly_entries ADD CONSTRAINT fk_no_fly_entries_list_id FOREIGN KEY (list_id) REFERENCES no_fly_lists (id);
ALTER TABLE no_fly_entries ADD CONSTRAINT fk_no_fly_entries_added_by FOREIGN KEY (added_by) REFERENCES users (id);
ALTER TABLE no_fly_matches ADD CONSTRAINT fk_no_fly_matches_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE no_fly_matches ADD CONSTRAINT fk_no_fly_matches_party_id FOREIGN KEY (party_id) REFERENCES parties (id);
ALTER TABLE no_fly_matches ADD CONSTRAINT fk_no_fly_matches_entry_id FOREIGN KEY (entry_id) REFERENCES no_fly_entries (id);
ALTER TABLE no_fly_matches ADD CONSTRAINT fk_no_fly_matches_acknowledged_by FOREIGN KEY (acknowledged_by) REFERENCES users (id);
ALTER TABLE no_fly_overrides ADD CONSTRAINT fk_no_fly_overrides_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE no_fly_overrides ADD CONSTRAINT fk_no_fly_overrides_match_id FOREIGN KEY (match_id) REFERENCES no_fly_matches (id);
ALTER TABLE no_fly_overrides ADD CONSTRAINT fk_no_fly_overrides_overridden_by FOREIGN KEY (overridden_by) REFERENCES users (id);
ALTER TABLE assignment_rules ADD CONSTRAINT fk_assignment_rules_assign_user_id FOREIGN KEY (assign_user_id) REFERENCES users (id);
ALTER TABLE saved_views ADD CONSTRAINT fk_saved_views_user_id FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE settings ADD CONSTRAINT fk_settings_updated_by FOREIGN KEY (updated_by) REFERENCES users (id);
ALTER TABLE needs_rules ADD CONSTRAINT fk_needs_rules_requirement_type_id FOREIGN KEY (requirement_type_id) REFERENCES requirement_types (id);
ALTER TABLE document_packages ADD CONSTRAINT fk_document_packages_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE loan_requirements ADD CONSTRAINT fk_loan_requirements_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE loan_requirements ADD CONSTRAINT fk_loan_requirements_requirement_type_id FOREIGN KEY (requirement_type_id) REFERENCES requirement_types (id);
ALTER TABLE loan_requirements ADD CONSTRAINT fk_loan_requirements_party_id FOREIGN KEY (party_id) REFERENCES parties (id);
ALTER TABLE loan_requirements ADD CONSTRAINT fk_loan_requirements_needs_rule_id FOREIGN KEY (needs_rule_id) REFERENCES needs_rules (id);
ALTER TABLE loan_requirements ADD CONSTRAINT fk_loan_requirements_package_id FOREIGN KEY (package_id) REFERENCES document_packages (id);
ALTER TABLE loan_requirements ADD CONSTRAINT fk_loan_requirements_not_needed_by FOREIGN KEY (not_needed_by) REFERENCES users (id);
ALTER TABLE loan_requirements ADD CONSTRAINT fk_loan_requirements_carried_from_id FOREIGN KEY (carried_from_id) REFERENCES loan_requirements (id);
ALTER TABLE document_files ADD CONSTRAINT fk_document_files_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE document_files ADD CONSTRAINT fk_document_files_requirement_id FOREIGN KEY (requirement_id) REFERENCES loan_requirements (id);
ALTER TABLE document_files ADD CONSTRAINT fk_document_files_supersedes_id FOREIGN KEY (supersedes_id) REFERENCES document_files (id);
ALTER TABLE document_files ADD CONSTRAINT fk_document_files_uploaded_by_user_id FOREIGN KEY (uploaded_by_user_id) REFERENCES users (id);
ALTER TABLE document_files ADD CONSTRAINT fk_document_files_uploaded_by_party_id FOREIGN KEY (uploaded_by_party_id) REFERENCES parties (id);
ALTER TABLE document_reviews ADD CONSTRAINT fk_document_reviews_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE document_reviews ADD CONSTRAINT fk_document_reviews_requirement_id FOREIGN KEY (requirement_id) REFERENCES loan_requirements (id);
ALTER TABLE document_reviews ADD CONSTRAINT fk_document_reviews_file_id FOREIGN KEY (file_id) REFERENCES document_files (id);
ALTER TABLE document_reviews ADD CONSTRAINT fk_document_reviews_reviewed_by_user_id FOREIGN KEY (reviewed_by_user_id) REFERENCES users (id);
ALTER TABLE document_reviews ADD CONSTRAINT fk_document_reviews_reviewed_by_party_id FOREIGN KEY (reviewed_by_party_id) REFERENCES parties (id);
ALTER TABLE requirement_followups ADD CONSTRAINT fk_requirement_followups_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE requirement_followups ADD CONSTRAINT fk_requirement_followups_requirement_id FOREIGN KEY (requirement_id) REFERENCES loan_requirements (id);
ALTER TABLE requirement_followups ADD CONSTRAINT fk_requirement_followups_asked_by FOREIGN KEY (asked_by) REFERENCES users (id);
ALTER TABLE requirement_followups ADD CONSTRAINT fk_requirement_followups_answer_file_id FOREIGN KEY (answer_file_id) REFERENCES document_files (id);
ALTER TABLE requirement_followups ADD CONSTRAINT fk_requirement_followups_resolved_by FOREIGN KEY (resolved_by) REFERENCES users (id);
ALTER TABLE generated_documents ADD CONSTRAINT fk_generated_documents_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE generated_documents ADD CONSTRAINT fk_generated_documents_party_id FOREIGN KEY (party_id) REFERENCES parties (id);
ALTER TABLE generated_documents ADD CONSTRAINT fk_generated_documents_terms_id FOREIGN KEY (terms_id) REFERENCES loan_terms (id);
ALTER TABLE generated_documents ADD CONSTRAINT fk_generated_documents_template_version_id FOREIGN KEY (template_version_id) REFERENCES email_template_versions (id);
ALTER TABLE generated_documents ADD CONSTRAINT fk_generated_documents_generated_by FOREIGN KEY (generated_by) REFERENCES users (id);
ALTER TABLE generated_documents ADD CONSTRAINT fk_generated_documents_sent_message_id FOREIGN KEY (sent_message_id) REFERENCES messages (id);
ALTER TABLE generated_documents ADD CONSTRAINT fk_generated_documents_external_reference_id FOREIGN KEY (external_reference_id) REFERENCES external_references (id);
ALTER TABLE vendor_orders ADD CONSTRAINT fk_vendor_orders_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE vendor_orders ADD CONSTRAINT fk_vendor_orders_vendor_party_id FOREIGN KEY (vendor_party_id) REFERENCES parties (id);
ALTER TABLE vendor_orders ADD CONSTRAINT fk_vendor_orders_ordered_by FOREIGN KEY (ordered_by) REFERENCES users (id);
ALTER TABLE vendor_orders ADD CONSTRAINT fk_vendor_orders_order_message_id FOREIGN KEY (order_message_id) REFERENCES messages (id);
ALTER TABLE vendor_orders ADD CONSTRAINT fk_vendor_orders_report_file_id FOREIGN KEY (report_file_id) REFERENCES document_files (id);
ALTER TABLE vendor_order_date_changes ADD CONSTRAINT fk_vendor_order_date_changes_vendor_order_id FOREIGN KEY (vendor_order_id) REFERENCES vendor_orders (id);
ALTER TABLE vendor_order_date_changes ADD CONSTRAINT fk_vendor_order_date_changes_changed_by FOREIGN KEY (changed_by) REFERENCES users (id);
ALTER TABLE approvals ADD CONSTRAINT fk_approvals_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE approvals ADD CONSTRAINT fk_approvals_terms_id FOREIGN KEY (terms_id) REFERENCES loan_terms (id);
ALTER TABLE approvals ADD CONSTRAINT fk_approvals_requested_by FOREIGN KEY (requested_by) REFERENCES users (id);
ALTER TABLE approvals ADD CONSTRAINT fk_approvals_request_message_id FOREIGN KEY (request_message_id) REFERENCES messages (id);
ALTER TABLE approvals ADD CONSTRAINT fk_approvals_requested_to_user_id FOREIGN KEY (requested_to_user_id) REFERENCES users (id);
ALTER TABLE approvals ADD CONSTRAINT fk_approvals_requested_to_party_id FOREIGN KEY (requested_to_party_id) REFERENCES parties (id);
ALTER TABLE approvals ADD CONSTRAINT fk_approvals_reply_message_id FOREIGN KEY (reply_message_id) REFERENCES messages (id);
ALTER TABLE approvals ADD CONSTRAINT fk_approvals_recorded_by FOREIGN KEY (recorded_by) REFERENCES users (id);
ALTER TABLE findings ADD CONSTRAINT fk_findings_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE findings ADD CONSTRAINT fk_findings_approval_id FOREIGN KEY (approval_id) REFERENCES approvals (id);
ALTER TABLE findings ADD CONSTRAINT fk_findings_raised_by FOREIGN KEY (raised_by) REFERENCES users (id);
ALTER TABLE findings ADD CONSTRAINT fk_findings_resolved_by FOREIGN KEY (resolved_by) REFERENCES users (id);
ALTER TABLE email_templates ADD CONSTRAINT fk_email_templates_stage_id FOREIGN KEY (stage_id) REFERENCES stages (id);
ALTER TABLE email_templates ADD CONSTRAINT fk_email_templates_sender_role_id FOREIGN KEY (sender_role_id) REFERENCES roles (id);
ALTER TABLE email_templates ADD CONSTRAINT fk_email_templates_moves_status_to_id FOREIGN KEY (moves_status_to_id) REFERENCES statuses (id);
ALTER TABLE email_template_versions ADD CONSTRAINT fk_email_template_versions_template_id FOREIGN KEY (template_id) REFERENCES email_templates (id);
ALTER TABLE email_template_versions ADD CONSTRAINT fk_email_template_versions_created_by FOREIGN KEY (created_by) REFERENCES users (id);
ALTER TABLE threads ADD CONSTRAINT fk_threads_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_thread_id FOREIGN KEY (thread_id) REFERENCES threads (id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_template_version_id FOREIGN KEY (template_version_id) REFERENCES email_template_versions (id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_in_reply_to_id FOREIGN KEY (in_reply_to_id) REFERENCES messages (id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_recorded_by FOREIGN KEY (recorded_by) REFERENCES users (id);
ALTER TABLE message_recipients ADD CONSTRAINT fk_message_recipients_message_id FOREIGN KEY (message_id) REFERENCES messages (id);
ALTER TABLE message_recipients ADD CONSTRAINT fk_message_recipients_party_id FOREIGN KEY (party_id) REFERENCES parties (id);
ALTER TABLE message_recipients ADD CONSTRAINT fk_message_recipients_user_id FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE message_attachments ADD CONSTRAINT fk_message_attachments_message_id FOREIGN KEY (message_id) REFERENCES messages (id);
ALTER TABLE message_attachments ADD CONSTRAINT fk_message_attachments_generated_document_id FOREIGN KEY (generated_document_id) REFERENCES generated_documents (id);
ALTER TABLE message_attachments ADD CONSTRAINT fk_message_attachments_document_file_id FOREIGN KEY (document_file_id) REFERENCES document_files (id);
ALTER TABLE send_schedules ADD CONSTRAINT fk_send_schedules_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE send_schedules ADD CONSTRAINT fk_send_schedules_template_id FOREIGN KEY (template_id) REFERENCES email_templates (id);
ALTER TABLE send_schedules ADD CONSTRAINT fk_send_schedules_last_message_id FOREIGN KEY (last_message_id) REFERENCES messages (id);
ALTER TABLE send_schedules ADD CONSTRAINT fk_send_schedules_created_by FOREIGN KEY (created_by) REFERENCES users (id);
ALTER TABLE triggers ADD CONSTRAINT fk_triggers_template_id FOREIGN KEY (template_id) REFERENCES email_templates (id);
ALTER TABLE trigger_firings ADD CONSTRAINT fk_trigger_firings_trigger_id FOREIGN KEY (trigger_id) REFERENCES triggers (id);
ALTER TABLE trigger_firings ADD CONSTRAINT fk_trigger_firings_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE trigger_firings ADD CONSTRAINT fk_trigger_firings_vendor_order_id FOREIGN KEY (vendor_order_id) REFERENCES vendor_orders (id);
ALTER TABLE trigger_firings ADD CONSTRAINT fk_trigger_firings_message_id FOREIGN KEY (message_id) REFERENCES messages (id);
ALTER TABLE loan_closing ADD CONSTRAINT fk_loan_closing_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE loan_closing ADD CONSTRAINT fk_loan_closing_loan_servicer_party_id FOREIGN KEY (loan_servicer_party_id) REFERENCES parties (id);
ALTER TABLE loan_closing ADD CONSTRAINT fk_loan_closing_updated_by FOREIGN KEY (updated_by) REFERENCES users (id);
ALTER TABLE closing_checklist_items ADD CONSTRAINT fk_closing_checklist_items_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE closing_checklist_items ADD CONSTRAINT fk_closing_checklist_items_completed_by FOREIGN KEY (completed_by) REFERENCES users (id);
ALTER TABLE user_roles ADD CONSTRAINT fk_user_roles_user_id FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE user_roles ADD CONSTRAINT fk_user_roles_role_id FOREIGN KEY (role_id) REFERENCES roles (id);
ALTER TABLE user_roles ADD CONSTRAINT fk_user_roles_granted_by FOREIGN KEY (granted_by) REFERENCES users (id);
ALTER TABLE field_definitions ADD CONSTRAINT fk_field_definitions_stage_from_id FOREIGN KEY (stage_from_id) REFERENCES stages (id);
ALTER TABLE portal_links ADD CONSTRAINT fk_portal_links_loan_party_id FOREIGN KEY (loan_party_id) REFERENCES loan_parties (id);
ALTER TABLE delegations ADD CONSTRAINT fk_delegations_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id);
ALTER TABLE delegations ADD CONSTRAINT fk_delegations_to_user_id FOREIGN KEY (to_user_id) REFERENCES users (id);
ALTER TABLE delegations ADD CONSTRAINT fk_delegations_role_id FOREIGN KEY (role_id) REFERENCES roles (id);
ALTER TABLE delegations ADD CONSTRAINT fk_delegations_created_by FOREIGN KEY (created_by) REFERENCES users (id);
ALTER TABLE events ADD CONSTRAINT fk_events_actor_user_id FOREIGN KEY (actor_user_id) REFERENCES users (id);
ALTER TABLE events ADD CONSTRAINT fk_events_actor_party_id FOREIGN KEY (actor_party_id) REFERENCES parties (id);
ALTER TABLE events ADD CONSTRAINT fk_events_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE ai_extractions ADD CONSTRAINT fk_ai_extractions_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE ai_extractions ADD CONSTRAINT fk_ai_extractions_reviewed_by FOREIGN KEY (reviewed_by) REFERENCES users (id);
ALTER TABLE ai_review_queue ADD CONSTRAINT fk_ai_review_queue_extraction_id FOREIGN KEY (extraction_id) REFERENCES ai_extractions (id);
ALTER TABLE ai_review_queue ADD CONSTRAINT fk_ai_review_queue_loan_id FOREIGN KEY (loan_id) REFERENCES loans (id);
ALTER TABLE ai_review_queue ADD CONSTRAINT fk_ai_review_queue_assigned_to FOREIGN KEY (assigned_to) REFERENCES users (id);
ALTER TABLE custom_field_values ADD CONSTRAINT fk_custom_field_values_field_definition_id FOREIGN KEY (field_definition_id) REFERENCES field_definitions (id);
ALTER TABLE custom_field_values ADD CONSTRAINT fk_custom_field_values_updated_by FOREIGN KEY (updated_by) REFERENCES users (id);

-- ============================================================================
-- Indexes
-- ============================================================================

CREATE INDEX ix_parties_display_name ON parties (display_name);
CREATE INDEX ix_parties_organization_id ON parties (organization_id);
CREATE INDEX ix_parties_email ON parties (email);
CREATE INDEX ix_parties_organization_kind ON parties (organization_kind);
CREATE INDEX ix_parties_last_name_first_name ON parties (last_name, first_name);
CREATE INDEX ix_loan_parties_loan_id ON loan_parties (loan_id);
CREATE INDEX ix_loan_parties_party_id ON loan_parties (party_id);
CREATE INDEX ix_loan_parties_role ON loan_parties (role);
CREATE INDEX ix_loan_parties_added_by ON loan_parties (added_by);
CREATE INDEX ix_track_record_projects_loan_id ON track_record_projects (loan_id);
CREATE INDEX ix_track_record_projects_party_id ON track_record_projects (party_id);
CREATE INDEX ix_track_record_projects_evidence_file_id ON track_record_projects (evidence_file_id);
CREATE INDEX ix_track_record_projects_verified_by ON track_record_projects (verified_by);
CREATE INDEX ix_loans_stage_id ON loans (stage_id);
CREATE INDEX ix_loans_status_id ON loans (status_id);
CREATE INDEX ix_loans_loan_officer_id ON loans (loan_officer_id);
CREATE INDEX ix_loans_client_manager_id ON loans (client_manager_id);
CREATE INDEX ix_loans_capital_partner_id ON loans (capital_partner_id);
CREATE INDEX ix_loans_current_terms_id ON loans (current_terms_id);
CREATE INDEX ix_loans_property_state ON loans (property_state);
CREATE INDEX ix_loans_created_by ON loans (created_by);
CREATE INDEX ix_loans_stage_id_status_id ON loans (stage_id, status_id);
CREATE INDEX ix_loan_terms_loan_id ON loan_terms (loan_id);
CREATE INDEX ix_loan_terms_created_by ON loan_terms (created_by);
CREATE INDEX ix_loan_status_history_loan_id ON loan_status_history (loan_id);
CREATE INDEX ix_loan_status_history_from_status_id ON loan_status_history (from_status_id);
CREATE INDEX ix_loan_status_history_to_status_id ON loan_status_history (to_status_id);
CREATE INDEX ix_loan_status_history_changed_at ON loan_status_history (changed_at);
CREATE INDEX ix_loan_status_history_changed_by ON loan_status_history (changed_by);
CREATE INDEX ix_loan_status_history_message_id ON loan_status_history (message_id);
CREATE INDEX ix_loan_status_history_loan_id_changed_at ON loan_status_history (loan_id, changed_at);
CREATE INDEX ix_loan_assignments_loan_id ON loan_assignments (loan_id);
CREATE INDEX ix_loan_assignments_user_id ON loan_assignments (user_id);
CREATE INDEX ix_loan_assignments_assigned_by ON loan_assignments (assigned_by);
CREATE INDEX ix_loan_assignments_loan_id_role ON loan_assignments (loan_id, role);
CREATE INDEX ix_loan_holds_loan_id ON loan_holds (loan_id);
CREATE INDEX ix_loan_holds_placed_by ON loan_holds (placed_by);
CREATE INDEX ix_loan_holds_lifted_by ON loan_holds (lifted_by);
CREATE INDEX ix_notes_loan_id ON notes (loan_id);
CREATE INDEX ix_notes_created_by ON notes (created_by);
CREATE INDEX ix_notes_loan_id_created_at ON notes (loan_id, created_at);
CREATE INDEX ix_stages_owner_role_id ON stages (owner_role_id);
CREATE INDEX ix_statuses_stage_id ON statuses (stage_id);
CREATE INDEX ix_status_transitions_from_status_id ON status_transitions (from_status_id);
CREATE INDEX ix_status_transitions_to_status_id ON status_transitions (to_status_id);
CREATE INDEX ix_status_transitions_override_role_id ON status_transitions (override_role_id);
CREATE INDEX ix_capital_partners_party_id ON capital_partners (party_id);
CREATE INDEX ix_capital_partners_final_approval_sender_role_id ON capital_partners (final_approval_sender_role_id);
CREATE INDEX ix_capital_partners_final_approval_sender_user_id ON capital_partners (final_approval_sender_user_id);
CREATE INDEX ix_capital_partners_no_fly_list_id ON capital_partners (no_fly_list_id);
CREATE INDEX ix_capital_partner_requirements_capital_partner_id ON capital_partner_requirements (capital_partner_id);
CREATE INDEX ix_capital_partner_requirements_requirement_type_id ON capital_partner_requirements (requirement_type_id);
CREATE INDEX ix_no_fly_lists_capital_partner_id ON no_fly_lists (capital_partner_id);
CREATE INDEX ix_no_fly_lists_loaded_by ON no_fly_lists (loaded_by);
CREATE INDEX ix_no_fly_entries_list_id ON no_fly_entries (list_id);
CREATE INDEX ix_no_fly_entries_full_name ON no_fly_entries (full_name);
CREATE INDEX ix_no_fly_entries_email ON no_fly_entries (email);
CREATE INDEX ix_no_fly_entries_added_by ON no_fly_entries (added_by);
CREATE INDEX ix_no_fly_matches_loan_id ON no_fly_matches (loan_id);
CREATE INDEX ix_no_fly_matches_party_id ON no_fly_matches (party_id);
CREATE INDEX ix_no_fly_matches_entry_id ON no_fly_matches (entry_id);
CREATE INDEX ix_no_fly_matches_acknowledged_by ON no_fly_matches (acknowledged_by);
CREATE INDEX ix_no_fly_overrides_loan_id ON no_fly_overrides (loan_id);
CREATE INDEX ix_no_fly_overrides_match_id ON no_fly_overrides (match_id);
CREATE INDEX ix_no_fly_overrides_overridden_by ON no_fly_overrides (overridden_by);
CREATE INDEX ix_assignment_rules_assign_user_id ON assignment_rules (assign_user_id);
CREATE INDEX ix_saved_views_user_id ON saved_views (user_id);
CREATE INDEX ix_settings_updated_by ON settings (updated_by);
CREATE INDEX ix_needs_rules_requirement_type_id ON needs_rules (requirement_type_id);
CREATE INDEX ix_document_packages_loan_id ON document_packages (loan_id);
CREATE INDEX ix_loan_requirements_loan_id ON loan_requirements (loan_id);
CREATE INDEX ix_loan_requirements_requirement_type_id ON loan_requirements (requirement_type_id);
CREATE INDEX ix_loan_requirements_party_id ON loan_requirements (party_id);
CREATE INDEX ix_loan_requirements_needs_rule_id ON loan_requirements (needs_rule_id);
CREATE INDEX ix_loan_requirements_package_id ON loan_requirements (package_id);
CREATE INDEX ix_loan_requirements_not_needed_by ON loan_requirements (not_needed_by);
CREATE INDEX ix_loan_requirements_carried_from_id ON loan_requirements (carried_from_id);
CREATE INDEX ix_loan_requirements_loan_id_submission_state ON loan_requirements (loan_id, submission_state);
CREATE INDEX ix_document_files_loan_id ON document_files (loan_id);
CREATE INDEX ix_document_files_requirement_id ON document_files (requirement_id);
CREATE INDEX ix_document_files_sha256 ON document_files (sha256);
CREATE INDEX ix_document_files_supersedes_id ON document_files (supersedes_id);
CREATE INDEX ix_document_files_uploaded_by_user_id ON document_files (uploaded_by_user_id);
CREATE INDEX ix_document_files_uploaded_by_party_id ON document_files (uploaded_by_party_id);
CREATE INDEX ix_document_files_requirement_id_is_current ON document_files (requirement_id, is_current);
CREATE INDEX ix_document_reviews_loan_id ON document_reviews (loan_id);
CREATE INDEX ix_document_reviews_requirement_id ON document_reviews (requirement_id);
CREATE INDEX ix_document_reviews_file_id ON document_reviews (file_id);
CREATE INDEX ix_document_reviews_reviewed_by_user_id ON document_reviews (reviewed_by_user_id);
CREATE INDEX ix_document_reviews_reviewed_by_party_id ON document_reviews (reviewed_by_party_id);
CREATE INDEX ix_document_reviews_requirement_id_reviewed_at ON document_reviews (requirement_id, reviewed_at);
CREATE INDEX ix_requirement_followups_loan_id ON requirement_followups (loan_id);
CREATE INDEX ix_requirement_followups_requirement_id ON requirement_followups (requirement_id);
CREATE INDEX ix_requirement_followups_asked_by ON requirement_followups (asked_by);
CREATE INDEX ix_requirement_followups_answer_file_id ON requirement_followups (answer_file_id);
CREATE INDEX ix_requirement_followups_resolved_by ON requirement_followups (resolved_by);
CREATE INDEX ix_generated_documents_loan_id ON generated_documents (loan_id);
CREATE INDEX ix_generated_documents_party_id ON generated_documents (party_id);
CREATE INDEX ix_generated_documents_terms_id ON generated_documents (terms_id);
CREATE INDEX ix_generated_documents_template_version_id ON generated_documents (template_version_id);
CREATE INDEX ix_generated_documents_generated_by ON generated_documents (generated_by);
CREATE INDEX ix_generated_documents_sent_message_id ON generated_documents (sent_message_id);
CREATE INDEX ix_generated_documents_external_reference_id ON generated_documents (external_reference_id);
CREATE INDEX ix_generated_documents_loan_id_kind ON generated_documents (loan_id, kind);
CREATE INDEX ix_vendor_orders_loan_id ON vendor_orders (loan_id);
CREATE INDEX ix_vendor_orders_kind ON vendor_orders (kind);
CREATE INDEX ix_vendor_orders_vendor_party_id ON vendor_orders (vendor_party_id);
CREATE INDEX ix_vendor_orders_ordered_by ON vendor_orders (ordered_by);
CREATE INDEX ix_vendor_orders_order_message_id ON vendor_orders (order_message_id);
CREATE INDEX ix_vendor_orders_report_file_id ON vendor_orders (report_file_id);
CREATE INDEX ix_vendor_orders_loan_id_kind ON vendor_orders (loan_id, kind);
CREATE INDEX ix_vendor_orders_status ON vendor_orders (status);
CREATE INDEX ix_vendor_order_date_changes_vendor_order_id ON vendor_order_date_changes (vendor_order_id);
CREATE INDEX ix_vendor_order_date_changes_changed_by ON vendor_order_date_changes (changed_by);
CREATE INDEX ix_approvals_loan_id ON approvals (loan_id);
CREATE INDEX ix_approvals_kind ON approvals (kind);
CREATE INDEX ix_approvals_terms_id ON approvals (terms_id);
CREATE INDEX ix_approvals_requested_by ON approvals (requested_by);
CREATE INDEX ix_approvals_request_message_id ON approvals (request_message_id);
CREATE INDEX ix_approvals_requested_to_user_id ON approvals (requested_to_user_id);
CREATE INDEX ix_approvals_requested_to_party_id ON approvals (requested_to_party_id);
CREATE INDEX ix_approvals_reply_message_id ON approvals (reply_message_id);
CREATE INDEX ix_approvals_recorded_by ON approvals (recorded_by);
CREATE INDEX ix_findings_loan_id ON findings (loan_id);
CREATE INDEX ix_findings_approval_id ON findings (approval_id);
CREATE INDEX ix_findings_raised_by ON findings (raised_by);
CREATE INDEX ix_findings_resolved_by ON findings (resolved_by);
CREATE INDEX ix_findings_loan_id_resolved_at ON findings (loan_id, resolved_at);
CREATE INDEX ix_email_templates_stage_id ON email_templates (stage_id);
CREATE INDEX ix_email_templates_sender_role_id ON email_templates (sender_role_id);
CREATE INDEX ix_email_templates_moves_status_to_id ON email_templates (moves_status_to_id);
CREATE INDEX ix_email_template_versions_template_id ON email_template_versions (template_id);
CREATE INDEX ix_email_template_versions_created_by ON email_template_versions (created_by);
CREATE INDEX ix_threads_loan_id ON threads (loan_id);
CREATE INDEX ix_messages_loan_id ON messages (loan_id);
CREATE INDEX ix_messages_thread_id ON messages (thread_id);
CREATE INDEX ix_messages_template_version_id ON messages (template_version_id);
CREATE INDEX ix_messages_from_user_id ON messages (from_user_id);
CREATE INDEX ix_messages_sent_at ON messages (sent_at);
CREATE INDEX ix_messages_in_reply_to_id ON messages (in_reply_to_id);
CREATE INDEX ix_messages_recorded_by ON messages (recorded_by);
CREATE INDEX ix_messages_loan_id_sent_at ON messages (loan_id, sent_at);
CREATE INDEX ix_message_recipients_message_id ON message_recipients (message_id);
CREATE INDEX ix_message_recipients_party_id ON message_recipients (party_id);
CREATE INDEX ix_message_recipients_user_id ON message_recipients (user_id);
CREATE INDEX ix_message_attachments_message_id ON message_attachments (message_id);
CREATE INDEX ix_message_attachments_generated_document_id ON message_attachments (generated_document_id);
CREATE INDEX ix_message_attachments_document_file_id ON message_attachments (document_file_id);
CREATE INDEX ix_send_schedules_loan_id ON send_schedules (loan_id);
CREATE INDEX ix_send_schedules_template_id ON send_schedules (template_id);
CREATE INDEX ix_send_schedules_last_message_id ON send_schedules (last_message_id);
CREATE INDEX ix_send_schedules_created_by ON send_schedules (created_by);
CREATE INDEX ix_triggers_template_id ON triggers (template_id);
CREATE INDEX ix_trigger_firings_trigger_id ON trigger_firings (trigger_id);
CREATE INDEX ix_trigger_firings_loan_id ON trigger_firings (loan_id);
CREATE INDEX ix_trigger_firings_vendor_order_id ON trigger_firings (vendor_order_id);
CREATE INDEX ix_trigger_firings_message_id ON trigger_firings (message_id);
CREATE INDEX ix_trigger_firings_vendor_order_id_trigger_id ON trigger_firings (vendor_order_id, trigger_id);
CREATE INDEX ix_loan_closing_loan_id ON loan_closing (loan_id);
CREATE INDEX ix_loan_closing_loan_servicer_party_id ON loan_closing (loan_servicer_party_id);
CREATE INDEX ix_loan_closing_updated_by ON loan_closing (updated_by);
CREATE INDEX ix_closing_checklist_items_loan_id ON closing_checklist_items (loan_id);
CREATE INDEX ix_closing_checklist_items_completed_by ON closing_checklist_items (completed_by);
CREATE INDEX ix_user_roles_user_id ON user_roles (user_id);
CREATE INDEX ix_user_roles_role_id ON user_roles (role_id);
CREATE INDEX ix_user_roles_granted_by ON user_roles (granted_by);
CREATE INDEX ix_field_definitions_stage_from_id ON field_definitions (stage_from_id);
CREATE INDEX ix_portal_links_loan_party_id ON portal_links (loan_party_id);
CREATE INDEX ix_delegations_from_user_id ON delegations (from_user_id);
CREATE INDEX ix_delegations_to_user_id ON delegations (to_user_id);
CREATE INDEX ix_delegations_role_id ON delegations (role_id);
CREATE INDEX ix_delegations_created_by ON delegations (created_by);
CREATE INDEX ix_events_occurred_at ON events (occurred_at);
CREATE INDEX ix_events_actor_user_id ON events (actor_user_id);
CREATE INDEX ix_events_actor_party_id ON events (actor_party_id);
CREATE INDEX ix_events_loan_id ON events (loan_id);
CREATE INDEX ix_events_correlation_id ON events (correlation_id);
CREATE INDEX ix_events_entity_type_entity_id ON events (entity_type, entity_id);
CREATE INDEX ix_integration_outbox_kind ON integration_outbox (kind);
CREATE INDEX ix_integration_outbox_next_attempt_at ON integration_outbox (next_attempt_at);
CREATE INDEX ix_integration_inbox_provider ON integration_inbox (provider);
CREATE INDEX ix_external_references_entity_type_entity_id ON external_references (entity_type, entity_id);
CREATE INDEX ix_ai_extractions_loan_id ON ai_extractions (loan_id);
CREATE INDEX ix_ai_extractions_reviewed_by ON ai_extractions (reviewed_by);
CREATE INDEX ix_ai_extractions_loan_id_status ON ai_extractions (loan_id, status);
CREATE INDEX ix_ai_review_queue_extraction_id ON ai_review_queue (extraction_id);
CREATE INDEX ix_ai_review_queue_loan_id ON ai_review_queue (loan_id);
CREATE INDEX ix_ai_review_queue_assigned_to ON ai_review_queue (assigned_to);
CREATE INDEX ix_custom_field_values_field_definition_id ON custom_field_values (field_definition_id);
CREATE INDEX ix_custom_field_values_updated_by ON custom_field_values (updated_by);
CREATE INDEX ix_parties_search ON parties USING gin (search);

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

