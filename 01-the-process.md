# Spreo Capital — Phase 1, end to end

**What this is.** Everything we know about Phase 1, gathered in the order the work
actually happens. It pulls together Dan's process document, Jonathan's field
workbook, Dan's written answers of 9 August, and six recorded calls between 23
July and 9 August.

**What this is not.** A demo script, a sales document, or a technical spec. It is
the shared understanding — if something here is wrong, the build is wrong.

**How to read it.** Part 1 defines the words. Part 2 walks the process step by
step. Part 3 covers the borrower's side, which runs alongside. Part 4 sets out
the rules that apply everywhere. Part 5 lists what we assumed and what we still
need from Dan.

---

# Part 1 · Glossary

Terms used throughout, in the sense Spreo uses them.

## People and roles

| Term | What it means |
|---|---|
| **Loan Officer (LO)** | The salesperson. Brings the deal in, creates the loan record, stays copied on most correspondence. |
| **Credit** | The team that decides whether Spreo will lend and on what terms. Owns everything up to the signed LOI. |
| **Client Manager (CM)** | Owns the loan from the signed LOI onward. Chases documents, deals with the client, keeps the vendors moving. |
| **Internal Underwriter** | Reviews the whole file before it goes to the capital partner. |
| **Third-Party Review** | An outside firm that re-checks documents. Two are named: Setpoint, and an offshore team. |
| **Closing** | Produces the loan documents and handles funding. |
| **Sponsor** | The person or group behind the deal. In practice, the guarantors. |
| **Guarantor** | An individual who personally stands behind the loan. There can be several. Guarantor 1 is the primary. |
| **Borrowing Entity** | The company that actually borrows. Never an individual. |
| **Broker** | An intermediary who brought the deal instead of the client coming direct. |
| **Capital Partner / Investor** | Whoever funds the loan. Named ones are Fortress, SCIF and Churchill. |

## Stages

| Term | What it means |
|---|---|
| **Pre-Approval** | From the deal arriving to a signed letter of intent. Credit's territory. |
| **Pre-Processing** | Starts the moment the LOI is signed. The client is contacted for the first time. Client Management's territory. |
| **Processing** | Documents arrive and get checked. The loan only enters this stage when four specific conditions are met. |
| **Internal Review** | The whole file goes to the internal underwriter. |
| **Investor Review** | The same package goes to the capital partner. |
| **Approved / Closing** | Loan documents are produced, signed, and the loan funds. |

## Documents and paperwork

| Term | What it means |
|---|---|
| **LOI** | Letter of Intent. The terms Spreo is offering. Once signed, real work begins. |
| **LOI package** | One document containing four things: the LOI, the liquidity requirement, the transaction authorization, and the loan checklist. |
| **Liquidity requirement** | A statement of how much cash the guarantors must show. |
| **Transaction authorization** | The form a guarantor signs letting Spreo pull credit and background. On a refinance it also asks the current lender for a payoff and a VOM. |
| **Needs list** | The list of documents this particular loan requires. Built automatically from the loan's characteristics. |
| **Loan checklist** | The needs list, printed into the LOI package so the client sees up front what will be asked for. |
| **Track record** | Evidence of the sponsor's completed projects. Three states: No Initial, Initial, Complete. Building it is real work — see Stage 2. |
| **VOM** | Verification of Mortgage. A report card from the current lender on how the borrower paid. Not on any credit bureau — private lenders share it between themselves. |
| **Payoff** | A statement from the current lender of what is owed to clear the existing loan. |
| **Draw report** | On a part-finished construction project, the last inspection report from the previous lender. |
| **Servicing tape** | A spreadsheet handed to the loan servicer after funding. |
| **Investor tape** | A short spreadsheet row sent to the capital partner. Dan says seven columns. |

## Valuation and vendors

| Term | What it means |
|---|---|
| **Appraisal** | The independent valuation. |
| **AMC** | Appraisal Management Company. The firm the appraisal is ordered from. |
| **Budget analysis** | A review of the construction budget. Comes in two kinds. |
| **Scrub** | The lighter budget review. |
| **Feasibility** | The heavier budget review. |
| **Inspection** | A site visit. The appraiser's visit and the budget vendor's visit are separate events. |
| **AIV** | As-Is Value. What the property is worth today. |
| **ARV** | After Repair Value. What it should be worth once the work is done. |

## Loan characteristics

