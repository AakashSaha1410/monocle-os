# What we are building

**One document, the whole platform.** Everything discovery has settled, arranged
the way the build will actually run: the engines that everything else sits on,
then the loan's journey stage by stage, then what is still open.

**Why it exists.** The process is agreed — the flowchart was signed off on
17 September. What has not been written down in one place is *what the platform
does at each stage*: who acts, what they fill in, what it generates, who it goes
to, what it syncs with, and what it refuses to let happen. That is what this is.

**How the build runs.** The spine is linear — the loan's own journey, start to
finish — because reporting cannot be right until the process feeding it is right.
But the spine cannot start until the foundations underneath it exist. Part 1 is
those foundations. Part 2 is the spine.

**Status of every line.** Settled unless marked. Where something is still open it
carries a **▢ Open** marker and appears again in Part 4.

---

# Part 1 · The foundations

Seven engines. Every stage in Part 2 is a composition of these — which is the
point: build them once, properly, and each stage becomes configuration and
screens rather than new machinery.

---

## 1 · The record and the stage engine

**What it is.** The loan, and the rules about where it can go next.

The loan record has **eleven tabs**: `Workflow` · `Sponsor` · `Project` · `Loan` ·
`Transaction` · `Contacts` · `UW Material` · `Communications` · `Reporting` ·
`Pulse` · `Closing`. Workflow is leftmost and is new — a per-loan task list
showing what is done, what is next and who owns it. Closing is new and holds the
loan-document field set.

Every field belongs to exactly one tab and carries the stage at which it appears.
A tab shows only the fields whose stage the loan has reached, filtered by the
viewer's role. **Everything edits in a popup** — a tab is grouped, compact and
mostly read-only; clicking a group opens a centred window.

**Stages and statuses are data, not code.** They live in three tables — stages,
statuses, and the transitions between them — so the chain can be corrected
without a release, and so a later phase can hand Spreo the editor.

**Six stages, plus On-Hold:**

| Stage | Owner | Statuses |
|---|---|---|
| Pre-Approval | Credit | Credit Review → Pre-Approval Requested → Pre-Approved → LOI Out → LOI Signed. Or **Not Pre-Approved**, which ends it |
| Pre-Processing | Client Management | Pre-Processing |
| Processing | Client Management | Processing |
| Internal Review | Management / Internal UW | In Review → Items Requested → Approved |
| Investor Review | Client Management, recorded for the investor | In Review → Items Requested → Approved · Conditionally Approved · Feedback Requested |
| Approved / Closing | Closing | Approved → Docs Out → Docs Signed → Cleared to Close → Funded → Post Funding → Closed |
| **On-Hold** | anyone can set; only Credit or Management can release | Sits alongside, rightmost on the pipeline |

**Every transition is stamped** — what it was, when, who did it, what caused it.
Each leg of a back-and-forth is its own row, so a loop that goes out and comes
back three times leaves six timestamps, not two. **Days in status** is computed
from the latest stamp and is the only timing signal in the platform.

**The engine refuses illegal moves.** A transition carries its conditions; an
attempt that fails is refused and names exactly what is unmet. The Processing
gate is the one that matters most — see Stage 2.

**▢ Open — what a substage means.** Dan's workflow sheet lists a substage against
each task, and it is ambiguous whether that is the state *before* the task or
*after* it. This decides what the pipeline shows at every step.

**▢ Open — the stage list.** Dan's UI note keeps the six above. Jon's workbook
proposes replacing the last three with **Underwriting** (Internal Underwrite ·
Setpoint Review · Investor UW Review) and **Funding** (Approved · Docs Out · Docs
Signed · Cleared to Close · Funded · Post Funding · Closed). The substages are
better; the stage names are Dan's call. Written above as Dan's six with Jon's
substages underneath, which is the likely landing.

---

## 2 · Identity, roles and the permission matrix

**What it is.** Who can see what, and who can do what — enforced by the server,
not by hiding a button.

**Sign-in** is Microsoft 365 single sign-on with MFA. The team already lives in
Outlook; there is no second password to forget.

**Roles.** Seven were specified. Discovery has raised that to roughly eleven:

| Role | Owns |
|---|---|
| Loan Officer | Creating the record; the deal email; approving the final structure |
| Credit | All of Pre-Approval. Permutations, Needs List, LOI package, vendor orders. The only role that can remove a Needs List item, for the life of the loan |
| **Internal Pre-Approval Reviewer** | Approves or declines the internal pre-approval |
| Client Management | Pre-Processing onward — the emails, the chase, document review, clearing findings |
| **Client Management Team Lead** | Assigns the client manager |
| **Construction Management** | Approves budget and appraisal alongside Credit |
| **Appraisal Manager** | The appraisal process |
| Third-Party Review | The external document layer — Setpoint or offshore |
| Internal Underwrite | Exception-based review. Raises findings, approves or sends back |
| **Management** | Sets the Internal Review outcome; releases a loan from hold; changes Capital Source |
| Closing | The loan-document field set, generation, and everything after funding |
| Admin | Everything, plus the No Fly lists |

