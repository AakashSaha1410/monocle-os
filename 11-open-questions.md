# Open questions

The **only** list. Nothing blocks on an answer — we take the least-surprising
option, mark the assumption on screen, and record it here.

Two sections: what Dan or Jonathan must answer, and what Aakash must answer.

---

## For Dan / Jonathan

| # | Question | Why it matters | What we did meanwhile |
|---|---|---|---|
| Q-001 | **The permutation matrix.** Dan lists nine add-on variables. **Seven drive nothing** — Repeat Borrower, Repeat Broker, Portfolio Refinance, Lot Split, Condo Map, ADUs, Weather Tight. Only Global Required and Mid Construction have rules, because they are the two he gave examples for. Which needs-list items does each of the other seven add or remove? | Biggest single unlock. Dan offered it on 2026-07-31: *"we'll give you all the variables. 100%."* | All nine captured, stored and wired. The permutations popup labels each inert one **"drives nothing yet"** on screen rather than pretending |
| Q-002 | **Post-Lightning-Docs fields.** Dan is documenting what happens after loan docs are signed beyond servicer tape, wire reference and funding date | Sizes the Closing tab | Built the three he named |
| Q-003 | **IC / Loan Summary format.** Dan: *"I'll give you guys that. It's just going to be very straightforward"* — outstanding since 2026-07-31 | The report the internal underwriter and the investor both read | Placeholder that says so on its own face |
| Q-004 | **Does the Processing gate hard-block?** Dan's words say the loan stays in pre-processing. Is that a hard block or advisory? | Changes whether staff can be stopped by the system | **Blocks**, with an audited override. His words say blocks |
| Q-005 | **Setpoint delivery.** Box subfolder structure, an API, or manual? And their review cadence — do they pick items up as they arrive or need a complete package? | Third-party review routing | Records the routing decision, does not transmit |
| Q-006 | **PSA — a date or a status?** Dan's process document lists "PSA"; Jonathan's Transaction sheet says "PSA Date"; the Pulse sheet says "PSA Closing Date" | Field type | Stored as a date, named PSA Closing Date |
| Q-007 | **CM auto-assignment.** Three options now, not two: by rule (this LO always goes to this CM), by hand, or **a report of loans waiting to be assigned** that someone works through. Jonathan, 2026-08-10: *"does he want them to auto-assign, or does he want all of these to sit — the ones that are ready to be assigned — in a report, and then someone goes in and assigns them."* For scale: roughly five LOs, three client managers, two or three credit | Whether LOI Signed can auto-assign, and whether a queue is needed | Manual assignment, from the loan header, with reassignment. Every change is written to the status history. No rule, no report |
| Q-008 | **Order Flood** appears in no transcript — only in Dan's document. Who is it to, and what comes back? | Cannot write the template without it | Template exists with placeholder recipient, marked on screen |
| Q-009 | **Legal Kick-off "variable to state/county".** Does that vary the template, the recipient, or whether it fires at all? | Template design | Varies the template and puts state in the subject. No county capture |
| Q-010 | **Nine emails, not seven?** Dan added **Disclosures** and **Application** verbally on 2026-07-31, both via DocuSign. They are not in his written list | Pre-Processing scope | Both built |
| Q-011 | **Multiple LOI versions?** Jonathan's own note on the LOI Fields sheet: *"Do we need various versions of the LOI for dynamic formats and cases"* | Template count | One template, dynamically merged |
| Q-012 | **Borrower-facing flags.** Dan's Docs sheet marks four items No and leaves the rest blank | What the client sees | Credit, background, PACER, UCC and the Google search set internal because Spreo pulls them. Marked on screen as our call |
| Q-013 | **The three review columns** — Review 1 / External / UW — are blank on Dan's Docs sheet. Which items route to each layer? | Third-party routing | Everything routes the same way |
| Q-014 | **Churchill's No Fly list** — where does it live and how should it reach us? | Sync vs upload | Manual entry and bulk upload. No sync |
| Q-015 | **Click-to-call in Phase 1?** Jonathan asked Dan to decide. SMS is already ruled out | Small scope item | Not built |
| Q-016 | **Loan creation contradiction.** Dan's 2026-08-09 answer says the LO creates the record by hand with five fields and the `submissions@` email is *outside* the system. Jonathan on 2026-08-06 described two entry points including an inbound email that creates the record | Which entry point is real | **Both.** Manual creation is primary; inbound email simulation retained behind a demo control |
| Q-017 | **Prior evidence validity windows.** How long does a credit authorization, government ID or background report stay good? Dan mentioned 90 days for credit reports and authorizations | Needed before documents carry over automatically | 90 days everywhere, shown as an assumption |
| Q-018 | **Guarantor identity across loans.** What is the unique identifier for matching a guarantor to prior loans? Dan believes it is extractable from LendingWise | Prior-evidence matching | Matched on email. A match offers the prior file for carry-over; taking it re-runs the whole review path |
| Q-019 | **The trigger emails.** Dan: *"And I can list them all."* Still not sent. **"Six" is Jonathan's word, not Dan's** — on the 2026-08-04 recording Dan says *"And I can list them all"* and Jonathan answers *"There could be, like, six of them"* | Trigger criteria, and how many there are | Six built from the 2026-08-04 call. Criteria shown on each. Ask Dan for his own list and his own count |
| Q-020 | **Streamline push.** Dan wants a button, after internal review approval, that pushes all items to Churchill's Streamline folders. He called it *"a big win"* | Phase 1 or later? | Not built |