| Term | What it means |
|---|---|
| **Permutations** | The handful of choices that define a loan: direct or broker, purchase or refinance, property type, loan type, capital source. These drive the needs list. |
| **Transaction type** | Purchase, C/O (cash-out refinance), or NCO (no-cash-out refinance). |
| **Loan type** | Bridge, Heavy Reno, Light Reno, GUC (ground-up construction), or DSCR (a rental product). |
| **Portfolio Refinance** | A refinance of a loan Spreo already holds. Some documents are already on file. |
| **Global Required** | A flag meaning the borrower's total exposure is large enough that Spreo wants extra financial detail. |
| **Mid Construction** | The project is already part-built. Triggers a request for the previous lender's draw report. |
| **Repeat Borrower** | Spreo has lent to this guarantor before. |
| **UPB** | Unpaid Principal Balance. |
| **PSA** | Purchase and Sale Agreement. |

## Systems and outside parties

| Term | What it means |
|---|---|
| **LendingWise** | The current loan system. The one being replaced. Its main failing is that it shows everyone every field, so nobody fills anything in. |
| **Pulse** | The pipeline report Dan lives in. Currently exported from LendingWise into a spreadsheet. |
| **Lightning Docs** | The outside service that produces the actual loan documents. |
| **DocuSign** | Used for signatures. |
| **Setpoint** | A third-party review firm. How documents reach them is still unsettled. |
| **Streamline** | Churchill's own document system. |
| **Churchill (CHRE)** | A capital partner. Also supplies one of the two No Fly lists. |
| **No Fly List** | People Spreo will not lend to. Two separate lists: Churchill's and Spreo's own. |

## Working terms

| Term | What it means |
|---|---|
| **Days in status** | How long a loan has sat where it is. The only timing signal in Phase 1. |
| **Status email** | The recurring message to the client listing everything still outstanding. |
| **Trigger email** | An automatic message to a vendor when a condition is met. |
| **Kick-off email** | The message that releases the tailored needs list to the client. |
| **Internal / borrower-facing** | Whether a document appears on the client's list. Some things Spreo pulls itself and the client never sees. |
| **Socket** | The slot a document fills. One socket can hold several files — three months of bank statements are three files in one socket. |
| **Package** | A group of documents that only goes to third-party review once all of them are in. The alternative is routing each one the moment it is approved. |
| **Primary guarantor** | The one who signs the LOI and the disclosures. Dan: *"whoever gets the LOI… we'll define somebody as who's running point."* |

---

# Part 2 · The process, step by step

## Before anything: how a deal arrives

The loan officer emails the credit team at `submissions@` with the loan
structure, a basic write-up, and a valuation. **This happens in Outlook, outside
the system.** Dan was specific about it on 9 August. Nothing in the platform
captures this email.

## Stage 1 · Pre-Approval

Credit owns this stage completely. Dan: *"Literally in pre-approval, there's
nothing client management will do. The only thing somebody outside of credit will
do, it'll be the salesperson emailing information."*

The statuses in order:

```
Credit Review
  → Pre-Pre-Approval Requested
  → Internal Approved
  → Investor Approval Requested
  → Pre-Approved   (or Not Pre-Approved, which ends it)
  → LOI Issued
  → LOI Signed
```

---

### Step 1.1 · The loan officer creates the record

**Who:** Loan Officer.

**What happens:** The LO opens the system and creates a loan with five fields
and nothing else:

- Full address
- Purchase or Refi
- Portfolio Refi — yes or no
- Repeat Borrower — yes or no
- Approximate loan amount

**Why so few:** Because that is all the LO knows at this point. Everything else
is Credit's job later. There are no required fields beyond the address, and
nothing blocks the record being created.

**What the system does:** Creates the loan at status Credit Review, stamps the
time, and records who created it. It does **not** build a needs list yet —
there are no loan characteristics to build one from.

**Where it lives:** Loans → Add loan.

**Open point:** Jonathan described a second way in on 6 August — an email to a
dedicated address that creates the record automatically. Dan's written answer
describes manual creation only. Both are in the build; the email route is behind
a clearly-labelled demo control until Dan settles it.

---

### Step 1.2 · The No Fly check

**Who:** The system, automatically.

**What happens:** As guarantor names are entered they are checked against two
lists — Churchill's and Spreo's own. The lists are kept separate so that a sync
from Churchill only replaces Churchill's names.

Dan: *"we want to ping that list, because we don't want to waste time."*

**What the system does when there is a match:**

1. A red banner appears on the loan
2. A pop-up appears when anyone opens the record, and must be acknowledged
3. **Generating the LOI is blocked**

A manager or admin can override, but must give a reason, and the override is
recorded against the loan with their name and the time. The name is not removed
from the list.

**Where it lives:** No Fly List in the sidebar for the lists themselves; the
check runs on the Sponsor tab where names are typed.

**Open point:** Where Churchill's list actually lives and how it should reach us.
Today it is entered by hand or pasted in bulk. There is no live sync.

---

### Step 1.3 · Credit refines the deal — offline

Credit works out the structure, the value, and the write-up. **None of this
happens in the system.** It is deliberately outside Phase 1.

