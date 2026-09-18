# Dan's Phase I process document — verbatim

**File:** `Phase I.rtf`, provided by Dan Frankel on the 2026-07-31 call.

**What it is:** the process, in Dan's own numbering, in his own words. He walked
this document line by line for 135 minutes on 2026-07-31. That call transcript is
how we work out what each line *means*; this document is what the lines *are*.

**Authority:** this is the process spec. Where a later call or Dan's 2026-08-09
answers change a line, the later ruling wins and is recorded in
`docs/DECISIONS.md` — but the numbering here stays, because it is how Dan refers
to his own process.

---

## Pre-Approval

1. Ping "No Fly Lists" (CHRE + Spreo Capital)

2. Important Settings (all Date/Time stamped for reporting + show days in status
   on pipeline)
   - a. **Phases:** Credit Review, Credit Request, Pre-Approval Requested,
     Pre-Approved, LOI Issued, LOI Signed
   - b. **Other:** Appraisal Ordered (Y/N), Appraisal Ordered Date/Time selection,
     LOI, Pre-Approval Time/Date (pulled in from email), LOI sent time/date
     (pulled from email) => credit to send via template even in cases where also
     sent via Docusign, Days in Current Status

3. Enter in all data points needed to create LOI
   - a. **Important permutations:**
     - i. **Direct vs Broker**
       1. Add-on variable: Repeat Client (Y/N), Repeat Broker (Y/N), Global
          Required (Y/N)
     - ii. **Purchase vs Refinance**
       1. Add-on variable: Portfolio Refinance (Y/N)
     - iii. **Property Type:** SFR, 2-4 Unit, MFR
       1. Add-on variables: Lot Split (Y/N), Condo Map (Y/N), ADUs (Y/N)
     - iv. **Loan Type:** Bridge, Heavy Reno, Light Reno, GUC
       1. Add-on variables: Mid Construction (Y/N), Weather Tight (Y/N)
     - v. **Capital Source:** Fortress, SCIF, Churchill, X, Y, Z, etc.

4. Order Appraisal via email template (to be used for AMCs that allow email
   ordering)

5. Verify "Needs List"
   - a. System should create a dynamic needs list. Credit to verify it is correct
     (maybe an incorrect permutation was selected) + add any "special items" or
     subtract anything

6. Create: LOI + Liquidity Requirement + Purchase or Refi Authorization → single
   PDF

7. Create: Authorization for Guarantor 2, 3, 4, 5, etc. (doesn't request payoff
   or escrow info)

8. Provide Invoice link to CM & LO via email template

9. Create Loan Checklist (driven by needs list)

---

## Pre-Processing

1. Send the following emails via templates & save Date/Time Stamp:
   - a. Pre-Processing (cc LO)
   - b. Order Budget Scrub or Feasibility: Purchase, Refi, Refi – Mid
     Construction (bcc LO)
   - c. Appraisal Invoice to client (cc LO)
   - d. Title Kick-off
   - e. Escrow Kick-off
   - f. Legal Kick-off — variable to state/county
   - g. Order Flood

2. "Verify Needs List"
   - a. Upload Items to folders if items are on file from prior loans or already
     received
     1. Settings: Received, Internal Approved/Rejected/Need Additional, Third
        Party Approved/Rejected/Need Additional

3. Send the updated/customized Needs List to Client (Broker, Guarantor 1,
   Guarantor 2, 3, 4….. & CC LO) via the "Kick-off Email"

4. Important Settings / Dates
   - a. **Appraisal**
     1. Status: Requested, Invoice Sent, Paid, Received, Under Review,
        Challenged, Approved Pending Budget, Final
     2. Promised Delivery Date
     3. Target Delivery Date
     4. Appraiser Need: None, Budget, Plans, Budget & Plans
     5. Inspection Scheduled: Y/N
     6. Inspection Occurred: Y/N
     7. Inspection Occurred Date
     8. Appraiser Needs Provided Date/Time
   - b. **Budget**
     1. Need: Scrub, Feasibility
     2. Vendor Need: None, Budget, Plans, Budget & Plans
     3. Inspection Scheduled: Y/N
     4. Inspection Occurred: Y/N
     5. Inspection Occurred Date
     6. Promised Delivery
     7. Target Delivery Date
   - c. VOM Status: Ordered, Received, Not Ordered
   - d. Payoff Status: Ordered, Received, Not Ordered
   - e. Authorization Status: Complete, Need 1, Need 2, Need 3, Need 4, Need 5,
     Need 6….
   - f. Track record: No Initial, Initial, Complete
   - g. Target Submission Date
   - h. Target Funding Date
   - i. PSA
   - j. LOI Funding Date

5. Accept & Approve Documents
   - a. Add follow up requests
   - b. Push items to Setpoint or Off-shore

6. Reports
   - a. Loan Summary (IC Summary)

> \* Loan goes to Processing once appraisal paid, escrow contact provided (if
> purchase), all authorizations signed/received and track record = initial

---

## Loan goes to Processing

- Send templated email to internal review with report + Third Party Findings

## Loan goes to Internal Review

- Template email back to team on findings
- Ability to flag UW docs based on findings

## ….Approved

- Run loan docs

---

## Additions Dan made verbally that are not in this file

Recorded here so the document is not treated as complete on its own.

| Source | Addition |
|---|---|
| 2026-07-31 call | **DSCR** added to Loan Type — "the one loan I missed, John, if you can just add, is DSCR" |
| 2026-07-31 call | **Disclosures** and **Application** added to the Pre-Processing email list — "after C, just write disclosures, and then the next, add one more, application." Both go out via DocuSign |
| 2026-07-31 call | **Initial needs list** added to the single PDF in Pre-Approval §6 — "and initial needs list. So the initial needs list will be in there" |
| 2026-07-31 call | **Calculated Submission Date** and **Calculated Funding Date** added to §4. Calculated funding = later of budget or appraisal delivery date + ~4 business days. Calculated submission = later of budget or appraisal date |
| 2026-07-31 call | **"Ability to flag UW docs based on findings" retracted** — "I don't even think they should flag any UW docs. Let's just get rid of that. I think that's weird" |
| 2026-07-31 call | Post-Approved steps expanded: generate loan docs via Lightning Docs → approve loan docs → send loan docs → statuses (Docs Approved, Docs Sent, Docs Signed, Cleared to Close, Funded) → enter post-funding data (funding date, wire number) → generate servicing tape |
| 2026-07-31 call | An **Excel tape** is also needed at final approval — "that's what you send to the investor… it's just seven things. Address, rate…" |
| 2026-08-04 call | **No SLAs.** "Everything is as soon as possible." Days in status replaces due dates entirely |
| 2026-08-04 call | The **status email** to the client: Mon/Wed/Fri 8am default, configurable cadence, every outstanding item in one message, no due dates |
| 2026-08-04 call | **Trigger emails** to appraiser and budget vendor. Dan: "And they're just said triggers. They're not an SLA." … "And I can list them all." The follow-up *"There could be, like, six of them"* is **Jonathan's line, not Dan's** — so the count of six is not Dan's |
| 2026-08-09 answers | The whole Pre-Approval status chain is replaced. See `docs/sources/2026-08-09-dan-answers-open-questions.md` |