**A person can hold more than one role.** The matrix is one table, read on every
write. Four rules are enforced and not merely displayed:

1. Only Credit removes a Needs List item. A client manager asks Credit by email — there is deliberately no button.
2. Nothing approves in review while a finding is open.
3. The Processing gate.
4. No Fly blocks LOI generation until a recorded override.

**Named field-level rules** from Dan:

- The Loan tab: **only Credit can update**.
- **Buy Rate**: only Credit can see it. Nobody else, including Management.
- The pre-approval loan structure and the Pre-Approval notes — project scope and sponsor overview — are Credit's alone to enter.
- **Capital Source** can only be changed by Credit or Management.
- Anyone can put a loan on hold; only Credit or Management can take it off.

**▢ Open — the field-by-field matrix.** Jon's workbook has a column for view
access and a column for update access on all 139 confirmed fields. Both are
empty. Until they are filled, roles are applied at group level rather than field
level.

**▢ Open — Client Management is missing from the roles list** Dan is meant to
complete, while being the owner of 59 tasks in the same workbook.

---

## 3 · The Needs List engine

**What it is.** The one genuinely dynamic thing in the platform. Credit saves the
loan's permutations; the platform produces the list of documents this particular
loan requires. Dan's reason, 31 July: *"I rely on my team having to remember to
ask. And guess what? They forget. Always."*

**Three inputs:**

1. **The permutations** — the loan's own characteristics.
2. **The catalogue** — every document Spreo can ask for, each carrying its group, whether it is per-guarantor, whether the borrower ever sees it, how it travels to third-party review, and how long a prior copy stays good.
3. **The rules** — when a loan looks like this, add that item.

**The permutations, as they now stand:**

| | Values | Add-ons |
|---|---|---|
| Channel | Direct · Broker | Repeat Broker |
| Transaction | Purchase · Cash-out Refi · No-cash-out Refi | Portfolio Refinance · Mid Construction |
| Property type | SFR · 2-4 Unit · MFR · Condo · Townhouse | Lot Split · Condo Map · ADUs · Adding SF |
| Loan type | Bridge · Light Reno · Heavy Reno · GUC · DSCR | Weather Tight |
| Guarantors | One · more than one | Repeat Guarantor · Guarantor Exposure |
| Capital source | Fortress · SCIF · Churchill · others | Global Required |

**The standard list, on every loan** — per guarantor: driver's licence,
application, authorization, two months of personal bank statements, schedule of
real estate. Per entity: two months of entity bank statements, the operating
agreement. Plus signed federal disclosures, and the track record.

**What each branch adds:**

| If | Add |
|---|---|
| Purchase | PSA · escrow contact information |
| Refinance | VOM · Payoff · latest mortgage statement |
| Mid-construction refinance | Last inspection report from the previous lender · spend-to-date |
| Broker | Broker agreement — plus eight captured fields: name, company, email, phone, licence type, licence number, origination fee %, processing fee $ |
| More than one guarantor | For each additional: signed authorization, driver's licence, completed application, schedule of real estate |
| Adding square footage | Plans |
| Light Reno · Heavy Reno · GUC | Draft budget · budget review (Scrub or Feasibility) · construction inspection |
| DSCR | Subject property leases · 24 months of investment experience including leases |
| RTL (Bridge, Light, Heavy, GUC) | Stabilized or sold properties within the past 36 months |
| Global Required | Personal tax returns · investment statements |
| Capital source | That partner's own additional items |

**Internal items are on the list but never shown to the borrower** — credit
report, background check, PACER, UCC search, sponsor search, org chart, VOM and
payoff. Spreo pulls these itself.

**Regeneration is safe.** Change a permutation and the list rebuilds: new items
appear, items no longer applicable retire *only if untouched*, and anything
already submitted never disappears. Items a person added by hand never retire.

**Prior evidence carries over.** A guarantor is matched across loans by email; a
match offers what Spreo already holds, and taking it satisfies the *submission*
only — the file still runs the whole review path.

**▢ Open — the full permutation matrix.** The Dynamic Fields tab from 17
September is the first draft of the conditional logic and covers real ground —
ARV only on construction and renovation, AIV only on refinance, the legal block
only in attorney states, weather-tight only when mid-construction. It is not
complete, and it mixes field visibility with needs-list rules. Finishing it is
the single largest remaining input.

---

## 4 · The document engine

**What it is.** The spine of the borrower experience, and Dan's own number-one:
*"Number one actually, it's doc management."*

**A socket per item.** Each Needs List row is a socket. A socket can hold several
files — three months of bank statements are three files in one socket. Per
guarantor where the item is per-guarantor.

**Submission.** A file arrives and the item moves to Received automatically —
*"the second it goes in, it auto moves to received."* No second toggle. A file
can **append** to what is there or **replace** it; replacing keeps the original as
a superseded version. **Nothing is ever deleted.**

Files arrive four ways: the borrower's portal, staff uploading on their behalf
(recorded as acting-for), a reply to an email with attachments that staff file,
or carried over from a prior loan.

