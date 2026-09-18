# The process

Dan's numbering, as built. His own document is `sources/dan-phase-1-process-document.md`;
this says what each line became.

---

## Pre-Approval

Owned by **Credit**. Dan: *"Literally in pre-approval, there's nothing client
management will do. The only thing somebody outside of credit will do, it'll be
the salesperson emailing information."*

**Statuses (D-001):**
`Credit Review → Pre-Pre-Approval Requested → Internal Approved → Investor
Approval Requested → Pre-Approved | Not Pre-Approved → LOI Issued → LOI Signed`

1. **The loan is created by the LO** with five fields — full address, purchase
   or refi, portfolio refi, repeat borrower, approximate loan amount. The
   `submissions@` email carrying structure, write-up and valuation happens in
   Outlook, **outside the system** (D-002).
2. **No Fly check** against CHRE and Spreo Capital. Runs where guarantor names
   are entered. A match raises a banner, pops on opening the record, and gates
   LOI generation until a manager overrides with a reason.
3. **Credit refines offline**, then presses **Pre-Pre-Approval Request** — a
   template that opens an editable email form: merged subject, typed body,
   attachments, configured recipients. Status moves on send.
4. **Dan replies in Outlook.** Recording the reply moves the loan to
   Internal Approved.
5. **Pre-Approval to Investor** — same pattern. Reply records Pre-Approved or
   Not Pre-Approved.
6. **Credit populates the permutations** — five, with nine add-ons. Saving them
   generates the needs list. This is the only dynamic thing in Phase 1.
7. **Credit verifies the needs list**, adds special items, removes with a reason.
8. **The LOI package** — one document: the LOI, the liquidity requirement, the
   transaction authorization branched purchase/refi, the guarantor 2+
   authorizations (identity and credit only), and the loan checklist.
9. **One Send** issues the LOI *and* orders the appraisal from the chosen AMC
   (D-011). Status → LOI Issued. The signed LOI is recorded by hand → LOI Signed.

---

## Pre-Processing

Owned by the **Client Manager**, assigned when the LOI is signed.

1. **The named emails**, each stamped: Pre-Processing (cc LO) · Order Budget
   Scrub or Feasibility (bcc LO) · Appraisal Invoice to client (cc LO) · Title,
   Escrow and Legal kick-offs · Order Flood · plus Disclosures and Application,
   which Dan added verbally.
2. **The CM refines the needs list** — pre-filling anything already held from a
   prior loan, so the client is not asked twice. Carried-over evidence still runs
   the whole review path (D-020).
3. **Release the customised needs list** via the Kick-off Email to broker,
   guarantor 1, guarantors 2..n, cc the LO. **Nothing is visible to the borrower
   before this moment.**
4. **Operating facts tracked** — appraisal and budget with their own statuses,
   inspections and dates; VOM; payoff; authorizations; track record; targets.

### The gate into Processing

Four conditions, all objective. Enforced server-side — a transition is refused
with `409` naming what is unmet, with an audited override.

1. Appraisal **paid**
2. Escrow contact provided — **purchase only**
3. **All** guarantor authorizations signed and received
4. Track record at **Initial**

---

## Processing

Documents arrive and are validated in three layers: submission (auto-Received on
upload) → Spreo review → third-party review. Append or replace; nothing deleted.
Follow-ups attach under an item, not as new top-level items.

---

## Internal Review

Exception-based, not a re-approval. Dan: *"Do it more on an exception basis
instead of an approval basis."*

The reviewer receives a templated email with the loan summary and the files —
the dry run for the investor package. They record findings as a free-form list,
and **nothing approves while a finding is open**. Clearing one requires a note.
Sending back moves the loan to Items Requested and emails the numbered findings
to the CM and the working group — **never to the client**.

The loop repeats: In Review → Items Requested → In Review. Each leg is
timestamped separately.

---

## Investor Review

Same shape, recorded on the investor's behalf — they never log in. Statuses:
In Review · Items Requested · Approved · Conditionally Approved · Feedback
Requested. Repeatable.

---

## Approved → Loan Documents

Generate via Lightning Docs from Closing's field set, then Docs Approved → Docs
Sent → Docs Signed → Cleared to Close → Funded.

**After signature (D-008):** wire reference, funding date, servicer tape. Dan is
documenting the rest (Q-002).