---

### Step 1.4 · The Pre-Pre-Approval request

**Who:** Credit.

**What happens:** Credit presses a button that opens an email form inside the
system. The subject is filled in automatically as `Pre-Pre-Approval Request:
[address]`. **Credit types the body themselves** and attaches whatever files are
needed. The recipients are pre-set.

**Why the body is typed rather than generated:** Dan asked for it this way. At
this point the content varies too much to template.

**What the system does:** Sends it, stamps it, and moves the loan to
**Pre-Pre-Approval Requested**.

**What happens next, outside the system:** Dan reads it in Outlook and replies.

**Recording the reply:** Someone opens the send in the system and records the
outcome. Approving moves the loan to **Internal Approved**.

**Important:** We are not reading anyone's mailbox. A person records what came
back. This is what makes the round trip measurable — Dan's point: *"why did it
take five days? Well, it only took me a day, it took you four."*

---

### Step 1.5 · The Pre-Approval request to the investor

**Who:** Credit.

Exactly the same shape as the previous step. Button, merged subject
(`Pre-Approval Request: [address]`), typed body, attachments, pre-set investor
recipients. Status moves to **Investor Approval Requested**.

The reply is recorded and moves the loan to either:

- **Pre-Approved** — carry on
- **Not Pre-Approved** — the loan stops. It does not proceed to an LOI.

**Where it lives:** Communications → Send, then Communications → Log to record
what came back.

---

### Step 1.6 · Credit enters the loan's characteristics

**Who:** Credit.

**What happens:** Credit fills in the five permutations and their add-on flags.

| # | Permutation | Choices | Add-on flags |
|---|---|---|---|
| 1 | Channel | Direct, Broker | Repeat Borrower, Repeat Broker, Global Required |
| 2 | Transaction | Purchase, C/O, NCO | Portfolio Refinance |
| 3 | Property type | SFR, 2-4 Unit, MFR | Lot Split, Condo Map, ADUs |
| 4 | Loan type | Bridge, Heavy Reno, Light Reno, GUC, DSCR | Mid Construction, Weather Tight |
| 5 | Capital source | Fortress, SCIF, Churchill, others | — |

**What the system does:** Saving these **builds the needs list**. This is the one
thing in Phase 1 that is genuinely automatic and rule-driven.

Dan's reason for wanting it: *"I rely on my team having to remember to ask. And
guess what? They forget. Always."*

**How it works today:** Four of the inputs drive rules — transaction type, loan
type, Mid Construction, and Global Required. For example:

- A refinance adds VOM, Payoff and the current mortgage statement
- A purchase adds the purchase agreement and asks for escrow contact details
- Construction and renovation loans add the draft budget and draft plans
- Mid Construction adds the previous lender's draw report
- Global Required adds personal tax returns and investment statements

**What is honestly incomplete:** Seven of the nine add-on flags do not yet change
anything — Repeat Borrower, Repeat Broker, Portfolio Refinance, Lot Split, Condo
Map, ADUs, Weather Tight. They are captured and stored, and the screen says
plainly that they drive nothing. Dan offered to supply the full matrix on 31
July and it has not arrived. This is the single biggest thing outstanding.

**Also entered at this stage:** everything the LOI needs — address detail,
guarantors, loan amount, rate, term, fees, recourse. Roughly forty fields across
the Sponsor, Project and Loan tabs.

---

### Step 1.7 · Credit checks the needs list

**Who:** Credit.

**What happens:** Credit reads the generated list and corrects it. They can:

- Add a one-off item this deal needs
- Mark an item as not needed, giving a reason

Dan: *"maybe they'll say like, oh, you know what, this is a one-off case. We
actually don't need this thing that we normally need."*

**What the system does:** A removed item is not deleted. It goes into a "not
needed" drawer with the reason and who did it, and can be put back.

**Nothing is visible to the client at this point.** Credit is setting the
prescription before the client hears anything.

---

### Step 1.8 · The LOI package

**Who:** Credit.

**What it contains** — one document, four parts:

1. **The LOI** — the terms, merged from the loan record
2. **The liquidity requirement** — how much cash the guarantors must show
3. **The transaction authorization** — and this branches:
   - On a **refinance**: it also authorises the current lender to release the
     payoff and the VOM
   - On a **purchase**: it asks for escrow contact details instead, and does not
     mention payoff
4. **The loan checklist** — the needs list, printed so the client knows what is
   coming

**Guarantors 2, 3, 4 and beyond** get a separate, shorter authorization —
identity and credit only. It does not ask for payoff, VOM or escrow. Dan:
*"Guarantor one signs the four-page packet. Everyone after gets a single
authorization so we can run credit and background."* These print as their own
pages, not buried inside the primary's packet.