**Review layers.** Every decision carries a note — even an approval. Jonathan:
*"even if it's approved, there could be notes that are important."*

1. **Spreo review** — the client manager. Approve · Reject · Need Additional.
2. **▢ Second internal review** — new, from Jon's workflow sheet. A second pass before the file leaves Spreo.
3. **Third-party review** — Setpoint or the offshore team. Same three outcomes.

An item leaves the client manager's attention only when **third-party** review
clears it, not when Spreo approves — so somebody can chase what is stuck.

**Routing.** An item goes to third-party review either the moment Spreo approves
it, or it waits for its whole **package** — the sponsor package, for instance — and
travels with it. Set per item.

**Where a resubmission returns to depends on who asked.** If Spreo or third-party
review asked, the new file runs the gates again. If the **underwriter** asked, it
goes straight back to the underwriter and skips them, because by then the loan is
in a sprint.

**Follow-up questions attach under their parent item**, never as new top-level
rows, and appear on the borrower's list in plain words.

**Storage.** Files live in object storage with versioning, private, encrypted,
reached by signed links that expire. The database holds keys, versions and
checksums — never the bytes. Legal hold and retention are carried per file.

---

## 5 · The communications engine

**What it is.** Every email the platform sends, and every reply a person records.

**The platform sends; it does not read.** Replies arrive in Outlook and a person
records the outcome on the send. That recorded outcome is what moves the loan.

**Sent as the person** through Microsoft 365, so the message lands in their Sent
items and threads normally.

**Every subject carries the property address. Every footer carries the loan
number.** Dan asked for this as groundwork: *"we know all these emails have this
tagging in there. So then eventually the AI can organize all that."*

**Recipients are resolved at send time** from the loan's own guarantors, contacts
and staff — never typed. What cannot be resolved is reported in the compose form
rather than silently dropped.

**Two body modes.** Most templates render a full editable body. Two — the internal
and investor pre-approval requests — open with a merged subject and an **empty
body the sender types**, because the content varies too much to template.

**Templates are versioned**, and a sent email points at the exact version it used,
so any message can be explained later.

**Decision buttons inside the email.** Where a send asks for a decision, the
recipient clicks rather than types, and the click is recorded. Dan's test:
*"when I get an internal approval and I'm away from my computer and I'm on a
flight, will that come to my standard email as well?"* It does.

**The recurring Needs List email.** Everything still outstanding in one message —
documents, the unpaid appraisal invoice, the unscheduled inspection, what a
vendor still needs. Cadence per loan: daily at a set time, every workday, or
chosen days and times each week. Mon/Wed/Fri 8am by default. Client-facing
wording is **Outstanding** and **Under Review**; Dan rejected "Received":
*"why are you sending them a list if you're saying it's already been received?"*

**Six trigger emails** chase the two vendors — the conditions live on the template,
not in a rules engine. *"They're just triggers. They're not an SLA."*

**Every send is durable.** It becomes a queued job with an idempotency key before
it is attempted, so a retry can never send the LOI twice.

---

## 6 · The reporting engine

**What it is.** Pulse and the five reports — a rendering of what the process
produced, served from a read-only copy so reporting can never slow or corrupt the
work.

**Pulse** is the pipeline Dan runs the business from. Queue and Board views.
Phase-aware columns taken from his own sheet. Days in status. Columns chosen,
reordered, pinned and sorted, saved per person and shareable. Totals. Export to
PDF and Excel. Read-only — each value names the tab where it is actually edited.

**Calculated, with their working shown:**

- **Calculated submission date** — the later of the appraisal and budget delivery dates
- **Calculated funding date** — that, plus four business days
- **Days in status** · **Initial Turn Time in business days** · **X of Y documents**

They sit beside the typed targets so the gap is visible and someone can ask why.

**The five reports:** Outstanding Item by Loan · Appraisal Status · Budget Status ·
IC / Loan Summary · the investor tape. Plus a portfolio view — volume, ageing,
and where the book is bottlenecked.

**▢ Open — the IC / Loan Summary format.** Outstanding since 31 July. The report
renders our best reading until it arrives.

---

## 7 · The audit trail

**What it is.** An append-only record of everything that happened: who, when, to
what, before and after, and the request that caused it.

Never updated, never deleted. It answers *"why did it take five days?"* —
*"it only took me a day, it took you four."*

It is also what a capital partner can be shown. Every decision, document, email
and status change is attributed and timestamped.

---

## 8 · The integration boundary — what syncs where

The one thing discovery has never written down in one place.

