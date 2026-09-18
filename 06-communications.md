# Emails

Every send is composed, addressed, stamped and logged. **Delivery is simulated.**
We record replies; we do not read the mailbox.

## Two body modes (D-003)

- **`composed`** — the template renders a full body, editable before sending.
- **`manual`** — the form opens with a merged subject and an **empty body the
  user types**, plus attachments. Dan described this for the two approval emails.

## Every subject carries the address; the footer carries the loan number

Dan, 2026-07-31: *"just have the address in the subject line… and then to have
the loan ID embedded in the email somewhere. That could be amazing… a building
block for us as we go into phase two."*

## Recipient resolution

Rules on the template resolve at send time against the loan's own guarantors,
contacts and staff. Tokens: `lo` · `cm` · `guarantor1` · `guarantors` ·
`broker` · `title` · `escrow` · `legal` · `insurance` · `amc` ·
`budget_vendor` · `appraiser` · `internal_underwrite` · `configured:*`.

What cannot be resolved is **reported in the compose form**, not silently dropped.

## The templates

### Pre-Approval
| Key | Name | To · Cc · Bcc | Mode |
|---|---|---|---|
| `pre_pre_approval` | Pre-Pre-Approval Request | configured internal approvers · lo | **manual** |
| `pre_approval_investor` | Pre-Approval to Investor | configured investor · lo | **manual** |
| `order_appraisal` | Order Appraisal | amc · cm, lo | composed |
| `appraisal_invoice_request` | Appraisal Invoice Request | amc · cm, lo | composed |
| `invoice_link_internal` | Appraisal Invoice Link to CM & LO | cm · lo | composed |
| `loi_issue` | LOI Issue | guarantor1, broker · lo | composed |

### Pre-Processing — Dan's seven, plus his two verbal additions
| Key | Name | To · Cc · Bcc |
|---|---|---|
| `pre_processing` | Pre-Processing | guarantors, broker · **cc lo** |
| `order_budget` | Order Budget Scrub or Feasibility | budget_vendor · **bcc lo** |
| `appraisal_invoice_client` | Appraisal Invoice to client | guarantor1 · cc lo |
| `title_kickoff` | Title Kick-off | title |
| `escrow_kickoff` | Escrow Kick-off | escrow |
| `legal_kickoff` | Legal Kick-off — state in the subject | legal |
| `order_flood` | Order Flood | configured flood vendor |
| `disclosures` | Disclosures (DocuSign) | guarantors |
| `application` | Application (DocuSign) | guarantors |
| `kickoff` | Kick-off Email — releases the needs list | broker, guarantors · cc lo |
| `vom_payoff` | VOM & Payoff Request | configured current lender · cc cm |

The **bcc on the budget order is the only bcc in the system**, and it is on the
right email.

### Review
| Key | Name |
|---|---|
| `internal_review` | Submit to Internal Review — the dry run for the investor package |
| `internal_findings` | Findings back to the CM and the working group. Never to the client |
| `investor_submission` | Submit to Capital Partner — role-gated, **manual** |

## Automated

**The status email** — `needs_list_status`, Mon/Wed/Fri 08:00, live cron. Every
outstanding item in one message, **including non-document items**: paying the
appraisal, scheduling the inspection, what each vendor still needs. No due dates,
nothing overdue. Satisfied items simply drop off the next send.

Client-facing wording is **Under Review** and **Outstanding**. Dan rejected
"Received": *"why are you sending them a list if you're saying it's already been
received?"*

**The six triggers** — criteria live on the template, not in a rules engine.
Dan: *"They're just triggers. They're not an SLA."*

| Trigger | Criteria |
|---|---|
| Appraisal invoice unpaid | 48h after the invoice was sent |
| Inspection confirmation | The day after the scheduled inspection passes |
| Appraiser needs outstanding | Items requested and not provided |
| Delivery check-in | 48h before promised delivery |
| Budget vendor needs outstanding | Same pattern |
| Budget delivery check-in | Same pattern |

Dan said he would send the definitive list. Still outstanding — Q-019.

## Replies that move the loan

| Template | Outcome | Moves to |
|---|---|---|
| `pre_pre_approval` | approved | Internal Approved |
| `pre_approval_investor` | approved / not approved | Pre-Approved / **Not Pre-Approved** |
| `loi_issue` | signed | LOI Signed |
| `internal_review` | approved / items requested | Approved / Items Requested |
| `investor_submission` | approved / conditional / feedback | the three investor states |