**Before it can be generated**, two things must be true:

- No unresolved No Fly match
- The fields the LOI needs are filled in — the system names the missing ones

---

### Step 1.9 · Sending the LOI, and ordering the appraisal

**Who:** Credit.

This is deliberately one action rather than three. On the same screen Credit:

- Reviews the document checklist and **unticks anything not wanted** — those
  items become "not needed" for the client manager downstream
- Picks the **AMC** from a list
- Chooses DocuSign or attach-and-sign

Pressing send does two things at once: the LOI goes to guarantor 1 and the
broker with the LO copied, **and** the appraisal order goes to the chosen AMC
with the CM and LO copied.

Jonathan's reasoning: *"once they're ready to issue the LOI, that's what the
credit team needs to do."* There is no reason to make it three separate motions.

**What the system does:** Records the appraisal as ordered with a timestamp,
stamps the LOI issue date, and moves the loan to **LOI Issued**.

**When the signed LOI comes back**, someone records it and the loan moves to
**LOI Signed**. Dan expects this to be manual: *"my assumption is you have to
move it to LOI-signed manually."*

---

### Step 1.10 · Also in Pre-Approval: the invoice link

Once the AMC sends its invoice, Credit forwards the link to the Client Manager
and the LO using a template. **This is not sent to the client yet.**

Dan: *"No, not until the LOI is signed. And client management's going to send
the invoice link."*

---

## Stage 2 · Pre-Processing

Starts the moment the LOI is signed. The Client Manager takes over. This is the
first time the client hears from Spreo about documents.

**Status:** Pre-Processing (a single status — the detail lives in the facts
being tracked, not in sub-statuses).

---

### Step 2.1 · A client manager is assigned

**What happens:** A CM takes ownership of the loan.

**Open point:** Whether this is automatic (by LO, by broker, by rota) or always
done by hand is unanswered. Today it is manual, with the ability to reassign.

---

### Step 2.2 · The named emails go out

Nine templates, each with its own recipients and each stamped when sent.

| Email | Goes to | Copied |
|---|---|---|
| Pre-Processing | Client and broker | cc the LO |
| Order Budget Scrub or Feasibility | Budget vendor | **bcc** the LO |
| Appraisal Invoice to client | Client | cc the LO |
| Title kick-off | Title company | |
| Escrow kick-off | Escrow company | |
| Legal kick-off | Counsel — varies by state | |
| Order Flood | Flood vendor | |
| Disclosures | Guarantors, via DocuSign | |
| Application | Guarantors, via DocuSign | |

The first seven are Dan's written list. Disclosures and Application he added
verbally on 31 July.

**The bcc on the budget order is the only bcc in the system**, and it is
deliberate.

**Note on the Pre-Processing email:** it is not the kick-off email. Dan was firm
about this. The Pre-Processing email is generic and immediate — *"guys, in the
next 48 hours, we desperately need you to get everything to the budget vendor,
get the inspection, get the appraisal paid."* The kick-off email comes later and
is tailored.

**Open point:** Order Flood does not appear in any recorded conversation. We do
not know who it goes to or what comes back.

---

### Step 2.3 · The client manager tailors the needs list

**Who:** Client Manager.

**What happens:** The CM goes through the generated list and fills in anything
Spreo already holds from a previous loan with this guarantor, so the client is
not asked twice.

Dan's example: *"we just did a loan with this guy a month ago. Oh, I already got
his credit report. Credit reports are good for 90 days."*

**An important subtlety** that Jonathan drew out: bringing a document across
satisfies the *submission* only. It still goes through the full review path,
including third-party review. Dan agreed: *"Maybe something got missed. You never
know."*

**What the CM can and cannot do:**

- **Can** add a new item
- **Can** add a follow-up question under an existing item
- **Cannot** remove an item — only Credit can do that

If a CM thinks something should come off, they email Credit. Dan did not want a
button for this: *"I don't want a button that I look at every day… it's
distracting."* The system enforces the rule — a client manager attempting a
removal is refused.

---

### Step 2.4 · The kick-off email releases the list

**Who:** Client Manager.

**What happens:** The tailored needs list goes out to the broker, guarantor 1,
every other guarantor, with the LO copied.

**This is the moment the client's view switches on.** Before it, their portal
says *"your document list is being prepared"* and shows nothing else.

---

### Step 2.5 · Everything gets tracked

From here the Client Manager is keeping facts up to date. These are the fields
Dan reads off his pipeline every day.

**Appraisal** — eight statuses: Requested, Invoice Sent, Paid, Received, Under
Review, Challenged, Approved Pending Budget, Final.

Two of those need explaining. **Challenged** means Spreo disputes the value; the
order stays open rather than closing. **Approved Pending Budget** settles to
Final once the budget is approved.