| Q-031 | **Appraisal intake — which of three can he live with?** (1) Ordered through the system, every event after that typed in by the CM. (2) Ordered through the system, then the AMC fills a **web form** — inspection date, invoice, report upload — which maps one-to-one. (3) Free-form email both ways, read by an intelligence layer. Jonathan asked for all three to be put to Dan with pros and cons, and for a **mock screenshot** of the form | Sizes the largest remaining unknown in the build. See D-043 | Option 1 is built. The other two are presented, not built |
| Q-034 | **Should a No Fly override outlive the guarantor it was given for?** Today the override row is deleted with the guarantor, so removing a flagged person erases the record that management ever cleared them. Arguably an audit trail should survive its subject | Whether "the clearing is recorded" holds after a removal | Cascade delete, as the schema was first written. Say the word and it becomes a surviving row |
| Q-035 | **The appraisal invoice link has no client manager to go to.** Dan puts it at LOI Issue — credit passes it inward — but the client manager is only assigned at LOI Signed, one step later. So the template's recipient rule (`cm · cc lo`) resolves to nobody | Whether the email waits, goes to the LO, or the CM is assigned earlier | The address is typed in by hand, and the demo says why |
| Q-032 | **No Fly bulk upload — is there a template to download and fill?** Jonathan: *"would there actually be a template that you would download and would upload?"* Aakash: *"depends on how much data"* | Whether we match on names alone or on emails and phone numbers too | Names only, pasted or uploaded. No template |
| Q-033 | **What belongs in the LOI package, and what is sent separately at pre-processing?** Disclosures and the application may be absorbed into the LOI step for guarantor one, leaving only later guarantors to be sent separately. Jonathan: *"we just need a little clarification there"* | Whether two of the nine pre-processing emails exist at all | Both sent separately, as Dan described them on 31 July. The LOI carries only its own four parts |

## For Aakash

| # | Question | Recommendation |
|---|---|---|
| A-001 | Jonathan's workbook Sheet1 excludes appraisal ordering by email and says capital-partner submission happens outside the system. Dan's 2026-08-09 answers put both **inside**. Confirmed dead rows? | Yes — later beats earlier, and you said do more not less. Both built inside the system |
| A-002 | Sheet1 also excludes Deal Desk submission and Pre-Approval scope generation, because *"phase 1 begins when an LOI needs to be generated."* But Dan's 2026-08-09 answer describes a whole approval chain before the LOI | Build the chain. It is Dan's, and it is later |
| ~~A-003~~ | ~~The deployed worker name~~ | **Answered 2026-08-09: `Spreo-Capital-P1`.** See D-025 |
| ~~A-004~~ | ~~The Aug 6 transcript is missing from sources~~ | **Done 2026-08-09.** Saved verbatim to `docs/sources/2026-08-06-spreo-capital-os-transcript.md` |

---

## Added while building

| # | Question | Why it matters | What we did meanwhile |
|---|---|---|---|
| Q-021 | **The document catalogue.** Dan's own Docs sheet is not in Jonathan's workbook, and Jonathan's UW Material sheet carries requirements rather than the item list. Ours is assembled from what the sources actually name | It is the needs list. Every item, its group, and whether the borrower sees it | 30 requirements built, each citing where it came from. Two are marked **assumed by us** on screen — Insurance Binder and Rent Roll. Ask Dan for his Docs sheet |
| Q-022 | **Who releases the needs list?** The kick-off email is the CM's, but nothing says whether Credit can release early | Controls when the borrower first sees anything | Any role can release; the action is stamped and logged |
| Q-023 | **The investor tape columns.** Dan named *address* and *rate* of seven, then had to leave the call. He also implied a tape at pre-approval as well as at final approval | It is what goes to the capital partner | Built with his two, plus five labelled **ours** — Total Loan Amount, Loan Type, Property Type, Term, Target Funding Date. Downloads as .csv |
| Q-025 | **Where does a resubmission go back to?** Jonathan, 2026-07-28, asked this and answered it provisionally: if the underwriter asked for it, the new file returns straight to the underwriter and skips internal and third-party review, because by then the loan is in a sprint. He was "99% sure" and said he would confirm with Dan. He never did | Routing after every rejection late in the process | Built the provisional answer — underwriter requests return to the underwriter; Spreo and third-party requests go back through the gates |
| Q-026 | **Immediate or packaged routing to third-party review?** Documents can go the moment Spreo approves, or wait for a whole package. Which items belong to which is unset | Third-party review pace | Both routes built and set per document, with a Packages view. Every item defaults to **immediate** until Dan says which belong to a package |
| Q-027 | **An inbox inside the system.** Dan, 2026-07-23: *"Why ever use Outlook?"* Jonathan scoped it to credit, client management and closing. But Dan's 2026-08-09 answers assume replies land in Outlook | Whether staff live in the platform or in Outlook | Not built. Emails send from the loan; replies are recorded by hand |
| Q-028 | **A chat thread per loan**, LO and CM added automatically. Dan: *"we had a Slack channel for every loan."* His own concern: people treat it as replacing email while the other person is not watching | Internal communication | Not built. Notes on the loan only |
| Q-029 | **Which documents each capital partner requires.** Aakash proposed per-partner requirements on 2026-07-29 and Dan said *"That's a great idea"* — but he has not said which documents belong to Fortress, SCIF or Churchill | Each partner adds items to the needs list the moment the capital source is set | The mechanism is built and live. The items are named **"Fortress · additional field 1"** and so on, and they say **assumed by us** on screen. Replace the labels the moment Dan answers |
| Q-030 | **Which items should be locked to the borrower.** A locked item cannot be satisfied by staff on the client's behalf. Nobody has said which ones deserve it | Whether staff can upload a document the client legally has to send themselves | The flag is built and set per item. Nothing is locked by default |