| System | Direction | What moves | How |
|---|---|---|---|
| **Microsoft 365 / Outlook** | out, and back by hand | Every email sends as the person and lands in their Sent items. Replies arrive in Outlook; a person records the outcome | SSO and send-as. **The platform never reads the mailbox** |
| **DocuSign** | both | LOI, authorizations, application, disclosures out; signed status and date back, per guarantor | Envelopes out, webhooks back |
| **Lightning Docs** | out, then back | The closing field set goes; the generated documents return | Merge, view, tweak, send. Some fields cannot be set through it and are patched afterwards |
| **AMC / appraiser** | out by email, back by hand | Order and trigger emails out; invoice, inspection dates and the report come back and are typed in | **No API.** Where an AMC has its own portal, staff update status manually |
| **Budget vendor** | out by email, back by hand | Scrub or Feasibility order; the review returns and is uploaded | Email |
| **Setpoint / offshore** | out, findings back by hand | The package is delivered to their folder structure; decisions are recorded per document | Routing recorded; **transfer is manual** |
| **Capital partners** | out by email, back by hand | Pre-approval and final approval requests, the package, the investor tape; replies recorded on their behalf | They never log in |
| **Title · Escrow · Legal · Flood** | out by email, back by hand | Kick-offs and orders; the updated closing statement returns from Title; loan documents go to Escrow | Email |
| **LendingWise** | in once, then out | Open loans migrate in at cutover. **Post-closing documents continue to be saved there** | Export and map |
| **Borrower portal** | both | The Needs List out; uploads in | A personal link per guarantor, no password, expiring and revocable |
| **Loan servicer** | out | The servicing tape, after funding | Generated file |
| **▢ Trustpoint AI** | unknown | A "Trustpoint AI instance" is set up by Credit at LOI Signed | **Unknown. This has never been mentioned before** |

**Not connected in Phase 1:** embedded credit or background pulls · any AMC API ·
direct push to Setpoint or Churchill's Streamline · text messaging · an inbox
inside the platform · reading replies.

---

# Part 2 · The journey, stage by stage

The spine of the build. Each stage below answers the same eight questions: who
owns it, what happens, what is captured, what is generated, what is sent, what
syncs outside, what the platform refuses, and what is still open.

---

## Stage 0 · Before the platform

**Owner:** Loan Officer.

The LO emails Credit at `submissions@` with the loan structure, a basic write-up
and a valuation. **This happens in Outlook and the platform does not capture it.**
Deliberate, and confirmed by Dan on 9 August.

---

## Stage 1 · Pre-Approval

**Owner:** Credit, completely. Dan: *"Literally in pre-approval, there's nothing
client management will do. The only thing somebody outside of credit will do,
it'll be the salesperson emailing information."*

**Statuses:** Credit Review → Pre-Approval Requested → Pre-Approved → LOI Out →
LOI Signed. Or **Not Pre-Approved**, which ends it.

### What happens

1. **The LO creates the record** — five fields and nothing else.
2. **Credit refines structure, value and write-up** — offline, outside the platform.
3. **Credit sets the Capital Source.** It has to be known before the investor can be addressed.
4. **Credit sends the Internal Pre-Approval Request** — merged subject, typed body, attachments, configured recipients. Multiple recipients can be entered.
5. **The Internal Pre-Approval Reviewer decides**, by button in the email or by reply. Credit records it.
6. **Credit sends the Investor Pre-Approval Request** to the capital partner. Same shape.
7. **The reply is recorded** — Pre-Approved, or Not Pre-Approved and the loan ends.
8. **Credit sends Loan Pre-Approved to the LO** with the approved structure and terms.
9. **Credit enters the loan's data** — sponsor, guarantors, project, terms, permutations. Roughly forty fields. **The No Fly check runs as each guarantor name is entered.**
10. **Saving the permutations builds the Needs List.** Credit verifies it, adds one-off items, removes items with a reason.
11. **Credit generates the LOI package.**
12. **One Send** — the LOI goes out, and the appraisal is ordered from the chosen AMC, in one action.
13. **Credit orders the Construction Review** if the loan is Light Reno, Heavy Reno, GUC or a mid-construction refinance.
14. **Credit sets up the Trustpoint AI instance** if applicable. ▢ Open — what this is.
15. **The signed LOI is recorded** — by DocuSign, or marked by hand with who signed and when.
16. **Credit sends the Hand-off** to Client Management, carrying the appraisal invoice.

### What is captured

**Sponsor** — number of guarantors; per guarantor: first and last name, email,
phone, repeat flag, ownership %, estimated experience tier, minimum FICO, SSN,
driver's licence or passport, No Fly match result. Borrowing entity.

**Project** — transaction type, loan type, property type, street, city, state,
zip, purchase price and date, estimated AIV and ARV. **Initial GLA, Initial SF,
LOI Budget, LOI $/SF** — each paired with a Final counterpart captured later.

**Loan** — initial loan amount, holdback, interest reserve, coupon, term,
extensions and fee, processing fee, draw fee, recourse type, capital source,
**Buy Rate** (Credit-only).

**Transaction** — pre-approval request and approval date/times, LOI issue
date/time, LOI delivery method, LOI expiration, LOI estimated funding date, LOI
signed date and signer, LOI notes (merged into the letter), appraisal ordered
flag and date/time, AMC, appraisal turn-around days, appraisal invoice date/time,
budget vendor order date/time, **LO Subname**, LO assignment.

**LO Subname** is new: ADU Express, Platform, Internal Lead, Sourced — and the
list can be extended.