Alongside the status, tracked separately:

- Promised delivery date, and target delivery date
- What the appraiser still needs from us: nothing, budget, plans, or both
- When those items were provided
- Inspection scheduled, inspection occurred, and the date it occurred

**Inspection is deliberately not a status.** It is three separate facts, so a
visit happening early or late does not push the order backwards.

**Budget** — the same shape, with its own inspection dates because the budget
vendor's visit is a different visit. Plus:

- Which review was ordered: Scrub or Feasibility
- What the vendor still needs from us
- When the budget was internally approved
- When it was sent on to the appraiser
- Client sign-off date

**Sponsor facts:** VOM status, payoff status, authorization status (Complete, or
Need 1 through Need 6), track record (No Initial, Initial, Complete).

**What building a track record actually involves**, from Dan on 23 July. Spreo
runs two programmes: a 36-month window and a 60-month window. To reach the top
tier the guarantors must have sold or stabilised **ten projects or $10 million**
in that window.

The work is connecting a person to each property, because almost every client
held their past projects in an LLC. For each address: run title, find the owning
entity, then look for the guarantor's signature on the title or loan document. If
that connects them, save the PDF and move on. If not, try the Secretary of State
register. If that fails, ask the client for an operating agreement — or, where the
property was a rental, a lease or rent roll, or sometimes a JV agreement.

That is why track record has three states rather than a yes/no, and why it is one
of the four conditions for leaving Pre-Processing.

**Dates:** target submission, target funding, LOI funding date, PSA closing date.

**Two dates the system works out itself:**

- **Calculated submission date** — the later of the appraisal and budget
  delivery dates
- **Calculated funding date** — the same, plus four business days

Dan picked the four days himself: *"let's just make it obvious. Let's just say
four business days."* The point of these is to show the gap against the target,
so someone can ask why.

---

### Step 2.6 · The gate into Processing

The loan does not move to Processing until four things are true:

1. The appraisal is **paid**
2. Escrow contact provided — **only if it is a purchase**
3. **Every** guarantor authorization signed and received
4. Track record at **Initial**

Dan: *"Until that happens, the loan stays in pre-processing."*

**The system enforces this.** An attempt to move the loan is refused, and the
unmet conditions are named. A manager can override, and the override is recorded.

**Why it matters to Dan** — this is the sentence he wants his team able to say:
*"you're in pre-processing. You've been in pre-processing for 14 days. The onus
is on you to get us some basic things, and you haven't got us these basic
things."*

---

## Stage 3 · Processing

Work carries on much as before. What changes is that the four gate conditions are
now behind us, so attention shifts to the documents themselves and to the two
vendors.

### How a document is checked

Three layers, in order:

**1 · Submission.** A file arrives. The moment it does, the item moves to
Received — no manual toggle. Dan: *"the second it goes in, it auto moves to
received."*

A submission can either **append** to what is already there or **replace** it.
Jonathan's example: three months of bank statements arrive as two, then one —
that is an append, not a replacement. Nothing is ever deleted; superseded files
stay in the history.

**2 · Spreo review.** The Client Manager marks it Approved, Rejected, or Need
Additional.

**3 · Third-party review.** The same three outcomes, recorded by the outside
firm.

**Follow-up questions** attach underneath an existing item rather than becoming
new items. Dan's example: a letter of explanation about something on a background
check, sitting under the item it relates to. The question also appears on the
client's list, not only in an email.

**Every decision carries a note.** Not only rejections. Jonathan: *"even if it's
approved, there could be notes that are important to just track that people
downstream may want to know about."*

**Two ways a document reaches third-party review.** Some go the moment Spreo
approves them. Others wait until a whole **package** is complete — the sponsor
package, for instance — and travel together. This is set per document.

**Where a resubmission goes back to depends on who asked for it.** If Spreo
review or third-party review asked, the new file goes back through those gates.
If the **underwriter** asked, it goes straight back to the underwriter and skips
them, because by then the loan is in a sprint. Jonathan, 28 July: *"it's all
about speed. It's like, I need to get something, great, now we can move
forward."* He flagged this as needing Dan's confirmation and it has not been
confirmed.

**Open point:** How documents actually reach Setpoint is unsettled. Their current
method is a folder structure on Box. The system records the routing decision but
does not transmit.

---

## Stage 4 · Internal Review

The whole file goes to the internal underwriter.

**Statuses:** In Review → Items Requested → Approved. It can go round more than
once.

### How it works

**The underwriter receives an email** with the loan summary and the files. Dan
described this as a dry run for the package the investor will get.

**They review by exception, not by approval.** Dan: *"Do it more on an exception
basis instead of an approval basis."* The documents were already checked one by
one — this person is looking for what is wrong with the loan as a whole.

