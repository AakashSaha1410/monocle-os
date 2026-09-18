# Roles

The six from Jonathan's workbook Sheet1 rows 31–36, plus the loan officer, who
appears throughout Dan's process but is not on that list.

| Role | Owns | Dan / Jonathan on it |
|---|---|---|
| **Loan Officer** | Creating the loan; emailing structure to `submissions@` offline | "The only thing somebody outside of credit will do, it'll be the salesperson emailing information" |
| **Credit** | All of Pre-Approval. The permutations, the needs list, the LOI package, the appraisal order | Sheet1 row 31: "For creating the LOI" |
| **Client Management** | Pre-Processing onward. The kick-off, the vendor chase, document review, clearing findings | "Pre-processing is driven by client management" |
| **3rd Party Review** | The external document layer — Setpoint or off-shore | Sheet1 row 33 |
| **Internal Underwrite** | The exception-based review. Raises findings, approves or sends back | The named internal reviewer |
| **Closing** | Lightning Docs fields and post-funding capture | Sheet1 row 35 |
| **Admin** | Everything, plus No Fly overrides | Sheet1 row 36 |

## What each role sees

Jonathan, 2026-08-06: *"what you see under those tabs depends, one, on the phase
it's in, and then two would be your user role."* Phase gating is in `07-data-fields.md`.
This is the role half.

| Surface | Loan Officer | Credit | Client Mgmt | 3rd Party | Internal UW | Closing | Admin |
|---|---|---|---|---|---|---|---|
| Loans list | own loans | all | own loans | queue only | queue only | approved only | all |
| Sponsor · Project · Loan | read | **edit** | read | — | read | read | edit |
| Transaction · appraisal/budget | read | edit | **edit** | — | read | read | edit |
| Transaction · Lightning Docs | — | — | — | — | — | **edit** | edit |
| Transaction · post-funding | — | — | — | — | — | **edit** | edit |
| Internal review findings | — | — | **clear** | — | **raise/decide** | — | both |
| Investor review findings | — | — | clear | — | — | — | **raise/decide** |
| UW Material · add item | — | **yes** | **yes** | — | — | — | yes |
| UW Material · remove item | — | **yes** | **no — email Credit** | — | — | — | yes |
| UW Material · third-party review | — | — | — | **yes** | — | — | yes |
| Communications · send | yes | yes | yes | — | yes | yes | yes |
| No Fly override | — | — | — | — | — | — | **yes** |
| Pulse · Reporting | read | read | read | — | read | read | read |

## Rules that are enforced, not just displayed

- **Only Credit removes a needs-list item.** A client manager asks Credit by
  email — there is deliberately no button. Dan: *"I don't want a button… it's
  distracting."* Enforced at the API: a CM gets `403`.
- **Nothing approves in review while a finding is open.** Enforced at the API:
  `409`.
- **The Processing gate.** Enforced at the API: `409`, naming what is unmet.
- **No Fly gates LOI generation** until an override is recorded.

## Known gap

Role filtering of *fields* is not yet applied across the tabs — only the
enforcement rules above and Closing-group visibility. See QA finding F4.