### What is generated

**The LOI package** — one PDF, four parts: the LOI with the notes box merged in;
the liquidity requirement; the transaction authorization, branched purchase or
refinance; and the loan checklist derived from the Needs List. Guarantors 2 and
beyond get a separate, shorter authorization — identity and credit only, no
payoff, VOM or escrow language, printed as their own pages.

Every generated document keeps a snapshot of the exact values it was merged from.

### What is sent

Internal Pre-Approval Request · Investor Pre-Approval Request · Loan Pre-Approved
to the LO · LOI Issue to the LO · the LOI to Guarantor 1 with the broker and LO
copied · Appraisal Order to the AMC · Construction Order to the budget vendor
with the LO **bcc** — the only bcc in the platform · the appraisal invoice link to
the CM and LO, not to the client · Hand-off to Client Management.

### What syncs outside

DocuSign for the LOI and authorizations. Email to the AMC and the budget vendor.
Outlook for every reply. Trustpoint AI, ▢ unknown.

### What the platform refuses

- **Generating the LOI while a No Fly match is unresolved.** A match raises a banner, pops on opening the record and must be acknowledged. Only Management can override, with a recorded reason, and the name stays on the list.
- **Generating the LOI with required fields empty** — it names the missing ones.
- **Anyone but Credit editing the Loan tab, the pre-approval structure or the Pre-Approval notes.**
- **Anyone but Credit or Management changing Capital Source.**

### ▢ Still open

- Guarantor names are not captured until after both approvals, so the No Fly check runs late. Should the LO capture names at creation?
- Whether each guarantor signs one authorization or two.
- Whether a declined loan can re-enter with a different capital partner.
- What the Trustpoint AI instance is.

---

## Stage 2 · Pre-Processing

**Owner:** Client Management. This is the first time the client hears from Spreo
about documents.

### What happens

1. **Credit sends the Pre-Processing email to the Client Management Team Lead**, carrying the appraisal invoice. This is internal.
2. **The CM Team Lead assigns a client manager.**
3. **The CM sends the appraisal invoice to the client.**
4. **The CM orders Title, Escrow and — in attorney states only — Legal.**
5. **The CM requests the VOM and the Payoff** from the current lender, on refinances.
6. **The CM orders the credit reports, background reports and UCC searches.** As each signed authorization returns, these run; anything they turn up becomes a follow-up question under that guarantor, before the client sees the list.
7. **The CM tailors the Needs List** — carrying across anything Spreo already holds from a prior loan, adding items and follow-ups. The CM cannot remove an item.
8. **The CM sends the Kick-off Email.** The tailored list travels *in the email* plus a personal portal link per guarantor. **This is the moment the client's view switches on.**
9. **The CM sends the Application to every guarantor and the Disclosures to Guarantor 1**, by DocuSign.
10. **The initial track record property list arrives** — track record moves to Initial.
11. **The recurring Needs List email starts.**

### What is captured

Assigned CM · middle FICO per guarantor · **actual FICO** · 30-day and 60-day
mortgage lates over 24 months · bankruptcy and foreclosure in the last 60 months
· felony or financial crime conviction · whether the guarantor is a licensed
general contractor · **Guarantor Exposure** where repeat.

Per guarantor, with dates: authorization — Need · Sent · Signed; application —
Need · Sent · Signed; disclosures — Guarantor 1 only.

Contacts: title company and agents, escrow company and agents, insurance, law
firm and lawyers, appraiser, appraisal company, budget vendor.

Facts: VOM status, Payoff status, escrow contact provided, track record status,
kick-off email date/time, kick-off call date/time, target submission date, target
funding date, LOI funding date, **Initial Target Funding Date**, PSA closing date.

### What is generated

The tailored Needs List, as it appears in the Kick-off Email and on each
guarantor's portal. Personal portal links, one per guarantor — no password,
expiring, revocable.

### What is sent

Pre-Processing (internal) · appraisal invoice to the client · Title Kick-off ·
Escrow Kick-off · Legal Kick-off in the nineteen attorney states with language
varying by state · VOM Request · Payoff Request · Application · Disclosures ·
Kick-off Email · and the recurring Needs List from here on.

### What syncs outside

DocuSign for application and disclosures. Email to title, escrow, counsel and the
current lender. The portal opens to guarantors.

### The gate into Processing

Four conditions, all objective, **enforced by the platform**:

1. The appraisal is **paid**
2. Escrow contact provided — **purchase only**
3. **Every** guarantor authorization signed and received
4. Track record at **Initial**

An attempt to advance is refused and names what is unmet. Management can
override, and the override is recorded. Dan's reason: *"you're in pre-processing.
You've been in pre-processing for 14 days. The onus is on you."*

### ▢ Still open

- Whether Order Flood still exists — it is absent from both September workbooks.
- Whether the appraisal invoice reaching the client twice — once inside the Pre-Processing email, once as its own send — is intended.

---

## Stage 3 · Processing

**Owner:** Client Management, with Credit and Construction Management on the
approvals.

### What happens