**Findings are a plain list, in their own words.** Not marks against individual
documents. Jonathan: *"they're not going to necessarily click on the guarantor
application and mark that as bad. They're going to just sort of give their
diagnosis back to the CM."*

**Nothing can be approved while a finding is open.** Clearing one requires a note
saying how it was resolved.

**Sending it back** moves the loan to Items Requested and emails the numbered
findings to the client manager and the working group. **Findings never go to the
client.**

**Each leg is timed separately.** In Review → Items Requested → In Review again,
with its own timestamps each way. Dan: *"Time date in, time date out. And then
time date back in, time date back out, time date approved."*

Dan removed one thing he had originally written: the ability to flag specific
underwriting documents from a finding. *"I don't even think they should flag any
UW docs. Let's just get rid of that. I think that's weird."*

---

## Stage 5 · Investor Review

The same shape, for the capital partner.

**Statuses:** In Review → Items Requested → Approved / Conditionally Approved /
Feedback Requested. Also repeatable.

**The investor does not log in.** Spreo staff send the package by email from the
system and record what comes back on the investor's behalf.

Loans that have passed internal review appear in a queue, and sending is limited
to the staff whose role allows it.

---

## Stage 6 · Loan documents and closing

**Who:** Closing.

Dan's step, in his words: *"in approved, all we want to be able to do is run the
loan docs."*

### Step 6.1 · Generate

The system merges everything it holds into the Lightning Docs field set and shows
it before generating anything. Jonathan's shape for this: *"it's not just a
generate, it's sort of like a merge, view, tweak, and then send."*

**Two things block generation:**

- The capital partner has not approved
- Required closing fields are empty — the system names them

The closing field set is the list Closing supplied: funding entity, borrower
notice address, signatories and titles, guaranty type, lien position, broker
license and address, property APN, release pricing, governing law state and
county, default interest rate, I/O and amortization terms, MERS ID, construction
reserve type, Dutch or non-Dutch interest, prepayment premium, escrows, title
report number and effective date, exceptions to be removed from title, appraisal
fee, and signature affidavit details.

### Step 6.2 · The five statuses

```
Docs Approved → Docs Sent → Docs Signed → Cleared to Close → Funded
```

Each is stamped. Docs Sent produces a real email to guarantor 1 and the broker,
with the LO and CM copied.

### Step 6.3 · After funding

Three things are captured: **wire reference**, **funding date**, and the
**servicing tape** is generated.

The servicing tape cannot be generated before the loan is funded.

**Open point:** Dan said on 9 August he would document the rest of what happens
after loan documents are signed with his staff. Those three fields are what he
named; more may follow.

---

# Part 3 · The borrower's side

This runs alongside from Stage 2 onward.

**Each guarantor gets their own link.** Not one link per loan.

**Before the kick-off email** they see a single message: *"your document list is
being prepared."* No list, no count, no hint of what is coming.

**After it**, they see the items that concern them and nothing else:

- **Internal documents never appear.** Credit reports, background checks, PACER
  and UCC searches, the sponsor search, the org chart, VOM and payoff — Spreo
  pulls these itself. Dan: *"make sure that that internal document never shows up
  on the borrower portal."*
- **Internal review states never appear, and neither does approval.** Jonathan
  was precise about this on 28 July: the borrower only ever needs to know four
  things — *not received · submitted · resubmission needed · more information
  needed*. Whether something was approved internally, by the third party, or by
  the underwriter is Spreo's business. *"They don't need to know that something
  was internally approved… What they need to know is if a resubmission is needed
  or an additional document is required."*

**Uploading** puts the item straight into Received on Spreo's side. If they are
replacing something, that is an explicit choice — otherwise it is treated as an
addition.

**Follow-up questions appear against the item they relate to**, in plain words.

**There are no deadlines on the client's screen.** Dan was clear that each loan
has its own delay points that are outside the client's control — an entity has to
exist before it can have a bank account, and a bank account before it can have
statements.

---

# Part 4 · Rules for the whole platform

## What the system must do

**Make the process visible.** Dan's phrase for the whole of Phase 1: *"getting
people to follow the process."*

**Show days in status everywhere it matters.** This is the only timing signal.
Two days in pre-processing means someone should pick up the phone.

**Stamp everything.** Every status change records what it was, when, who did it,
and what caused it. Every leg of a back-and-forth is its own record.

**Build the needs list from the loan's characteristics.** Nobody should have to
remember what a mid-construction refinance requires.

**Say where every number came from.** Calculated dates show their working.

**Enforce rules in the system, not only in the interface.** If a rule is stated,
hiding a button is not enough — the action itself is refused. This applies to:
only Credit removing documents, the gate into Processing, approving with open
findings, and generating an LOI with a No Fly match.

