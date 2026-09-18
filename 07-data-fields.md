# Data contract

Every field, the tab it lives on, and the phase at which it appears.

**Source:** Jonathan's workbook (`jonathan-phase1-workbook-extract.md`), tab
sheets. Dan's process document supplies fields Jonathan's tabs do not carry;
those are marked **[Dan]**. Dan's 2026-08-09 answers supply the status model.

**This file is the contract.** Subagents read it and never edit it. If a field is
missing or wrong, add a line to `11-open-questions.md` and stop.

**Phase gating:** a field is hidden until its phase is reached, then stays
visible. Combined with role (`05-roles.md`) this is what keeps the tabs clean —
the LendingWise pain point Dan is paying to escape.

---

## Loan lifecycle

Phases, in order. Every transition is date/time stamped, and days-in-current-status
is computed and shown.

| Phase | Statuses |
|---|---|
| **Pre-Approval** | Credit Review → Pre-Pre-Approval Requested → Internal Approved → Investor Approval Requested → Pre-Approved \| **Not Pre-Approved** → LOI Issued → LOI Signed |
| **Pre-Processing** | Pre-Processing |
| **Processing** | Processing |
| **Internal Review** | In Review → Items Requested → Approved |
| **Investor Review** | In Review → Items Requested → Approved \| Conditionally Approved \| Feedback Requested |
| **Approved / Closing** | Docs Approved → Docs Sent → Docs Signed → Cleared to Close → Funded |