1. **Documents arrive and are reviewed** through the layers in Part 1 §4.
2. **The appraisal runs its course** — invoice paid, inspection scheduled and occurred, the appraiser's needs provided, the report received, reviewed, and approved or challenged.
3. **The budget review runs alongside** — its own inspection, its own delivery, internally approved, then sent to the appraiser.
4. **The track record is built out** and verified, internally and by the third party.
5. **Additional guarantors can be added** at any point; each gets only their own documents.
6. **Credit finalises the loan structure** once the appraisal, the budget and the track record are complete and FICO is known.
7. **The CM requests the LO's approval of the final structure**, then the client's.
8. **The CM submits to Setpoint** if the capital source is Fortress or SCIF.
9. **The CM submits for Internal Final Review.**

### What is captured

**Appraisal** — status through its eight values (Requested · Invoice Sent · Paid ·
Received · Under Review · Challenged · Approved Pending Budget · Final), invoice
paid date, inspection scheduled and occurred, appraiser needs and when provided,
promised and **target delivery dates**, received date, initial and final approval
dates, **appraiser name**, **CDA needed**, **secondary appraisal needed and its
appraiser**, **turn time**.

**Budget** — Scrub or Feasibility, **firm name**, vendor needs, inspection dates,
promised and target delivery, received, internally approved, sent to appraiser,
client sign-off.

**Project, final side** — appraised AIV and ARV, final total budget, **Final GLA,
Final SF, Final Budget, Final $/SF**.

**Loan, final side** — initial loan amount, holdback and interest reserve, final.

Inspection is deliberately **not** a status — it is separate facts, so a visit
happening early or late does not rewind the order.

### What is generated

The Loan Summary — the IC summary. The investor tape. The track record report.

### What is sent

Internal Loan Structure Approval Request to the LO · External Loan Structure
Approval Request to the client and broker · Budget to Appraiser · Budget to
Client · Setpoint Request · Internal Final Approval · the six vendor triggers ·
the recurring Needs List · and one-offs: Request Letter of Explanation, and the
request to Title for an updated estimated closing statement.

### What syncs outside

The appraisal and budget vendors by email. Setpoint by their folder structure,
recorded but not transmitted. Title for the closing statement.

### What the platform refuses

Anyone but Credit removing a Needs List item. Advancing while a required review
layer is outstanding.

---

## Stage 4 · Internal Review

**Owner:** Management and Internal Underwrite — the named individuals in Management.

**Statuses:** In Review → Items Requested → Approved. Repeatable.

**How it works.** The reviewer receives a templated email with the loan summary,
the files and the third-party findings — the dry run for the investor package.
They review **by exception**, not by re-approval: *"Do it more on an exception
basis instead of an approval basis."*

Findings are a plain numbered list in their own words — not marks against
individual documents. **Nothing approves while a finding is open**, and clearing
one requires a note saying how.

Sending back moves the loan to Items Requested and emails the numbered findings
to the client manager and the working group. **Findings never go to the client.**

**Each leg is timed separately** — in, out, back in, out, approved.

---

## Stage 5 · Investor Review

**Owner:** Client Management, or Management, depending on the partner.

**Statuses:** In Review → Items Requested → Approved · Conditionally Approved ·
Feedback Requested. Repeatable.

**The investor never logs in.** Spreo sends the package by email and records what
comes back on the investor's behalf.

**Who sends is set per capital partner.** Today: Client Management requests from
Churchill and SCIF; a principal request from Fortress. The platform holds
this as configuration, not as a rule in code.

On approval the CM sends **Approved Terms** to the LO and to Closing.

---

## Stage 6 · Approved, Closing and Funding

**Owner:** Closing.

**Statuses:** Approved → Docs Out → Docs Signed → Cleared to Close → Funded →
Post Funding → Closed.

### What happens

1. **Closing fills the remaining closing fields.**
2. **The field set is merged, viewed and tweaked**, then loan documents generate through Lightning Docs. Some fields cannot be set through it and are patched afterwards.
3. **Final documents are QC'd before sending.**
4. **Loan documents go to Escrow**, and to the borrower.
5. **The signed PDF comes back and is uploaded**, then reviewed for missing signatures and initials.
6. **Outstanding funding conditions are circulated to title and escrow.**
7. **Eight standard closing items are requested and tracked** from title and escrow — the same machinery as the Needs List, pointed at a different counterparty:
   - fully executed settlement statement
   - confirmation of first lien position
   - title and escrow signed lender instructions
   - escrow signed lender confirmation
   - receipt of the recording package
   - ALTA 32.2 / 33 mechanics lien coverage package
   - supplement to the title commitment
   - closing protection letter
8. **Title company wire instructions are verified verbally**, then confirmed to the internal underwriter by email.
9. **The funding wire is balanced with escrow.**
10. **The clear-to-close email goes to the internal underwriter**, and the wire is coordinated with his final approval.
11. **After funding**, title confirms receipt of the wire.
12. **Post funding** — the release of mortgage or assignment for recording arrives, and the final settlement statement from escrow.
13. **Post-closing documents are saved in LendingWise.**