**Show only what the person needs.** Fields appear when their stage is reached
and when the person's role calls for them. This is the direct fix for
LendingWise, where everyone saw everything and so nobody filled anything in.

**Keep one place to change a thing and one place to read it.** The Pulse tab
shows the pipeline for a loan and is read-only; each row names the tab where that
value is actually edited.

**Say when we have assumed something.** Where a source was silent and we chose,
the screen says so.

## What the system must not do

**No due dates. No overdue. No SLAs.** Dan: *"there's really no SLAs. Everything
is as soon as possible."* Nothing anywhere should say a thing is late.

**No escalation chains, no alerts.** Days in status and the recurring email are
the whole mechanism.

**No workflow configuration.** The process is fixed and built for Spreo. Dan on
seeing a configuration screen: *"I see the word workflow, and that's why I didn't
think that was part of this phase."*

**No admin console for Spreo to change things themselves.** Later phase.

**No text messaging.** Sending one is easy; handling a reply is not. Dan: *"if
somebody texts, they expect to text back, not email back."*

**No AI features.** Dan puts these squarely in Phase 2.

**No embedded credit or background pulling.** Those stay outside.

**No API into the AMC's system.** Where an AMC has its own ordering system, staff
update the status by hand.

**No buttons for things that almost never happen.** The client was emphatic about it. If something is rare, it is an email, not a control
on the screen.

**No deleting.** Superseded documents stay in history. Removed needs-list items
go into a drawer with a reason, and can come back.

## Rules about email

**Every send is composed, addressed, stamped and logged.** In the prototype,
delivery is simulated — nothing actually leaves.

**Every subject carries the address.** Every footer carries the loan number. Dan
wants this as groundwork: *"we know all these emails have this tagging in there.
So then eventually the AI can organize all that."*

**Recipients are worked out from the loan**, not typed by hand. If an address is
missing — no title company on file, for example — the system says so rather than
sending to nobody.

**Two kinds of template.** Most produce a full message you can edit. Two — the
Pre-Pre-Approval and Pre-Approval requests — open with the subject filled in and
an empty body for the sender to write, because the content varies too much.

**We record replies. We do not read mailboxes.** Someone records what came back,
and that is what moves the loan.

**The recurring client email** goes out Monday, Wednesday and Friday at 8am by
default, and the cadence can be changed. It lists everything outstanding in one
message — and not only documents. Paying the appraisal invoice, scheduling the
inspection, providing the draft budget all belong in it. When something is done
it simply stops appearing.

Client-facing wording is **under review** and **outstanding**. Dan rejected
"received": *"why are you sending them a list if you're saying it's already been
received? It's kind of like it's under review. Meaning like we are actioning
it."*

**Trigger emails** chase the two vendors. The conditions live on the email itself
rather than in a rules engine. Dan: *"And they're just said triggers. They're not
an SLA."* Six are built, but the number is not his — Dan said *"And I can list
them all"* and it was Jonathan who answered *"There could be, like, six of them."*
Dan's own list never arrived (Q-019).

## Rules about the interface

**Every input opens in a pop-up.** Tabs stay compact and mostly read-only;
clicking a group opens a focused window. This came from Jonathan on 6 August
after seeing a long scrolling page of fields.

**The journey is always visible.** Six stages across the top of every loan, with
the current one marked and its sub-status called out, so you can see where the
loan sits in the whole run rather than only where it is now.

**The design is the one already agreed.** Colours, spacing, the header, the four
operating widgets, the metric row and the quick-actions menu were settled with
Dan and Jonathan and are not to be redesigned. Layout may be rearranged only
where they asked for it.

**Dan's words are the words on screen.** Repeat Borrower, not Repeat Client. UW
Material, not Underwriting. Needs List, Kick-off Email, No Fly List, Scrub,
Feasibility, Track Record, VOM, Payoff, AMC.

## Rules about who sees what

Seven roles: Loan Officer, Credit, Client Management, Third-Party Review,
Internal Underwrite, Closing, Admin.

Two rules matter more than the rest:

**Pre-Approval belongs to Credit.** A client manager can see the loan but cannot
change it until the LOI is signed.

**After the LOI is signed the loan belongs to Client Management.** Credit drops
back to read-only — except for removing documents, which stays theirs for the
life of the loan.

The closing field set only appears once the investor has approved, or
immediately for the Closing role.

---

# Part 5 · What we assumed, and what we still need

## Things we chose because no source settled them

Each of these is marked on screen wherever it appears.