Dan's original chain (`Credit Review, Credit Request, Pre-Approval Requested,
Pre-Approved, LOI Issued, LOI Signed`) was **replaced on 2026-08-09**.
`Credit Request` no longer exists. See `10-decisions.md` D-001.

Internal and Investor Review are **not linear** — In Review → Items Requested →
In Review again, repeatedly. Dan: *"Time date in, time date out. And then time
date back in, time date back out, time date approved."* Each leg is timestamped
separately.

---

## Permutations

The only dynamic thing in Phase 1. These drive the needs list.

| # | Permutation | Values | Add-on variables |
|---|---|---|---|
| i | **Channel** | Direct · Broker | Repeat Borrower (Y/N) · Repeat Broker (Y/N) · Global Required (Y/N) |
| ii | **Transaction Type** | Purchase · C/O (cash-out refi) · NCO (no-cash-out refi) | Portfolio Refinance (Y/N) |
| iii | **Property Type** | SFR · 2-4 Unit · MFR | Lot Split (Y/N) · Condo Map (Y/N) · ADUs (Y/N) |
| iv | **Loan Type** | Bridge · Heavy Reno · Light Reno · GUC · **DSCR** | Mid Construction (Y/N) · Weather Tight (Y/N) |
| v | **Capital Source** | Fortress · SCIF · Churchill · others | — |

Notes:
- **Lot Split and Condo Map are separate variables**, not one.
- **DSCR** was added verbally by Dan on 2026-07-31; it is missing from his
  written document.
- Jonathan's `Project` sheet writes transaction type as **Purchase, C/O, NCO** —
  three values, not two. Dan's process document says "Purchase vs Refinance"
  with a Portfolio Refinance add-on. Three values is the later, more specific
  form; use it.
- **Seven of the nine add-on variables currently drive nothing.** Of the add-ons,
  only **Global Required** and **Mid Construction** have rules — they are the two
  Dan gave worked examples for. The main permutations (Channel, Transaction Type,
  Property Type, Loan Type) all drive rules. Dan owes us the matrix —
  `11-open-questions.md` Q-001. Capture and store all nine regardless, and say on
  screen which are inert.

---

## Tab: Sponsor

| Field | Phase | Notes |
|---|---|---|
| # of Guarantors | Pre-Approval | Jonathan's sheet says 1 at Pre-Approval, more later. We support N from the start — Dan: *"Ability to Add Additional Guarantors throughout"* |
| Guarantor N First Name | Pre-Approval | |
| Guarantor N Last Name | Pre-Approval | |
| Guarantor N Repeat (Y/N) | Pre-Approval | Dan calls this **Repeat Borrower** |
| Guarantor N Email | Pre-Approval | |
| Guarantor N Phone Number | Pre-Approval | |
| Estimated Experience Tier | Pre-Approval | |
| Minimum FICO | Pre-Approval | |
| Minimum Ownership | Pre-Approval | Guarantor must represent ≥51% of project equity |
| Guarantor N Middle FICO | Pre-Processing | |
| Borrowing Entity | Processing | Also needed by Lightning Docs |
| **Authorization Status** **[Dan]** | Pre-Processing | Need · Sent · Signed, **per guarantor** |
| **Application Status** **[Jonathan 10 Aug]** | Pre-Processing | Need · Sent · Signed, per guarantor. Every guarantor completes one |
| **Disclosures Status** **[Jonathan 10 Aug]** | Pre-Processing | Need · Sent · Signed. **Guarantor 1 only** — the card reads *Primary only* for everyone else |
| **Track Record** **[Dan]** | Pre-Processing | No Initial · Initial · Complete |
| **No Fly List result** **[Dan]** | Pre-Approval | Checked against CHRE and Spreo Capital lists on entry |

## Tab: Project

| Field | Phase |
|---|---|
| Transaction Type (Purchase, C/O, NCO) | Pre-Approval |
| Loan Type (DSCR, Bridge, LR, HR, GUC) | Pre-Approval |
| Property Type (SFR, 2-4 Unit, MFR) | Pre-Approval |
| Property Street Address | Pre-Approval |
| Property City | Pre-Approval |
| Property State | Pre-Approval |
| Property Zip Code | Pre-Approval |
| Purchase Price | Pre-Approval |
| Purchase Date | Pre-Approval |
| Estimated AIV | Pre-Approval |
| Estimated ARV | Pre-Approval |
| Appraised AIV | Processing |
| Appraised ARV | Processing |
| Final Total Budget | Processing |
| **All add-on variables** **[Dan]** | Pre-Approval |

## Tab: Loan

| Field | Phase |
|---|---|
| Broker (Y/N) | Pre-Approval |
| Term | Pre-Approval |
| # of 3-month extensions | Pre-Approval |
| Loan Coupon | Pre-Approval |
| Extension Fee | Pre-Approval |
| Processing Fee | Pre-Approval |
| Recourse Type | Pre-Approval |
| Draw Fee | Pre-Approval |
| Initial Loan Amount | Pre-Approval |
| Holdback | Pre-Approval |
| Interest Reserve | Pre-Approval |
| Initial Loan Amount — Final | Processing |
| Holdback — Final | Processing |
| Interest Reserve — Final | Processing |
| **Capital Source** **[Dan]** | Pre-Approval |
| **Target Submission Date** **[Dan]** | Pre-Processing |
| **Target Funding Date** **[Dan]** | Pre-Processing |
| **LOI Funding Date** **[Dan]** | Pre-Processing |
| **Insurance Paid** **[Pulse]** | Processing |
| **Rate Lock Expiration Date** **[Pulse]** | Processing |
| **UPB** **[Pulse]** | Pre-Approval — "Not Final" until Internal Review, then "Final" |
| **Note Rate** **[Pulse]** | Pre-Approval |

## Tab: Transaction

The largest tab. Four groups, each opening in its own popup.

### Group: Pre-Approval milestones

| Field | Phase |
|---|---|
| Appraisal Invoice Date/Time | Pre-Approval |
| Pre-Approval Request Date/Time | Pre-Approval |
| Pre-Approval Approval Date/Time | Pre-Approval |
| LOI Issue Date/Time | Pre-Approval |
| LO Expiration Date | Pre-Approval |
| LOI Estimated Funding Date | Pre-Approval |
| LO Assignment | Pre-Approval |
| LOI Signed Date | Pre-Approval |
| **LOI Delivery** (`docusign` \| `pdf`) **[Jonathan 10 Aug]** | Pre-Approval |
| **LOI Sent By Hand Date/Time** — the PDF path only **[Jonathan 10 Aug]** | Pre-Approval |
| **LOI Signed By** — who put their name to it **[Jonathan 10 Aug]** | Pre-Approval |
| **LOI Notes** — freeform, merged into the letter **[Jonathan 10 Aug]** | Pre-Approval |
| Appraisal turn-around time (days) | Pre-Approval |
| Appraisal Company (AMC) | Pre-Approval |
| **Appraisal Ordered (Y/N) + Date/Time** **[Dan]** | Pre-Approval |
| Kick-Off Email Time/Date | Pre-Processing |
| Budget Vendor Order Time/Date | Pre-Processing |
| PSA Date | Processing |

### Group: Appraisal

| Field | Phase | Values |
|---|---|---|
| Status | Processing | Requested · Invoice Sent · Paid · Received · Under Review · Challenged · Approved Pending Budget · Final |
| Invoice Paid Date/Time | Processing | |
| Inspection Scheduled Date | Processing | |
| Inspection Occurred Date | Processing | |
| Draft Budget Provided (Y/N) | Processing | |
| Draft Plans Provided (Y/N) | Processing | |
| Expected Delivery Date | Processing | Dan calls this **Promised Delivery Date** |
| **Target Delivery Date** **[Dan]** | Processing | A typed date, not calculated |
| **Appraiser Need** **[Dan]** | Processing | None · Budget · Plans · Budget & Plans |
| **Appraiser Needs Provided Date/Time** **[Dan]** | Processing | |
| Received Date/Time | Processing | |
| Initial Approval Date | Processing | |
| Final Approval Date | Processing | |
| **Appraisal Fee (shown as POC)** | Processing | Lightning Docs |

Inspection is **not** a status. It is separate facts, so a visit happening early
or late does not rewind the order. `Challenged` branches off `Under Review` and
the order stays open. `Approved Pending Budget` settles to `Final` when the
budget is approved.

### Group: Budget

| Field | Phase | Values |
|---|---|---|
| **Need** **[Dan]** | Pre-Processing | **Scrub** or **Feasibility** — chosen at order time |
| **Vendor Need** **[Dan]** | Processing | None · Budget · Plans · Budget & Plans |
| Status | Processing | Ordered · Received · Under Review · Approved |
| Inspection Scheduled Date | Processing | Tracked separately from the appraiser's visit |
| Inspection Occurred Date | Processing | |
| Draft Budget Provided (Y/N) | Processing | |
| Draft Plans Provided (Y/N) | Processing | |
| Expected Delivery Date | Processing | |
| **Target Delivery Date** **[Dan]** | Processing | |
| Received Date/Time | Processing | |
| Budget Internally Approved Date/Time | Processing | |
| Budget sent to Appraiser Date/Time | Processing | Pulse column: **Budget to Appraiser (Y/N)** |
| Client Sign-off Date | Processing | |

### Group: Refinance facts **[Dan]**

| Field | Phase | Values |
|---|---|---|
| VOM Status | Pre-Processing | Not Ordered · Ordered · Received |
| Payoff Status | Pre-Processing | Not Ordered · Ordered · Received |
| Escrow contact provided | Pre-Processing | Purchase only |

### Group: Loan Documents (Lightning Docs)

Everything Closing needs. Phase **Processing**, and only visible once the loan is
investor-approved or to the Closing role.

Funding Entity · Borrower Notice Address · Borrower Signatories and titles ·
Broker License # · Broker Address · Loan Servicer · Property APN · Release
Pricing (if applicable) · Lien Position · Governing law state · Governing law
county · Loan Number · Default Interest Rate · I/O payments & amortization term ·
MERS ID (if applicable) · Type of construction reserve · Dutch / Non-Dutch
Interest · Prepayment premium · Tax/Insurance/PITI escrows · Title report number ·
Title report effective dates · Exceptions to be removed from title · Signature
Affidavit and AKA statement info · Guaranty types (full vs limited recourse) ·
Guarantor marital status · Guarantor notice addresses

Plus **[Dan, 2026-08-09]** post-signature: **Wire reference** · **Funding date** ·
**Servicer tape generated**.

### Ungrouped

| Field | Phase |
|---|---|
| Kick-Off Call (transcripted) Date/Time | Processing |

## Tab: Contacts

| Field | Phase |
|---|---|
| Broker N First / Last Name | Pre-Approval |
| Repeat Broker (Y/N) | Pre-Approval |
| Broker Company / Email / Phone Number | Pre-Approval |
| Title Company · Title Agent N First / Last / Email / Phone | Pre-Processing |
| Escrow Company · Escrow Agent N First / Last / Email / Phone | Pre-Processing |
| Insurance Company · Insurance Agent N First / Last / Email / Phone | Pre-Processing |
| Law Company · Lawyer N First / Last / Email / Phone | Pre-Processing |
| Appraisal Company · Appraiser N First / Last / Email / Phone | Pre-Processing |

Every contact type is **N** — repeatable.

## Tab: UW Material

Jonathan's sheet carries requirements, not fields:

| Requirement | Phase |
|---|---|
| Underwriting Standard Needs | Pre-Processing |
| Dynamic to inputs — loan type, # of guarantors, including PACER / Background / UCC / Credit / Pre-Approval | Pre-Processing |
| Ability to easily add / subtract items | Pre-Processing |

The needs list itself is generated at Pre-Approval when Credit saves the
permutations, and verified there. See the behaviour notes.

Per document: requirement key · label · group · source variable (provenance) ·
borrower-facing (Y/N) · not-needed reason · submission state · Spreo review
state · third-party review state · follow-up sub-items.

## Tab: Communications

Ten named templates. Detail in `06-communications.md`.

| Template | Phase |
|---|---|
| Appraisal Invoice Request | Pre-Approval |
| Pre-Approval Request (sections/subject) | Pre-Approval |
| Kick-off Email | Pre-Processing |
| Title Kick-off | Pre-Processing |
| Escrow Kick-off | Pre-Processing |
| VOM & Payoff Request | Pre-Processing |
| Kick-off Legal | Pre-Processing |
| Appraisal Invoice to Client | Pre-Processing |
| Budget Vendor Kick-off | Pre-Processing |
| Ongoing Needs List | Pre-Processing |

## Tab: Reporting

Generated artifacts, not fields.

| Artifact | Phase |
|---|---|
| Letter of Intent | Pre-Approval |
| Liquidity Requirement | Pre-Approval |
| Purchase Authorization | Pre-Approval |
| Refinance Authorization | Pre-Approval |
| Guarantor Authorization (2nd or greater) | Pre-Approval |
| Outstanding Item by Loan | Pre-Approval, Pre-Processing |
| Appraisal Status Report | Pre-Approval, Pre-Processing |
| Budget Status Report | Pre-Approval, Pre-Processing |
| Investment Committee Summary | Pre-Approval, Pre-Processing |
| Loan Docs | Processing |

## Tab: Pulse

Built last. Renders the same data in report form. Columns by phase, from
`Pulse-Pipeline-Fields`:

**All phases:** LO · CM · Capital Source · Property Address · Property City ·
Property State · Transaction Type · Loan Type · Property Type · Total Loan
Amount · UPB · Note Rate · Days in Current Status · LOI Funding Date · Signed
LOI to LOI Funding Date

**Pre-Approval adds:** Sub-Status

**Pre-Processing adds:** PSA Closing Date · Appraisal Status · Appraisal
Outstanding · BA Status · BA Outstanding · VOM Status · Payoff Status ·
Appraisal Company · Track Record Status · Authorization Status · Portfolio
Refinance (Y/N) · Repeat Borrower (Y/N)

**Processing adds:** Target Submission Date · Target Funding Date · Target
Appraisal Date · Target Budget Date · Budget to Appraiser (Y/N) · Insurance
Paid · Rate Lock Expiration Date

**Internal Review / Investor Review:** same as Processing, plus Sub-Status.
Total Loan Amount and UPB switch from "Not Final" to "Final".

**Approved drops** appraisal, budget, VOM, payoff, track record and
authorization columns — that work is done.

---

## LOI merge variables

The 28 variables printed onto the LOI. Every one must resolve before
`Generate LOI` can run. Source: `LOI Fields` sheet.

Sponsor/Guarantor name · LO name · Broker name (if applicable) · Conditional
Offer Valid Until · Loan Amount · Purchase Price · Renovation Budget · Estimated
ARV · Property Type · Purpose · Funding · Term · Interest Rate · Prepayment
Penalty · Collateral · Lender Origination Fee · Loan Docs/Due Diligence ·
Appraisal · Junior Liens · 3rd Party Fees · Recourse · Draw Fee · Credit Score ·
Equity Partners · Due on Sale · Sellers Concessions · Est. Funding Date ·
Liquidity Requirement

Most are long boilerplate paragraphs with merged numbers, not short values —
see the sheet for the exact wording, which is Spreo's legal language and must be
reproduced verbatim.

Jonathan's own note on that sheet, still unanswered: *"Do we need various
versions of the LOI for dynamic formats and cases."* → `11-open-questions.md` Q-011.

---

## Derived values

Never stored. Computed on read, with provenance shown.

| Value | Rule |
|---|---|
| Days in Current Status | now − last status change |
| Calculated Funding Date | later of budget or appraisal delivery date **+ 4 business days** |
| Calculated Submission Date | later of budget or appraisal delivery date |
| Signed LOI to LOI Funding Date | LOI Funding Date − LOI Signed Date |
| Appraisal Outstanding | what the appraiser still needs, from Appraiser Need |
| BA Outstanding | what the budget vendor still needs, from Vendor Need |
| Documents complete % | approved ÷ needed on the needs list |

Dan on the calculated dates: *"it's dynamic against these actual events… you can
look at it and be like, why is this so different? And you can manage the
variances."* He picked four business days himself: *"let's just make it obvious.
Let's just say four business days."*

---

## The Processing gate

Four conditions, all objective. Dan: *"Until that happens, the loan stays in
pre-processing."*

1. Appraisal **paid**
2. Escrow contact provided — **only if purchase**
3. **All** guarantor authorizations signed and received
4. Track record at **Initial**

Whether this hard-blocks or merely reports is `11-open-questions.md` Q-004. Until
Dan rules, it **blocks**, with an audited override — his words say blocks.

---

## Document states

Three layers. The client never sees internal states.

| Layer | States |
|---|---|
| Submission | Not received · **Received** (automatic on upload) |
| Spreo review | Approved · Rejected · Need Additional |
| Third-party review | Approved · Rejected · Need Additional |

Dan: *"The second it goes in, it auto moves to received."* And: *"I don't need it
to say toggle it to under review. When I hit approve, it hits approved and then
pushes to offshore."*

Client-facing wording, from the 2026-07-31 call: **Under Review** (meaning
received) and **Outstanding**. Dan rejected "Received" as the client-facing word:
*"why are you sending them a list if you're saying it's already been received?
It's kind of like it's under review. Meaning like we are actioning it."*