### What is captured

The Lightning Docs field set: funding entity, borrower notice address,
signatories and titles, guaranty type, guarantor marital status and notice
addresses, lien position, broker licence and address, loan servicer, property
APN, release pricing, governing law state and county, loan number, default
interest rate, I/O and amortization term, MERS ID, construction reserve type,
Dutch or non-Dutch interest, prepayment premium, escrows, title report number and
effective date, exceptions to be removed from title, appraisal fee shown as POC,
signature affidavit and AKA details.

Then: date sent to Lightning Docs, each closing milestone as a timestamp, **wire
reference**, **funding date**, and the eight title/escrow items as a tracked
checklist.

### What is generated

The loan documents, through Lightning Docs. The **servicing tape**, which cannot
be generated before the loan is Funded.

### What the platform refuses

Generating loan documents before the capital partner has approved, or while
required closing fields are empty — it names them.

### ▢ Still open

Whether the borrower receives loan documents from the platform, or only from
escrow.

---

## Across every stage · On-Hold

A loan can be put on hold from any stage. **Anyone can set it**; only Credit or
Management can release it. The loan keeps its stage and status underneath, and
On-Hold sits rightmost on the pipeline.

---

# Part 3 · What changed, and what it means for the build

The specification this platform was scoped against was written on 15 August.
Discovery has continued since, and four things have arrived: Dan's permutations
and communications note (15 September), his sign-off and UI notes, his workflow
workbook, and Jon's field register (17 September).

Most of it confirms what was already specified. Some of it adds. This section
separates the two, because the difference matters to anyone planning the work.

## 3.1 · What was confirmed

The spine held. Six stages, the pre-approval chain, the permutations driving the
Needs List, the LOI package as one document, the four-condition gate, three
review layers, exception-based internal review, the investor never logging in,
Lightning Docs for loan documents, days-in-status as the only timing signal, and
every rule the platform enforces rather than displays — all confirmed, none
reversed.

**The flowchart was signed off outright.** That is the single most useful thing
to have happened: the process is agreed, and what remains is detail.

## 3.2 · What is genuinely new

| | What it adds |
|---|---|
| **The closing and funding process** | Five specified items become roughly twenty-five. Eight title and escrow items tracked as a checklist, verbal wire verification, a named approver on the wire, and three post-funding steps. This is the largest single addition |
| **Post-funding and Closed as states** | The specification stopped at Funded. The process continues: release of mortgage for recording, the final settlement statement, and post-closing documents saved back to LendingWise |
| **On-Hold** | A state that sits across every stage, with its own permission rule |
| **The Workflow tab** | A per-loan task list, leftmost. A new surface, not a variation of an existing one |
| **The Closing tab** | Holds the loan-document field set |
| **Four more roles** | CM Team Lead, Construction Management, Appraisal Manager, Internal Pre-Approval Reviewer — plus Management as a distinct role |
| **A second internal review layer** | Three layers become four |
| **The sponsor credit-risk block** | SSN, identity document, mortgage lates, bankruptcy, foreclosure, felony conviction, actual FICO, licensed GC. The most sensitive data in the platform, and new |
| **CDA and secondary appraisal** | A second valuation path with its own appraiser |
| **New fields on existing surfaces** | LO Subname · Buy Rate with its own visibility rule · Guarantor Exposure · Initial Target Funding Date · Initial Turn Time · appraisal turn time · the document counter · four initial-versus-final Project pairs |
| **Trustpoint AI** | A third party at LOI Signed that has never been described |

## 3.3 · The one open scope question

Jon's field register carries 407 fields. **139 are confirmed** and are
substantially the specified field set. **268 are unmarked**, awaiting Dan, and
they are overwhelmingly two things that have been out of scope from the
beginning:

- **The structuring and sizing model** — the interest reserve sizer at twelve,
  fifteen and eighteen months; loan-to-cost on every line; cost-to-close; sources
  and uses; profit, margin and return on equity; and every one of those repeated
  for an extensions case and two stress-test cases. Roughly 180 fields.
- **The intake questionnaire** — per-unit beds, baths, square footage, rent and
  tenant status, as purchased and as built; ADUs and cabanas; the narrative
  questions about permitting, exit and prior lenders. Roughly 55 fields.
- **The DSCR rental cash-flow model** — rents through vacancy, management, taxes,
  insurance, reserves to net operating income and debt yield. Roughly 15 fields.
- **The track record breakdown** — dollars and counts by asset type across two
  time windows. 24 fields.

Structuring has been outside the scope since the first session. Jon's own July
workbook records it: *"this will not be managed in phase 1 via the system since
the process begins at LOI creation."* Dan described Credit refining structure
offline on 31 July, and the platform was specified to begin where that ends.

**The distinction that settles it** is not which fields, but what the platform
does with them:

| | What it means | Weight |
|---|---|---|
| **Capture** | Store it, show it, report on it. Never compute it | Light. Most of the questionnaire belongs here |
| **Compute** | The platform runs the sizer, the stress tests, the cash-flow model, and the numbers are live | Heavy. This is a new capability, not more fields |
| **Later** | Stays in the existing spreadsheet for now | None |