| What | What we did |
|---|---|
| Two needs-list items — insurance binder and rent roll | Included them. No source names either, but both are standard |
| ~~Which documents the client sees~~ | **No longer an assumption.** Dan named them on 29 July: internal are credit report, background, UCC, PACER and the Google search. Client-facing under guarantor are the application, driver's licence and authorization |
| PSA | Stored as a date, since two of the three source documents call it a date |
| "Governing law country" on Jonathan's sheet | Built as **county**, because Dan's list says "state and county" |
| Prior document validity | 90 days, from Dan's remark about credit reports |
| Matching a guarantor across loans | By email. A match offers the prior file; taking it re-runs the full review path |
| The investor tape | Dan named two of seven columns. The other five are our proposal, labelled as such |
| Who can release the needs list | Any role. Only the CM was mentioned |
| Which documents each capital partner requires | The mechanism is live; the items are named *"Fortress · additional field 1"* and marked assumed, because Dan has not said what they are |
| Which items should be locked to the borrower | The flag exists and is set per item. Nothing is locked by default |
| Which documents belong to a package | Every item defaults to going the moment Spreo approves it. Packages are set per document, by hand |

## Things only Dan can answer

Five of these are the same request: he owes us a list.

| What | Why it matters |
|---|---|
| **The permutation matrix** | Seven of nine add-on flags change nothing without it. The biggest single gap |
| **His document catalogue** | Ours is assembled from what the calls named. His own sheet would replace the guesswork |
| **The loan summary format** | The report the underwriter and the investor both read. Promised 31 July |
| **What happens after loan documents** | Beyond wire reference, funding date and servicing tape |
| **The investor tape columns** | He named address and rate, then had to leave the call |
| **The six trigger emails** | Ours are read from the 4 August call. He offered to list them properly |

## Decisions still open

| Question | Where it stands |
|---|---|
| Does the Processing gate hard-block, or only warn? | It blocks, with an override, because his words say it should |
| How do documents reach Setpoint? | Recorded but not transmitted. Both routes — immediate and packaged — are built |
| Is a client manager assigned automatically? | Manual, from the loan header, with reassignment. Every change is written to the status history |
| Who does Order Flood go to? | Template exists, recipient is a placeholder |
| Does Legal kick-off vary by template, recipient, or whether it fires? | The state appears in the subject; no county captured |
| Are there several LOI formats? | One, merged dynamically |
| Click-to-call? | Not built |
| Push documents to Churchill's Streamline? | Not built. Dan called it a big win but for later |

---

## Added after reading the rest of the sources

Three transcripts — 23, 28 and 29 July, about 47,000 words — were not read when
this document was first written. Reading them confirmed two things, corrected
two, and added several.

**Confirmed:**

- **The borrower portal is real and in Phase 1.** Discussed at length on 29 July.
- **Which documents are internal** is Dan's own list, not our guess.

**Corrected:**

- **What the borrower sees.** They never see approval — only not received,
  submitted, resubmission needed, more information needed.
- **When an item stops needing attention.** Dan wants it to stay in front of the
  client manager until *third-party* review clears it, not Spreo review, so
  someone can nudge if it is stuck.

**Added:**

- Packages, and the two routes to third-party review
- Where a resubmission goes back to, depending on who asked
- Notes on every decision, not only rejections
- How a track record is actually assembled
- The three signing packages to the client, and the primary guarantor
- Documents flagged as appraisal or budget deliverables so they show in the widget
- Document requirements that can vary by capital partner
- Documents the borrower must upload themselves

**Raised and deferred, both from 23 July:**

- **An inbox inside the system.** Dan: *"Why ever use Outlook?"* … *"It'll be a
  shadow Outlook."* A real ask, but Dan's 9 August answers assume replies arrive
  in Outlook, so this sits in a later phase.
- **A chat thread per loan**, with the LO and CM added automatically. Dan: *"at
  one point we had a Slack channel for every loan."* His own worry about it:
  people treat it as a replacement for email and the other person is not looking.

**A scope option Dan offered on 29 July**, worth remembering when the number is
discussed: *"for phase one, it can just end at third party. And we can just
generate a PDF or an email and send it to the internal underwriter, who provides the feedback and they just work it manually."*

## One last note on scope

Dan drew the line himself on 4 August:

> *"Phase 1 is about getting people to follow the process, being able to manage
> the process better, a better client experience — and that's really due to
> document management. Phase 2 is much more about efficiency and utilizing AI."*

And on why he is not asking for more now:

> *"It's about managing the team and not having them get confused. So by asking
> them to do something more, we want to have a trade-off. When Phase 2 comes in,
> there'll be added functionality that's actually going to remove — it's going to
> be more of a gear on a bicycle. We're going to get more out of them."*

Anything proposed for Phase 1 should pass one of three tests: does it make the
process visible, does it get documents in faster, or does it let the pipeline be
managed in one place. If not, it belongs to a later phase.
