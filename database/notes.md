# The database

The target schema for Spreo OS — PostgreSQL on Amazon RDS, files in S3, per the
AWS estimate of September 2026. Built from the flowchart (`02-the-flowchart.md`),
not from the prototype, and shaped so Phase 2 is additions only.

| File | What it is | For whom |
|---|---|---|
| `model/*.mjs` | The schema as data — one file per domain, every column with its plain-English meaning and which process step writes it | The source of truth. Edit this, then rebuild |
| `schema.sql` | Runnable PostgreSQL DDL — 59 tables, foreign keys, indexes, comments, the reporting schema | The build team. `psql -f database/schema.sql` |
| `reporting.sql` | The read-only `reporting` schema: Pulse, outstanding items, cycle times, vendor drift — hand-written, appended to `schema.sql` | Dashboards, exports, the Phase 2 intelligence layer |
| `../08-database.html` | The visualizer — a map, a walk through the process, every table in plain English. Opens from disk | Dan, Jonathan, anyone non-technical |
| `../08-database.md` | Mermaid ER diagram per domain, renders on GitHub | Engineers |

**Rebuild after any change to the model:** `node db/build.mjs`. It validates every
foreign key target and every process step before writing anything.

## The decisions, and why

1. **People and companies exist once.** `parties` holds every person and company;
   `loan_parties` says who plays what role on which loan. Dan, 23 Jul: *"some sort
   of modulation on a guarantor level… easy for me to bring some of those items over."*
   This is what makes prior-evidence carry-over, No Fly aliases and the Phase 2
   guarantor profile possible.
2. **The process is data.** Stages, statuses, transitions, needs rules, the document
   catalogue, email templates, triggers, the role matrix and field visibility are all
   tables. Phase 1 seeds them and shows no screens (D-016 keeps the workflow engine
   out); the Phase 2 admin studio is screens over these tables.
3. **One shape per concept.** `approvals` for all seven approval loops, `vendor_orders`
   for all six vendor kinds, `messages` for every channel. Dan, 31 Jul: *"it's all the
   same technology. If you can do it for one, we can do it for all."*
4. **Nothing is deleted; everything is stamped.** `events` is append-only with before
   and after. Documents are versioned, never removed. Removed items go to a drawer.
   *"Why did it take five days? It only took me a day, it took you four."*
5. **The AI layer has its own tables, empty in Phase 1.** `ai_extractions`,
   `ai_review_queue`, `embeddings` (pgvector). AI proposes there; a person accepts;
   only then does anything reach a core table.
6. **The read-only copy is a schema of views on the replica.** `reporting.*` served by
   `reporting_reader`, which can only SELECT. Reporting can never slow or corrupt the
   transactional side.
7. **No tenant column.** A second lender gets its own database. Simpler for the build
   team, no forgotten-filter risk, and borrower financial data stays physically isolated.
8. **Conventions.** UUID keys, `timestamptz`, `numeric(14,2)` for money, `citext` for
   emails, lookup tables rather than enums, a human `loan_number` for the email footers.

## What the open flowchart questions would change

Of the sixteen questions in `02-the-flowchart.md` §14, four touch the schema, each
already accommodated:

| Q | If yes | Where |
|---|---|---|
| Q9 — CM by rule | Rows in `assignment_rules` | Reserved table |
| Q13 — a Management role | A row in `roles` | No change |
| Q15 — On Hold | Rows in `loan_holds` | Reserved table |
| Q16 — Closing's checklist | Rows in `closing_checklist_items` | Reserved table |

## What Phase 2 adds without touching Phase 1

Construction draws, servicing, watchlists, extensions and payoff are new tables
keyed on `loans.id`. Inbound email, SMS and chat are new `channel` values on
`messages`. Vendor intake forms write to `integration_inbox` then `vendor_orders`.
Streamline and Setpoint pushes are new `integration_outbox` kinds. A report builder
reads the `reporting` schema. Custom fields land in `custom_field_values`. None of
this alters a Phase 1 table.

## Verified

`schema.sql` loads clean into PostgreSQL (PGlite 0.3, pgvector and citext enabled):
59 tables, 157 foreign keys, 277 indexes, 5 reporting views. A loan inserted through
the constraints reads back through `reporting.pulse` with the calculated funding
date four business days after the promised appraisal delivery.