A field Dan wants to *see* is a different proposition from a field he wants the
platform to *calculate*. Sorted that way, most of the 268 are probably cheap and
a minority are genuinely a new piece of the product.

## 3.4 · What this does to the build order

The dependency order does not change — it gets one addition and one correction.

**Unchanged.** Nothing before the permission matrix, because every surface
inherits it. The LOI needs the Needs List, because the checklist derives from it.
Communications needs the templates before the automation. Reporting needs
everything, because it renders what the process produced.

**The addition.** The closing checklist is the Needs List engine pointed at title
and escrow rather than at the borrower — same sockets, same states, same chasing.
Building it that way costs a fraction of building it separately, but only if the
document engine is written to be reusable from the start. That is a decision to
make in week one, not week nine.

**The correction.** Closing was scheduled as a small piece of one workstream. At
roughly twenty-five items it is no longer small, and it needs its own slice with
Closing in the room, the same way Credit was in the room for pre-approval.

---

# Part 4 · Every open question

Consolidated from the flowchart, the September workbooks and the specification's
own register. Ordered by how much each one changes.

## Changes the shape of the build

| | Question | Why it matters |
|---|---|---|
| 1 | **The 268 fields — capture, compute, or later?** | Decides whether the platform gains a structuring and sizing engine |
| 2 | **The stage list** — Dan's six, or Jon's Underwriting and Funding? | Everything downstream renders from it |
| 3 | **What is Trustpoint AI?** | A third party at LOI Signed, possibly an integration, never described |
| 4 | **The full permutation matrix** | Sets the ceiling on the Needs List engine. Outstanding since 31 July; the Dynamic Fields tab is the first draft |

## Changes a diagram or a screen

| | Question | Where it lands |
|---|---|---|
| 5 | Does a substage mean the state before the task or after it? | What the pipeline shows at every step |
| 6 | Should the LO capture guarantor names at creation, so the No Fly check runs before the approvals? | Stage 1 |
| 7 | One authorization per guarantor, or two? | The LOI package |
| 8 | Can a declined loan re-enter with a different capital partner? | Stage 1 |
| 9 | Plans only when adding square footage, or also on Heavy Reno and GUC? | The Needs List |
| 10 | Does Order Flood still exist? Absent from both September workbooks | Stage 2 |
| 11 | Is the appraisal invoice meant to reach the client twice? | Stage 2 |
| 12 | Who orders the appraisal, and who orders the budget review — Credit or Client Management? | Stages 1 and 2 |
| 13 | Setpoint for Fortress only, or Fortress and SCIF? | Stage 3 |
| 14 | Does the borrower receive loan documents from the platform, or only from escrow? | Stage 6 |

## Settles a field or a name

| | Question |
|---|---|
| 15 | **Property type** — three lists are in play: SFR · 2-4 Unit · MFR; Dan's adds Condo and Townhouse; Jon's adds Duplex, Triplex and Fourplex and drops 2-4 Unit |
| 16 | **Light Reno / Heavy Reno**, or Light Rehab / Heavy Rehab? |
| 17 | Is DSCR a loan type, or does it also split transaction type three ways? |
| 18 | The **field-by-field view and update matrix** — 139 rows, both columns empty |
| 19 | The **roles list**, completed — and Client Management added back to it |
| 20 | The **IC / Loan Summary format** — outstanding since 31 July |
| 21 | **Which documents each capital partner requires** — the mechanism is built, the contents are not supplied |
| 22 | **Setpoint's delivery requirements** — folder structure, API or manual, and their review cadence |
| 23 | The **trigger email list** in Dan's own words — ours is assembled from what the sessions named |

---

# Part 5 · What the build needs, and from whom

| From | What | Blocks |
|---|---|---|
| **Dan** | The 268 fields sorted into capture / compute / later | The shape of the platform |
| **Dan** | The stage list confirmed | Stage engine, pipeline, every screen |
| **Dan** | The permutation matrix completed | The Needs List engine |
| **Dan** | What Trustpoint AI is | Stage 1, and the integration boundary |
| **Dan** | The roles list completed, and the view/update matrix filled | The permission matrix — and nothing starts before that |
| **Dan** | The IC / Loan Summary format | Internal and investor review |
| **Dan** | Which documents each capital partner requires | The partner requirement sets |
| **Dan** | The trigger email list | Communications automation |
| **Jon** | The recorded flowchart walkthrough | The correction pass |
| **Spreo** | LendingWise export | Migration |
| **Spreo** | Microsoft 365 administrative access | Sign-on and send-as |
| **Spreo** | Lightning Docs and DocuSign access | Loan documents and signature |
| **Setpoint** | Their delivery requirements | Third-party routing |

**The rule while any of these are open:** nothing blocks. The least-surprising
option gets built, marked visibly on screen as an assumption, and carried to the
next review. An assumption nobody can see is the one that survives into
production.
