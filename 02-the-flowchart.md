# Spreo Capital · Phase 1 — the process, as flowcharts

**What this is.** The whole loan process Spreo OS commits to, drawn so it can be
walked step by step and confirmed or corrected. Every diagram answers the same
four questions: who does it · what is captured · what is generated or sent ·
what the system records.

**Where it comes from.** Dan's process document (31 Jul), his written answers
(9 Aug), the calls of 23 Jul – 11 Aug, and his permutations / needs list /
communications message filed 15 Sep 2026 — the newest source, which wins
wherever it differs. Verbatim sources are in `docs/sources/`.

**How to read the shapes**

```mermaid
flowchart LR
  a["Someone does something"] --> b{"A branch"}
  b --> c[/"Data captured"/]
  c --> d[["Document generated"]]
  d --> e>"Email sent"]
  e --> f[("Saved or stamped by the system")]
  f --> g(["Loan status"])
  g -.- q["Q · A question for Dan — hangs off the step it concerns · all sixteen are listed at the end"]
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef status fill:#111827,stroke:#111827,color:#fff
  classDef ask fill:#fef3c7,stroke:#b45309,stroke-dasharray:4 3,color:#111
  class f sys
  class g status
  class q ask
```

**Colour is the role doing the step**

```mermaid
flowchart LR
  lo["Loan Officer"] ~~~ cr["Credit"] ~~~ cm["Client Management"] ~~~ mg["Management / Internal UW"] ~~~ tp["Third-Party Review"] ~~~ cl["Closing"] ~~~ sy["The system, automatically"] ~~~ ex["Outside party"]
  classDef lo fill:#fde68a,stroke:#b45309,color:#111
  classDef credit fill:#bfdbfe,stroke:#1d4ed8,color:#111
  classDef cm fill:#bbf7d0,stroke:#15803d,color:#111
  classDef uw fill:#ddd6fe,stroke:#6d28d9,color:#111
  classDef tpr fill:#99f6e4,stroke:#0f766e,color:#111
  classDef closing fill:#fecdd3,stroke:#be123c,color:#111
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef ext fill:#fff,stroke:#6b7280,stroke-dasharray:4 3,color:#111
  class lo lo
  class cr credit
  class cm cm
  class mg uw
  class tp tpr
  class cl closing
  class sy sys
  class ex ext
```

**Contents**

1. [The whole journey](#1--the-whole-journey)
2. [Roles and what each one does](#2--roles-and-what-each-one-does)
3. [Stage 1 · Pre-Approval](#3--stage-1--pre-approval)
4. [The LOI package](#4--the-loi-package)
5. [Permutations → the Needs List](#5--permutations--the-needs-list)
6. [Stage 2 · Pre-Processing](#6--stage-2--pre-processing)
7. [Appraisal, budget, sponsor facts and dates](#7--appraisal-budget-sponsor-facts-and-dates)
8. [How a document is checked](#8--how-a-document-is-checked)
9. [Stages 3–5 · Processing, Internal Review, Investor Review](#9--stages-35--processing-internal-review-investor-review)
10. [Stage 6 · Loan documents and closing](#10--stage-6--loan-documents-and-closing)
11. [Every communication, in order](#11--every-communication-in-order)
12. [Outside systems and how each one connects](#12--outside-systems-and-how-each-one-connects)
13. [The borrower's side](#13--the-borrowers-side)
14. [Questions for Dan, in order](#14--questions-for-dan-in-order)

---

## 1 · The whole journey

Six stages. Credit owns the first; Client Management owns everything from the
signed LOI onward; Closing owns the last. One hard gate — into Processing. Two
dead-ends — Not Pre-Approved, and an unresolved No Fly match.

```mermaid
flowchart TD
  subgraph S1["Stage 1 · Pre-Approval — Credit"]
    direction TB
    a1(["Credit Review"]) --> a2(["Pre-Pre-Approval Requested"]) --> a3(["Internal Approved"]) --> a4(["Investor Approval Requested"]) --> a5{"Investor decision"}
    a5 -->|"approved"| a6(["Pre-Approved"])
    a5 -->|"declined"| a7(["Not Pre-Approved — the loan ends"])
    a6 --> a8(["LOI Issued"]) --> a9(["LOI Signed"])
  end
  subgraph S2["Stage 2 · Pre-Processing — Client Management"]
    direction TB
    b1(["Pre-Processing"]) --> g1{"All four gate conditions true?"}
    g1 -->|"not yet — the system refuses and names what is unmet"| b1
  end
  subgraph S3["Stage 3 · Processing — Client Management"]
    c1(["Processing — documents reviewed · vendors deliver · loan structure approved"])
  end
  subgraph S4["Stage 4 · Internal Review — Management / Internal UW"]
    direction TB
    d1(["In Review"]) -->|"findings"| d2(["Items Requested"])
    d2 -->|"resolved, each with a note"| d1
    d1 -->|"no finding open"| d3(["Approved"])
  end
  subgraph S5["Stage 5 · Investor Review — recorded on the investor's behalf"]
    direction TB
    e1(["In Review"]) -->|"items or feedback"| e2(["Items Requested · Feedback Requested"])
    e2 --> e1
    e1 --> e3(["Approved · Conditionally Approved"])
  end
  subgraph S6["Stage 6 · Approved / Closing — Closing"]
    direction TB
    f1(["Docs Approved"]) --> f2(["Docs Sent"]) --> f3(["Docs Signed"]) --> f4(["Cleared to Close"]) --> f5(["Funded"])
  end
  a9 -->|"Hand-off email · a Client Manager takes ownership"| b1
  g1 -->|"appraisal paid · escrow contact if purchase · every authorization signed · track record Initial"| c1
  c1 -->|"Internal Final Approval email · loan summary, files, third-party findings"| d1
  d3 -->|"Final Approval request to the capital partner"| e1
  e3 -->|"Approved Terms email to LO and Closing"| f1
  a9 -.- q15["Q15 · Eight live loans sit in Signed LOI On Hold today. Is an On Hold state needed — and at which stages?"]
  classDef status fill:#111827,stroke:#111827,color:#fff
  classDef ask fill:#fef3c7,stroke:#b45309,stroke-dasharray:4 3,color:#111
  class a1,a2,a3,a4,a6,a7,a8,a9,b1,c1,d1,d2,d3,e1,e2,e3,f1,f2,f3,f4,f5 status
  class q15 ask
```

**What the system records at every step, on every loan**

| Recorded | Detail |
|---|---|
| Every status change | What it was, when, who did it, what caused it. Each leg of a back-and-forth is its own record |
| Days in current status | The only timing signal. No due dates, no SLAs, nothing is ever overdue |
| Every email | Template, recipients, sender, date/time, attachments. Replies are recorded by a person — the system never reads a mailbox |
| Every document event | Upload, replace, each review decision with its note. Nothing is deleted; superseded files stay in history |
| Every override | No Fly override, Processing-gate override — who, when, reason |
| Pulse | The pipeline view of all of the above. Read-only; each value names the tab where it is edited. Sort, pick and pin columns, totals, export to PDF and Excel |

**What the process produces — the reports**

| Report | When | What it is |
|---|---|---|
| The LOI package | Pre-Approval | LOI · liquidity requirement · authorization · loan checklist — see 4 |
| Loan Summary — the IC summary | Before Internal Review | The one-page story of the loan the underwriter and the investor both read |
| Investor tape | Final Approval | A short spreadsheet row for the capital partner — address, rate and a handful more |
| Servicing tape | After Funded | The spreadsheet handed to the loan servicer |
| Outstanding items by loan | Any time | Everything still open on a loan — the same list the recurring email sends |
| Appraisal and budget status | Any time | Where every order stands, promised against target |
| Timestamp report | Any time | Every status change on a loan with who and when — the accountability report |
| Custom export | Any time | Pick fields, get Excel |

---

## 2 · Roles and what each one does

```mermaid
flowchart LR
  subgraph LO["Loan Officer"]
    direction TB
    lo1["Emails the deal to submissions@ — structure, write-up, valuation. In Outlook"]
    lo2["Creates the loan record — five fields"]
    lo3["Receives Loan Pre-Approved — the structure and terms"]
    lo4["Copied on the LOI, vendor orders and client emails throughout"]
    lo5["Approves the final loan structure internally"]
    lo6["Receives Approved Terms"]
    lo1 --> lo2 --> lo3 --> lo4 --> lo5 --> lo6
  end
  subgraph CR["Credit"]
    direction TB
    cr1["Works out structure, value and write-up"]
    cr2["Sends the Internal and Investor Pre-Approval requests · records the replies"]
    cr3["Enters sponsor, project, loan and permutation data"]
    cr4["Verifies the Needs List — adds items, removes with a reason"]
    cr5["Generates and issues the LOI package"]
    cr6["Orders the appraisal and the budget review"]
    cr7["Hands off to Client Management at LOI Signed · sends the Pre-Processing email"]
    cr8["Finalises the loan structure once real numbers are in · requests the LO's approval"]
    cr9["The only role that can remove a Needs List item — for the life of the loan"]
    cr1 --> cr2 --> cr3 --> cr4 --> cr5 --> cr6 --> cr7 --> cr8 --> cr9
  end
  subgraph CM["Client Management"]
    direction TB
    cm1["Takes ownership at LOI Signed"]
    cm2["Sends the invoice, kick-off, application, disclosures and vendor kick-offs"]
    cm3["Tailors the Needs List — carries over prior documents, adds items and follow-ups"]
    cm4["Tracks appraisal, budget, VOM, payoff, authorizations, track record, dates"]
    cm5["Reviews every document — approve, reject, need additional, always with a note"]
    cm6["Requests the client's approval of the final structure"]
    cm7["Sends the Setpoint Request and the Internal Final Approval"]
    cm8["Clears underwriter findings, each with a note"]
    cm9["Requests Final Approval from Churchill or SCIF"]
    cm10["Sends Approved Terms to the LO and Closing"]
    cm1 --> cm2 --> cm3 --> cm4 --> cm5 --> cm6 --> cm7 --> cm8 --> cm9 --> cm10
  end
  subgraph MG["Management / Internal UW"]
    direction TB
    mg1["Approves the Pre-Pre-Approval request"]
    mg2["Reads the loan summary and files · reviews by exception · raises numbered findings"]
    mg3["Approves once no finding is open"]
    mg4["Requests Final Approval from Fortress"]
    mg5["Overrides a No Fly match or the Processing gate — with a recorded reason"]
    mg1 --> mg2 --> mg3 --> mg4 --> mg5
  end
  subgraph TP["Third-Party Review — Setpoint / offshore"]
    direction TB
    tp1["Re-checks each document — approve, reject, need additional"]
    tp2["Findings recorded per document"]
    tp1 --> tp2
  end
  subgraph CL["Closing"]
    direction TB
    cl1["Fills the Lightning Docs field set"]
    cl2["Generates, approves and sends the loan documents"]
    cl3["Sends Loan Docs to Escrow"]
    cl4["Records wire reference and funding date · generates the servicing tape"]
    cl1 --> cl2 --> cl3 --> cl4
  end
  subgraph AD["Admin"]
    ad1["Everything, plus the No Fly lists"]
  end
  LO ~~~ CR ~~~ CM ~~~ MG ~~~ TP ~~~ CL ~~~ AD
  classDef lo fill:#fde68a,stroke:#b45309,color:#111
  classDef credit fill:#bfdbfe,stroke:#1d4ed8,color:#111
  classDef cm fill:#bbf7d0,stroke:#15803d,color:#111
  classDef uw fill:#ddd6fe,stroke:#6d28d9,color:#111
  classDef tpr fill:#99f6e4,stroke:#0f766e,color:#111
  classDef closing fill:#fecdd3,stroke:#be123c,color:#111
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  class lo1,lo2,lo3,lo4,lo5,lo6 lo
  class cr1,cr2,cr3,cr4,cr5,cr6,cr7,cr8,cr9 credit
  class cm1,cm2,cm3,cm4,cm5,cm6,cm7,cm8,cm9,cm10 cm
  class mg1,mg2,mg3,mg4,mg5 uw
  class tp1,tp2 tpr
  class cl1,cl2,cl3,cl4 closing
  class ad1 sys
```

**Outside parties — none of them log in**

| Party | Touches the process how |
|---|---|
| Guarantors / the client | Sign the LOI and authorizations · receive the Needs List and the recurring email · upload through a personal portal link · sign application and disclosures via DocuSign · approve the final structure |
| Broker | Copied on the client emails · may carry the additional guarantors' authorizations · eight fields captured on the loan |
| Capital partner — Fortress, SCIF, Churchill | Pre-approves and finally approves by email · replies recorded by staff · receives the investor tape · Churchill also supplies a No Fly list |
| AMC / appraiser | Receives the order and trigger emails · sends invoice and report · status kept by hand |
| Budget vendor | Receives the Construction Order · receives budget and plans from the client · inspects · delivers the Scrub or Feasibility |
| Setpoint / offshore | Receives the Setpoint Request and the documents · returns findings per document |
| Title · Escrow · Legal · Flood | Receive kick-off and order emails · Title returns the updated estimated closing statement · Escrow receives the loan documents |
| Loan servicer | Receives the servicing tape after funding |

---

## 3 · Stage 1 · Pre-Approval

Credit owns this stage completely. The approval chain runs **before** the data
entry: Credit asks Dan, then the capital partner, and only then enters the
sponsor, project, loan and permutation data — right before the LOI is generated.

```mermaid
flowchart TD
  lo0>"Outlook, outside the system — the LO emails Credit at submissions@ with the loan structure, a write-up and a valuation"]
  lo0 --> lo1[/"The LO creates the loan — five fields and nothing else:<br/>Full address · Purchase or Refi · Portfolio Refi Y/N · Repeat Borrower Y/N · Approximate loan amount"/]
  lo1 --> s1[("Saved: the loan · status Credit Review · created by · date/time")]
  s1 --> cr0["Credit works out the structure, the value and the write-up — offline"]
  cr0 --> e1>"Email: Internal Pre-Approval Request — Credit to Management<br/>Subject merged with the address · body typed by Credit · attachments · recipients pre-set"]
  e1 --> s2[("Stamped: sent · status Pre-Pre-Approval Requested")]
  s2 --> r1["Dan replies in Outlook · Credit opens the send and records the outcome"]
  r1 --> q1{"Approved internally?"}
  q1 -->|"no — rework"| cr0
  q1 -->|"yes"| s3[("Status Internal Approved · date/time")]
  s3 --> cs[/"Credit sets the Capital Source — Fortress, SCIF, Churchill — the request cannot be addressed without it"/]
  cs --> e2>"Email: Investor Pre-Approval Request — Credit to the capital partner<br/>Subject merged · body typed · attachments"]
  e2 --> s4[("Stamped: sent · status Investor Approval Requested · request date/time")]
  s4 --> r2["The investor replies · Credit records the outcome"]
  r2 --> q2{"Investor decision"}
  q2 -->|"declined"| x1(["Not Pre-Approved — the loan ends here"])
  q2 -->|"approved"| s5[("Status Pre-Approved · approval date/time")]
  s5 --> e3>"Email: Loan Pre-Approved — Credit to the LO · the approved structure and terms"]
  e3 --> nx(["Continue below — data entry to LOI Signed"])
  e1 -.- q1x["Q1 · Guarantor names are not captured until after Pre-Approved, so the No Fly check runs after both approvals. Should the LO or Credit enter the names up front?"]
  x1 -.- q14["Q14 · A dead end — or back to Internal Approved with a different capital partner?"]
  classDef lo fill:#fde68a,stroke:#b45309,color:#111
  classDef credit fill:#bfdbfe,stroke:#1d4ed8,color:#111
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef status fill:#111827,stroke:#111827,color:#fff
  classDef ask fill:#fef3c7,stroke:#b45309,stroke-dasharray:4 3,color:#111
  class lo0,lo1 lo
  class cr0,cs,r1,r2,e1,e2,e3 credit
  class s1,s2,s3,s4,s5 sys
  class x1,nx status
  class q1x,q14 ask
```

**From data entry to the signed LOI.** Only now does Credit enter the loan's
data — the approval chain has already run on the write-up.

```mermaid
flowchart TD
  st(["Pre-Approved"]) --> cr1[/"Credit enters everything the LOI needs — about forty fields:<br/>Sponsor — each guarantor: name, email, phone, Repeat Borrower · estimated experience tier · minimum FICO · minimum ownership<br/>Project — street, city, state, zip · purchase price and date · estimated AIV and ARV<br/>Loan — initial amount · coupon · term · extensions and fee · processing fee · draw fee · holdback · interest reserve · recourse type<br/>The permutations — see 5 · the Capital Source is already set"/]
  cr1 --> nf1["The system checks every guarantor name against both No Fly lists — Churchill's and Spreo's"]
  nf1 --> q3{"Match?"}
  q3 -->|"yes"| nf2["Red banner on the loan · pop-up when the record is opened, must be acknowledged · LOI generation blocked"]
  nf2 --> q4{"Manager or Admin overrides?"}
  q4 -->|"no"| x2(["The loan stops"])
  q4 -->|"yes, with a reason"| s6[("Saved: the override — who, when, why · the name stays on the list")]
  s6 --> s7
  q3 -->|"no"| s7[("Saving the permutations builds the Needs List — see 5")]
  s7 --> cr2["Credit verifies the Needs List — adds one-off items · marks items not needed, with a reason"]
  cr2 --> s8[("Saved: removed items go to a not-needed drawer with the reason and who — restorable, never deleted")]
  s8 --> q5{"No unresolved No Fly match, and every LOI field filled?"}
  q5 -->|"no — the system names what is missing"| cr1
  q5 -->|"yes"| g1[["Generate the LOI package — one PDF, four parts — see 4"]]
  g1 --> cr3["One Send screen — Credit reviews the checklist and unticks anything not wanted · picks the AMC · chooses DocuSign or download-and-sign · adds notes that merge into the letter"]
  cr3 --> e4>"Email: LOI Issue — Credit to the LO"]
  cr3 --> e5>"The LOI to Guarantor 1 for signature — DocuSign, or the PDF sent by hand · broker copied · LO copied"]
  cr3 --> e6>"Email: Appraisal Order — Credit to the AMC · CM and LO copied"]
  cr3 --> q6{"Light Reno, Heavy Reno, GUC, or a mid-construction refinance?"}
  q6 -->|"yes"| e7>"Email: Construction Order — Credit to the budget vendor · Scrub or Feasibility · LO bcc"]
  q6 -->|"no"| s9
  e4 --> s9
  e5 --> s9
  e6 --> s9
  e7 --> s9[("Stamped: LOI issue date/time · LOI delivery — DocuSign or PDF · appraisal ordered Y/N and date/time · AMC · budget vendor order date/time · unticked items marked not needed · status LOI Issued")]
  s9 --> amc["The AMC sends its invoice"]
  amc --> e8>"Email: Appraisal invoice link — Credit to the CM and the LO · not to the client yet"]
  e8 --> s10[("Saved: appraisal invoice date/time")]
  s9 --> r3["The signed LOI comes back — DocuSign records it, or Credit marks it signed by hand: who signed, when"]
  r3 --> s11[("Status LOI Signed · signed date · signed by")]
  s11 --> e9>"Email: Hand-off — Credit to Client Management"]
  e9 --> nx(["Stage 2 · Pre-Processing"])
  e7 -.- q2["Q2 · Construction Order — Credit at the LOI (Sept), or the CM after signing (31 Jul)? Do the Purchase / Refi / Refi-Mid-Construction variants still stand?"]
  e9 -.- q4["Q4 · Hand-off at LOI Issued or LOI Signed? If Issued, the invoice link has a CM to go to"]
  classDef credit fill:#bfdbfe,stroke:#1d4ed8,color:#111
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef ext fill:#fff,stroke:#6b7280,stroke-dasharray:4 3,color:#111
  classDef status fill:#111827,stroke:#111827,color:#fff
  classDef ask fill:#fef3c7,stroke:#b45309,stroke-dasharray:4 3,color:#111
  class cr1,cr2,cr3,r3,e4,e5,e6,e7,e8,e9,g1 credit
  class s6,s7,s8,s9,s10,s11,nf1,nf2 sys
  class amc ext
  class st,x2,nx status
  class q2,q4 ask
```

---

## 4 · The LOI package

One document, four parts, merged from the loan record. Guarantor 1 signs the
full packet. Every other guarantor gets a separate, shorter authorization.

```mermaid
flowchart TD
  mv[/"Merged from the loan: property address · borrowing entity · guarantors · loan amount · rate · term · extensions · points and fees · recourse · holdback and interest reserve · estimated funding date · LOI expiration · notes"/]
  mv --> pkg[["The LOI package — one PDF"]]
  pkg --> p1["1 · The LOI — the terms Spreo is offering, plus the notes box if filled"]
  pkg --> p2["2 · The liquidity requirement — how much cash the guarantors must show"]
  pkg --> p3["3 · The transaction authorization — signed by Guarantor 1 · lets Spreo pull credit and background"]
  pkg --> p4["4 · The loan checklist — the Needs List printed, so the client sees up front what will be asked for"]
  p3 --> q1{"Purchase or Refinance?"}
  q1 -->|"Purchase"| p3a["Asks for escrow contact details · says nothing about payoff or VOM"]
  q1 -->|"Refinance"| p3b["Also authorizes the current lender to release the Payoff and the VOM"]
  pkg --> q2{"More than one guarantor?"}
  q2 -->|"yes"| p5[["A separate short authorization for each additional guarantor — identity and credit only · no payoff, VOM or escrow language · its own page, not buried in the packet"]]
  p5 --> p6["Sent via DocuSign, via the LO, or via the Broker · one is also attached to the LOI"]
  p1 --> q3{"How is it delivered?"}
  q3 -->|"DocuSign"| d1["Envelope to Guarantor 1 · broker and LO copied · signing status and date recorded per guarantor"]
  q3 -->|"By hand"| d2["PDF downloaded · marked sent with date/time · marked signed — by whom, when"]
  d1 --> sv[("Saved: LOI issue date/time · delivery method · signed date · signed by · each guarantor's authorization — Need, Sent, Signed")]
  d2 --> sv
  p6 --> sv
  p6 -.- q5["Q5 · Your note reads: one authorization attached to the LOI and another sent separately, for each guarantor. Is that Guarantor 1 in the packet and the others separately — or two authorizations per guarantor?"]
  classDef credit fill:#bfdbfe,stroke:#1d4ed8,color:#111
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef ask fill:#fef3c7,stroke:#b45309,stroke-dasharray:4 3,color:#111
  class mv,pkg,p1,p2,p3,p4,p3a,p3b,p5,p6,d1,d2 credit
  class sv sys
  class q5 ask
```

**Before it can be generated:** no unresolved No Fly match, and every field the
letter needs is filled — the system names the missing ones.

---

## 5 · Permutations → the Needs List

The one genuinely automatic thing in Phase 1. Credit saves the permutations;
the system builds the list. Credit then corrects it before anyone outside sees it.

```mermaid
flowchart TD
  cap[/"Captured by Credit — the permutations:<br/>Channel — Direct or Broker · Repeat Borrower · Repeat Broker · Global Required<br/>Transaction — Purchase · Cash-out Refi · No-cash-out Refi · Portfolio Refi · Mid Construction<br/>Property — SFR · 2-4 Unit · MFR · Lot Split · Condo Map · ADUs · Adding SF<br/>Loan type — Bridge · Light Reno · Heavy Reno · GUC · DSCR · Weather Tight<br/>Number of guarantors · Capital source — already set at the investor request"/]
  cap --> gen[("Saving them builds the Needs List")]
  cap -.- q7["Q7 · Condo Map — evidence of condo map? Lot Split, ADUs, Weather Tight, Repeat Broker, Portfolio Refi — what does each add or take away?"]
  gen --> std
  subgraph std["Standard Needs List — on every loan"]
    direction TB
    st1["For each guarantor: copy of Driver's License · Application via DocuSign · Authorization — one in the LOI packet, one sent separately via DocuSign, the LO or the Broker · last 2 months of consecutive personal bank statements · Schedule of Real Estate"]
    st2["Borrowing entity: last 2 months of consecutive entity bank statements · Operating Agreement"]
    st3["Signed Federal Disclosures via DocuSign"]
    st4["Track Record"]
  end
  st4 --> q0{"DSCR or RTL?"}
  q0 -->|"DSCR"| tr1["24 months of real-estate investment experience, including leases"]
  q0 -->|"RTL — Bridge, Light Reno, Heavy Reno, GUC"| tr2["List of stabilized or sold properties within the past 36 months"]
  tr1 --> q1
  tr2 --> q1{"Purchase or Refinance?"}
  q1 -->|"Purchase"| a1["+ PSA · + escrow contact information"]
  q1 -->|"Refinance"| a2["+ VOM · + Payoff · + latest mortgage statement"]
  a2 --> q2{"Mid-construction refinance?"}
  q2 -->|"yes"| a3["+ last inspection report from the previous lender · + Spend to Date details"]
  q2 -->|"no"| q3
  a1 --> q3
  a3 --> q3{"Direct or Broker?"}
  q3 -->|"Broker"| a4[/"Captured: Broker Name · Broker Company · Email · Phone · License Type · License No. · Broker Origination Fee (%) · Broker Processing Fee ($)"/]
  q3 -->|"Direct"| q4
  a4 --> q4{"More than one guarantor?"}
  q4 -->|"yes — for each additional guarantor"| a5["+ Signed Authorization · + copy of Driver's License · + completed and signed Application · + Schedule of Real Estate"]
  q4 -->|"no"| q5
  a5 --> q5{"Adding square footage?"}
  q5 -->|"yes"| a6["+ Plans"]
  q5 -->|"no"| q6
  a6 --> q6{"Loan type"}
  q6 -->|"Light Reno · Heavy Reno · GUC"| a7["+ Draft Budget · + Budget Review — Scrub or Feasibility · + Construction Inspection"]
  q6 -->|"DSCR"| a8["+ Subject property leases"]
  q6 -->|"Bridge"| q7
  a7 --> q7
  a8 --> q7{"Global Required?"}
  q7 -->|"yes"| a9["+ Personal tax returns · + investment statements"]
  q7 -->|"no"| q8
  a9 --> q8{"Capital source"}
  q8 -->|"Fortress · SCIF · Churchill"| a10["+ the partner's own items"]
  a10 --> int["Plus the internal items Spreo pulls itself — never shown to the borrower:<br/>credit report · background check · PACER · UCC search · sponsor search · org chart · VOM · Payoff"]
  int --> out[("The Needs List — one socket per item · which permutation produced it · borrower-facing Y/N · not visible to the client until the Kick-off Email")]
  a6 -.- q6["Q6 · Plans only when adding square footage — or for Heavy Reno and GUC as well?"]
  classDef credit fill:#bfdbfe,stroke:#1d4ed8,color:#111
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef ask fill:#fef3c7,stroke:#b45309,stroke-dasharray:4 3,color:#111
  class cap,a4 credit
  class gen,st1,st2,st3,st4,tr1,tr2,a1,a2,a3,a5,a6,a7,a8,a9,a10,int,out sys
  class q6,q7 ask
```

**A socket can hold several files.** Three months of bank statements are three
files in one socket. Each socket later carries its three review states — see 8.

**If the permutations change later** — a guarantor is added, the loan type
changes — new items are added. Items no longer needed are retired only if
nothing has been uploaded against them. Anything already submitted stays.

**Repeat Borrower.** Documents Spreo already holds from a prior loan with the
same guarantor can be carried across by the CM (see 6). That satisfies the
submission only — the file still goes through every review layer.

---

## 6 · Stage 2 · Pre-Processing

Starts the moment the LOI is signed. The Client Manager takes over. This is the
first time the client hears from Spreo about documents.

```mermaid
flowchart TD
  in(["LOI Signed"]) --> h>"Email: Hand-off — Credit to Client Management"]
  h --> cm0["A Client Manager takes ownership — assigned by hand, can be reassigned"]
  cm0 --> s0[("Status Pre-Processing · CM name · assignment date/time")]
  s0 --> e1>"Email: Pre-Processing — Credit to client and broker · LO copied<br/>Generic and immediate: repeats the checklist from the LOI · pay the appraisal, get the budget to the vendor, schedule the inspection, send your driver's licence and authorization · carries the appraisal invoice link"]
  e1 --> e2>"Email: Appraisal invoice — CM to the client · LO copied · the invoice link"]
  e2 --> s1[("Appraisal status Invoice Sent · date/time")]
  s1 --> tailor["The CM tailors the Needs List"]
  tailor --> q1{"Repeat Borrower — anything already on file from a prior loan?"}
  q1 -->|"yes"| carry["Carry the prior file across — counts as submitted only · still goes through Spreo and third-party review"]
  q1 -->|"no"| add
  carry --> add["The CM can add items and follow-up questions · cannot remove an item — asks Credit by email"]
  add --> pulls["As each signed authorization comes back, Spreo runs credit, background, PACER, UCC and a Google search on that guarantor — internal items, never on the client's list · anything found becomes a follow-up item under that guarantor · middle FICO recorded"]
  pulls --> e3>"Email: Kick-off — CM to the broker, Guarantor 1 and every other guarantor · LO copied<br/>The tailored Needs List in the email itself, plus each guarantor's personal portal link"]
  e3 --> s2[("Stamped: kick-off date/time · the client's view switches on")]
  s2 --> e4>"Email: Application — CM to each guarantor · DocuSign link"]
  e4 --> e5>"Email: Disclosures — CM to Guarantor 1 · DocuSign link"]
  e5 --> s3[("Saved per guarantor: application — Need, Sent, Signed + date · disclosures — Need, Sent, Signed + date · authorization — Need, Sent, Signed + date")]
  s3 --> e6>"Email: Title Kick-off — CM to the title company"]
  e6 --> e7>"Email: Escrow Kick-off — CM to the escrow company"]
  e7 --> q2{"Property in an attorney state?"}
  q2 -->|"yes"| e8>"Email: Legal Kick-off — CM to counsel · language varies by state"]
  q2 -->|"no"| e9
  e8 --> e9>"Email: Order Flood — CM to the flood vendor"]
  e9 --> s4[("Each send stamped: template · recipients · sender · date/time")]
  s4 --> rec>"Recurring Needs List — automatic, on behalf of Credit, to client and broker<br/>Daily at a set time · every workday · or chosen days and times each week<br/>Everything still outstanding in one message — documents, the unpaid invoice, the unscheduled inspection, what a vendor still needs · items drop off when done · wording is Outstanding and Under Review · no due dates"]
  s4 --> track["The CM keeps the operating facts current — see 7:<br/>appraisal · budget · VOM · Payoff · authorizations · track record · target dates"]
  track --> one>"Available any time as one-offs: Request Letter of Explanation · Order updated estimated closing statement from Title — also on the task list, carries the loan structure"]
  track --> gate{"Gate into Processing — all four true?<br/>1 · appraisal paid<br/>2 · escrow contact provided — purchase only<br/>3 · every guarantor authorization signed and received<br/>4 · track record at Initial"}
  gate -->|"no — the system refuses and names what is unmet"| track
  gate -->|"manager override, reason recorded"| proc
  gate -->|"yes"| proc(["Status Processing · date/time"])
  cm0 -.- q9["Q9 · How is the CM chosen — by rule from the LO, from a queue, or by hand?"]
  e1 -.- q3["Q3 · Sent by Credit (Sept) or by the CM (31 Jul)? It carries the invoice link and the CM sends a separate invoice email — are both intended?"]
  e3 -.- q10["Q10 · Is there a kick-off call with the client? Jonathan's sheet has a Kick-Off Call date"]
  s4 -.- q8["Q8 · Two emails on Jonathan's sheet are not on your list — VOM and Payoff Request to the current lender on a refinance, and Appraisal Invoice Request to the AMC. Do they exist?"]
  classDef credit fill:#bfdbfe,stroke:#1d4ed8,color:#111
  classDef cm fill:#bbf7d0,stroke:#15803d,color:#111
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef status fill:#111827,stroke:#111827,color:#fff
  classDef ask fill:#fef3c7,stroke:#b45309,stroke-dasharray:4 3,color:#111
  class h,e1 credit
  class cm0,e2,tailor,carry,add,e3,e4,e5,e6,e7,e8,e9,track,one cm
  class s0,s1,s2,s3,s4,rec,pulls sys
  class in,proc status
  class q3,q8,q9,q10 ask
```

**Attorney states** — the Legal Kick-off fires only here, and its language
varies by state: Alabama · Connecticut · Delaware · Florida · Georgia ·
Kentucky · Louisiana · Maine · Maryland · Massachusetts · Mississippi ·
New Hampshire · New York · North Carolina · North Dakota · Rhode Island ·
South Carolina · Vermont · West Virginia.

**A guarantor added later** gets only their own documents — their authorization,
application and driver's licence — not the whole list again.

**The Pre-Processing email is not the Kick-off.** The first is generic and goes
at once. The Kick-off is tailored and releases the list.

---

## 7 · Appraisal, budget, sponsor facts and dates

These are the facts Dan reads off the pipeline every day. The CM keeps them
current from Pre-Processing through Processing.

```mermaid
flowchart LR
  subgraph AP["Appraisal"]
    direction TB
    ap0[/"Captured: AMC · turn-around days · promised delivery date · target delivery date · appraiser needs — none, budget, plans, both · needs provided date/time · inspection scheduled date · inspection occurred date · invoice paid date/time"/]
    ap1(["Requested"]) --> ap2(["Invoice Sent"]) --> ap3(["Paid"]) --> ap4(["Received"]) --> ap5(["Under Review"])
    ap5 --> apq{"Value accepted?"}
    apq -->|"no — Spreo disputes it"| ap6(["Challenged — the order stays open"])
    ap6 --> ap5
    apq -->|"yes, budget still open"| ap7(["Approved Pending Budget"])
    apq -->|"yes"| ap8(["Final"])
    ap7 -->|"budget approved"| ap8
    ap4 --> apr[("Saved: the report in its socket · appraised AIV and ARV · received date/time · initial and final approval dates")]
  end
  subgraph BU["Budget — construction and renovation loans"]
    direction TB
    bu0[/"Captured: review type — Scrub or Feasibility · vendor needs — none, budget, plans, both · draft budget provided Y/N · draft plans provided Y/N · inspection scheduled date · inspection occurred date · promised delivery · target delivery"/]
    bu1(["Ordered"]) --> bu2["The client sends the draft budget and plans to the vendor"] --> bu3["Vendor inspection — a separate visit from the appraiser's"] --> bu4(["Received"]) --> bu5(["Under Review"]) --> bu6(["Approved"])
    bu6 --> bu7[("Saved: internally approved date/time · sent to the appraiser date/time · client sign-off date · final total budget")]
  end
  subgraph SP["Sponsor facts"]
    direction TB
    sp1[/"VOM — Not Ordered · Ordered · Received<br/>Payoff — Not Ordered · Ordered · Received<br/>Escrow contact provided — purchase only<br/>Authorization — Complete, or Need 1 … Need 6<br/>Track Record — No Initial · Initial · Complete<br/>Middle FICO per guarantor"/]
  end
  subgraph DT["Dates"]
    direction TB
    dt1[/"Captured: target submission date · target funding date · LOI funding date · PSA closing date · rate lock expiration"/]
    dt2[("Calculated submission date = the later of the appraisal and budget delivery dates")]
    dt3[("Calculated funding date = calculated submission + 4 business days")]
    dt4["Shown beside the targets so the gap is visible and someone can ask why"]
    dt1 --> dt2 --> dt3 --> dt4
  end
  classDef cm fill:#bbf7d0,stroke:#15803d,color:#111
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef ext fill:#fff,stroke:#6b7280,stroke-dasharray:4 3,color:#111
  classDef status fill:#111827,stroke:#111827,color:#fff
  class ap0,bu0,sp1,dt1,dt4 cm
  class apr,bu7,dt2,dt3 sys
  class bu2,bu3 ext
  class ap1,ap2,ap3,ap4,ap5,ap6,ap7,ap8,bu1,bu4,bu5,bu6 status
```

**Inspection is deliberately not a status.** It is separate facts — scheduled,
occurred, date — so a visit happening early or late does not push the order
backwards.

**Trigger emails to the two vendors** — automatic, conditions on the email
itself, not SLAs:

| Trigger | Fires when |
|---|---|
| Appraisal invoice unpaid | 48 hours after the invoice was sent |
| Inspection confirmation | The day after the scheduled inspection |
| Appraiser needs outstanding | Items requested and not yet provided |
| Delivery check-in | 48 hours before promised delivery |
| Budget vendor needs outstanding | Same pattern |
| Budget delivery check-in | Same pattern |

**Building the track record** — why it has three states rather than yes/no.
*Initial* is the list of addresses in hand; *Complete* is every one of them
connected to the guarantor.

```mermaid
flowchart TD
  n0(["No Initial — no list of past projects yet"])
  n0 --> lst["The client or the LO supplies the list of past projects — almost always held in an LLC"]
  lst --> n1(["Initial — the list is in hand · one of the four conditions to leave Pre-Processing"])
  n1 --> t1["For each address: run title · find the owning entity"]
  t1 --> q1{"Guarantor's signature on the title or loan document?"}
  q1 -->|"yes"| sv[("Save the PDF against the project")]
  q1 -->|"no"| t2["Check the Secretary of State register"]
  t2 --> q2{"Connects the guarantor to the entity?"}
  q2 -->|"yes"| sv
  q2 -->|"no"| t3["Ask the client — operating agreement · or a lease or rent roll if it was a rental · or a JV agreement"]
  t3 --> sv
  sv --> q3{"Every address connected?"}
  q3 -->|"not yet — next address"| t1
  q3 -->|"yes"| n2(["Complete"])
  classDef cm fill:#bbf7d0,stroke:#15803d,color:#111
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef ext fill:#fff,stroke:#6b7280,stroke-dasharray:4 3,color:#111
  classDef status fill:#111827,stroke:#111827,color:#fff
  class t1,t2,t3 cm
  class lst ext
  class sv sys
  class n0,n1,n2 status
```

---

## 8 · How a document is checked

Three layers, in order: submission → Spreo review → third-party review. Every
decision carries a note, not only rejections. Nothing is ever deleted.

```mermaid
flowchart TD
  n0(["Not received — the client sees Outstanding"])
  n0 --> up{"How does the file arrive?"}
  up -->|"the client uploads through their portal link"| rec
  up -->|"staff upload on the client's behalf"| rec
  up -->|"carried over from a prior loan"| rec
  rec[("Received — automatic the moment the file lands · stored in the item's socket · added to what is there, or explicitly replaced — the old file stays in history · the client sees Under Review")]
  rec --> who{"Who asked for this file?"}
  who -->|"first submission, or Spreo or third-party asked"| sr["Spreo review — the CM decides"]
  who -->|"the underwriter asked"| uw["Straight back to the underwriter — skips both review layers"]
  sr --> srq{"Decision — always with a note"}
  srq -->|"Rejected"| rj["The client sees Resubmission needed"]
  srq -->|"Need Additional"| na["A follow-up question attaches under the item · the client sees More information needed, with the question in plain words"]
  rj --> n0
  na --> n0
  srq -->|"Approved"| route{"How does this item travel to third-party review?"}
  route -->|"immediately"| tp
  route -->|"as part of a package"| pk{"Whole package approved?"}
  pk -->|"not yet — waits"| pk
  pk -->|"yes — travels together"| tp
  tp["Third-party review — Setpoint or offshore · documents delivered to their folder structure · decision recorded per document"]
  tp --> tpq{"Decision — with a note"}
  tpq -->|"Rejected · Need Additional"| n0
  tpq -->|"Approved"| done[("Cleared — the item leaves the CM's attention only now")]
  classDef cm fill:#bbf7d0,stroke:#15803d,color:#111
  classDef uw fill:#ddd6fe,stroke:#6d28d9,color:#111
  classDef tpr fill:#99f6e4,stroke:#0f766e,color:#111
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef status fill:#111827,stroke:#111827,color:#fff
  class sr,rj,na cm
  class uw uw
  class tp tpr
  class rec,done sys
  class n0 status
```

**Per guarantor, with dates.** The application, the disclosures and the
authorization are tracked on each guarantor — Need, Sent, Signed, and the date
received — so anyone can see at a person level who has signed what.

**What the client never sees:** internal items, Spreo's review states, third-party
states, approval. Only Outstanding · Under Review · Resubmission needed · More
information needed.

---

## 9 · Stages 3–5 · Processing, Internal Review, Investor Review

Processing is where documents flow and the vendors deliver. Once the real
numbers are in, Credit finalises the structure and the loan goes up the chain:
the LO, the client, Setpoint, internal management, the capital partner.

```mermaid
flowchart TD
  p0(["Processing"]) --> p1["Documents arrive and are reviewed — see 8 · vendors chased · appraisal and budget move to Final · FICO already known from the credit pull in Pre-Processing"]
  p1 --> q1{"Appraisal, budget and track record complete, and FICO known?"}
  q1 -->|"not yet"| p1
  q1 -->|"yes"| cr1[/"Credit finalises the loan structure from the real numbers — appraised AIV and ARV, the approved budget, FICO:<br/>final loan amount · holdback · interest reserve · rate · term · fees · UPB moves from Not Final to Final"/]
  cr1 --> e1>"Email: Internal Loan Structure Approval Request — Credit to the LO"]
  e1 --> q2{"LO approves?"}
  q2 -->|"no — revise"| cr1
  q2 -->|"yes"| e2>"Email: External Loan Structure Approval Request — CM to the client and broker"]
  e2 --> q3{"Client accepts?"}
  q3 -->|"no — revise"| cr1
  q3 -->|"yes"| s1[("Saved: the approved structure · internal and external approval date/time")]
  s1 --> e3>"Email: Setpoint Request — CM to Setpoint · review the package"]
  e3 --> tp["Everything shipped to third-party · findings come back per document — see 8 · internal review does not wait for all of them; findings are attached as they arrive"]
  tp --> g1[["Generate the Loan Summary — the IC summary — and the investor tape"]]
  g1 --> e4>"Email: Internal Final Approval — CM to Management / the internal underwriter<br/>The loan summary, the files and the third-party findings — the dry run for the investor package"]
  e4 --> s2[("Status In Review · date/time in")]
  s2 --> uw["The underwriter reviews by exception — what is wrong with the loan as a whole, not document by document"]
  uw --> q4{"Findings?"}
  q4 -->|"yes"| f1[/"Findings recorded as a numbered list, in the underwriter's own words"/]
  f1 --> s3[("Status Items Requested · date/time out")]
  s3 --> e5>"Email: Findings — to the CM and the working group · never to the client"]
  e5 --> cm1["The CM resolves each finding · every clearance carries a note · a resubmission the underwriter asked for goes straight back to the underwriter"]
  cm1 --> s2
  q4 -->|"none open"| s4[("Status Approved · date/time")]
  s4 --> q5{"Which capital partner?"}
  q5 -->|"Churchill or SCIF"| e6>"Email: Final Approval request — Client Management to the investor · the package and the investor tape"]
  q5 -->|"Fortress"| e7>"Email: Final Approval request — a principal to the investor · the package and the investor tape"]
  e6 --> s5
  e7 --> s5[("Status Investor In Review · date/time · who sent it")]
  s5 --> inv["The investor reads it in email — they never log in · staff record the reply on their behalf"]
  inv --> q6{"Investor reply"}
  q6 -->|"Items Requested · Feedback Requested"| cm2["The CM works the items · each leg stamped separately"]
  cm2 --> s5
  q6 -->|"Approved · Conditionally Approved"| s6[("Status Approved · conditions recorded · date/time")]
  s6 --> e8>"Email: Approved Terms — CM to the LO and to Closing"]
  e8 --> nx(["Stage 6 · Closing"])
  q2 -.- q12["Q12 · The request goes to the LO — is the LO the one who approves the structure?"]
  e3 -.- q11["Q11 · Documents already push to Setpoint as each is approved (31 Jul). Is the Setpoint Request a separate ask for the final report card — or does it replace the pushes?"]
  e4 -.- q13["Q13 · It goes to internal Management — which named individuals? Is this the same step as the internal underwriter's exception review? And which system role do the principals hold for the Fortress send?"]
  classDef credit fill:#bfdbfe,stroke:#1d4ed8,color:#111
  classDef cm fill:#bbf7d0,stroke:#15803d,color:#111
  classDef uw fill:#ddd6fe,stroke:#6d28d9,color:#111
  classDef tpr fill:#99f6e4,stroke:#0f766e,color:#111
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef ext fill:#fff,stroke:#6b7280,stroke-dasharray:4 3,color:#111
  classDef status fill:#111827,stroke:#111827,color:#fff
  classDef ask fill:#fef3c7,stroke:#b45309,stroke-dasharray:4 3,color:#111
  class cr1,e1 credit
  class p1,e2,e3,g1,e4,cm1,cm2,e6,e8 cm
  class uw,f1,e5,e7 uw
  class tp tpr
  class s1,s2,s3,s4,s5,s6 sys
  class inv ext
  class p0,nx status
  class q11,q12,q13 ask
```

**Who sends the Final Approval request is set per capital partner.** Today:
Client Management for Churchill and SCIF; a principal for Fortress.

**Nothing can be approved while a finding is open.** Each leg — in, out, back
in, approved — is stamped on its own.

---

## 10 · Stage 6 · Loan documents and closing

Closing owns this. The system merges everything it holds into the Lightning
Docs field set and shows it before generating anything.

```mermaid
flowchart TD
  in(["Approved Terms received"]) --> cl0[/"Closing fills the Lightning Docs field set:<br/>funding entity · borrower notice address · signatories and titles · guaranty type — full or limited recourse · guarantor marital status and notice addresses · lien position · broker license and address · loan servicer · property APN · release pricing · governing law state and county · loan number · default interest rate · I/O payments and amortization term · MERS ID · construction reserve type · Dutch or non-Dutch interest · prepayment premium · tax, insurance and PITI escrows · title report number and effective date · exceptions to be removed from title · appraisal fee · signature affidavit and AKA details"/]
  cl0 --> q1{"Capital partner approved, and every required closing field filled?"}
  q1 -->|"no — the system names what is missing"| cl0
  q1 -->|"yes"| m1["Merge · view · tweak — every value shown before anything is generated"]
  m1 --> g1[["Loan documents generated via Lightning Docs"]]
  g1 --> s1(["Docs Approved · date/time"])
  s1 --> e1>"Email: Loan Docs — Closing to Escrow"]
  e1 --> s2(["Docs Sent · date/time"])
  s2 --> sg["Documents signed at escrow"]
  sg --> s3(["Docs Signed · date/time"])
  s3 --> cc["Closing review and QC — Closing's checklist"]
  cc --> s4(["Cleared to Close · date/time"])
  cc -.- q16["Q16 · Closing's post-Lightning-Docs checklist has not reached us yet — for Jonathan"]
  s4 --> wr["Wire sent"]
  wr --> s5(["Funded · date/time"])
  s5 --> cap[/"Captured after funding: wire reference · funding date"/]
  cap --> g2[["Servicing tape generated — only once Funded"]]
  g2 --> srv["Handed to the loan servicer"]
  classDef closing fill:#fecdd3,stroke:#be123c,color:#111
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef ext fill:#fff,stroke:#6b7280,stroke-dasharray:4 3,color:#111
  classDef status fill:#111827,stroke:#111827,color:#fff
  classDef ask fill:#fef3c7,stroke:#b45309,stroke-dasharray:4 3,color:#111
  class cl0,m1,g1,e1,cc,cap,g2 closing
  class sg,wr,srv ext
  class in,s1,s2,s3,s4,s5 status
  class q16 ask
```

---

## 11 · Every communication, in order

Every send is composed from a template, addressed from the loan's own contacts,
stamped and logged. Every subject carries the property address; every footer
carries the loan number. Replies are recorded by a person.

Two emails open with a merged subject and an **empty body the sender types** —
the Internal and Investor Pre-Approval requests — because the content varies too
much to template. Everything else produces a full draft that can be edited.

```mermaid
sequenceDiagram
  autonumber
  participant LO as Loan Officer
  participant CR as Credit
  participant MG as Management / Internal UW
  participant CM as Client Management
  participant CL as Closing
  participant INV as Capital Partner
  participant CLI as Client and Broker
  participant AMC as AMC
  participant BV as Budget Vendor
  participant SP as Setpoint
  participant VN as Title / Escrow / Legal / Flood

  rect rgba(59,130,246,0.10)
  Note over LO,VN: Stage 1 · Pre-Approval
  LO->>CR: Deal submission (Outlook)
  CR->>MG: Internal Pre-Approval Request
  MG-->>CR: Reply recorded
  CR->>INV: Investor Pre-Approval Request
  INV-->>CR: Reply recorded
  CR->>LO: Loan Pre-Approved
  CR->>LO: LOI Issue
  CR->>CLI: LOI for signature
  CR->>AMC: Appraisal Order
  CR->>BV: Construction Order
  AMC-->>CR: Invoice
  CR->>CM: Appraisal invoice link
  CLI-->>CR: Signed LOI recorded
  CR->>CM: Hand-off
  end

  rect rgba(34,197,94,0.10)
  Note over LO,VN: Stage 2 · Pre-Processing
  CR->>CLI: Pre-Processing email
  CM->>CLI: Appraisal invoice
  CM->>CLI: Kick-off
  CM->>CLI: Application
  CM->>CLI: Disclosures
  CR->>CLI: Recurring Needs List
  CM->>VN: Title Kick-off
  CM->>VN: Escrow Kick-off
  CM->>VN: Legal Kick-off
  CM->>VN: Order Flood
  CM->>AMC: Trigger emails
  CM->>BV: Trigger emails
  CM->>VN: Updated closing statement
  CM->>CLI: Request LOE
  end

  rect rgba(139,92,246,0.10)
  Note over LO,VN: Stages 3–5 · Processing, Internal Review, Investor Review
  CR->>LO: Internal Loan Structure Approval Request
  LO-->>CR: Approved
  CM->>CLI: External Loan Structure Approval Request
  CLI-->>CM: Accepted
  CM->>SP: Setpoint Request
  SP-->>CM: Findings recorded
  CM->>MG: Internal Final Approval
  MG-->>CM: Findings, or Approved
  CM->>INV: Final Approval — Churchill, SCIF
  MG->>INV: Final Approval — Fortress
  INV-->>CM: Reply recorded
  CM->>LO: Approved Terms
  CM->>CL: Approved Terms
  end

  rect rgba(244,63,94,0.10)
  Note over LO,VN: Stage 6 · Closing
  CL->>VN: Loan Docs to Escrow
  end
```

**Each one, in detail**

| # | Email | From → To | Copied | When | What it carries |
|---|---|---|---|---|---|
| 1 | Deal submission | LO → Credit | | The deal arrives | Structure, write-up, valuation. In Outlook, outside the system |
| 2 | Internal Pre-Approval Request | Credit → Management | LO | Credit has refined the deal | Subject merged with the address; **body typed**; attachments. Reply recorded → Internal Approved |
| 3 | Investor Pre-Approval Request | Credit → capital partner | LO | Internal Approved | Same shape, **body typed**. Reply recorded → Pre-Approved or Not Pre-Approved |
| 4 | Loan Pre-Approved | Credit → LO | | Pre-Approved | The approved structure and terms |
| 5 | LOI Issue | Credit → LO | | The One Send | The LOI package |
| 6 | LOI for signature | Credit → Guarantor 1 | Broker, LO | The One Send | DocuSign envelope, or the PDF by hand. Short authorizations to every other guarantor via DocuSign, the LO or the Broker |
| 7 | Appraisal Order | Credit → AMC | CM, LO | The One Send | The order to the chosen AMC |
| 8 | Construction Order | Credit → budget vendor | **bcc** LO | The One Send — renovation, construction and mid-construction refi only | Scrub or Feasibility. The only bcc in the system |
| 9 | Appraisal invoice link | Credit → CM | LO | The AMC invoices | The link. Not to the client yet |
| 10 | Hand-off | Credit → Client Management | | LOI Signed | Ownership passes |
| 11 | Pre-Processing | Credit → client, broker | LO | Immediately after hand-off | Generic: pay the appraisal, budget to the vendor, schedule the inspection. Carries the invoice link |
| 12 | Appraisal invoice | CM → client | LO | After the Pre-Processing email | The invoice link → appraisal status Invoice Sent |
| 13 | Kick-off | CM → broker, Guarantor 1, every other guarantor | LO | The list is tailored | The tailored Needs List in the email, plus a personal portal link per guarantor. Switches the client's view on |
| 14 | Application | CM → each guarantor | | After kick-off | DocuSign link |
| 15 | Disclosures | CM → Guarantor 1 | | After kick-off | DocuSign link |
| 16 | Recurring Needs List | on behalf of Credit → client, broker | | On a schedule: daily at a set time, every workday, or chosen days and times each week | Everything still outstanding — documents, the unpaid invoice, the unscheduled inspection, vendor needs. Wording: Outstanding, Under Review. No due dates. Items drop off when done |
| 17 | Title Kick-off | CM → title company | | Pre-Processing | |
| 18 | Escrow Kick-off | CM → escrow company | | Pre-Processing | |
| 19 | Legal Kick-off | CM → counsel | | Pre-Processing, attorney states only | Language varies by state |
| 20 | Order Flood | CM → flood vendor | | Pre-Processing | |
| 21 | Trigger emails | automatic → AMC, budget vendor | | When a condition is met — see 7 | Invoice unpaid, inspection confirmation, needs outstanding, delivery check-in |
| 22 | Updated estimated closing statement | CM → Title | | On the task list, and any time as a one-off | Carries the loan structure |
| 23 | Request Letter of Explanation | CM → client | | Any time, one-off only | The question being asked |
| 24 | Internal Loan Structure Approval Request | Credit → LO | | Appraisal, budget and track record complete, FICO known | The final structure |
| 25 | External Loan Structure Approval Request | CM → client, broker | | LO has approved | The final structure |
| 26 | Setpoint Request | CM → Setpoint | | Structure approved | Review the package. Findings recorded per document |
| 27 | Internal Final Approval | CM → Management / internal UW | | Third-party findings in | The loan summary, the files, the third-party findings. → In Review |
| 28 | Findings | Management / UW → CM and working group | | Underwriter sends back | Numbered findings. **Never to the client.** → Items Requested |
| 29 | Final Approval request | CM → Churchill or SCIF · a principal → Fortress | | Internal Review approved | The package and the investor tape. **Who sends is set per capital partner.** Reply recorded on the investor's behalf |
| 30 | Approved Terms | CM → LO and Closing | | Investor approved | The approved terms |
| 31 | Loan Docs | Closing → Escrow | | Docs Approved | The loan documents → Docs Sent |

---

## 12 · Outside systems and how each one connects

```mermaid
flowchart LR
  os(["Spreo OS<br/>the loan record · the Needs List · every email · every stamp · Pulse"])
  ol["Outlook<br/>Every email the system sends also lands in ordinary mailboxes, wherever Dan is · replies come back here · a person records the outcome on the send · the submissions@ deal email lives here entirely"]
  ds["DocuSign<br/>The LOI to Guarantor 1 · authorizations · application · disclosures · signed status and date recorded per guarantor · a PDF-by-hand path exists beside it"]
  amc["AMC<br/>Appraisal ordered by template email · invoice link forwarded · trigger emails · report uploaded into its socket · status kept by hand — no API"]
  bv["Budget vendor<br/>Scrub or Feasibility ordered by email · draft budget and plans come from the client · trigger emails · review received, approved internally, then sent to the appraiser"]
  sp["Setpoint / offshore<br/>Setpoint Request by email · documents delivered to their folder structure · findings recorded per document in the system"]
  ld["Lightning Docs<br/>The closing field set merged from the loan · loan documents generated"]
  inv["Capital partners — Fortress · SCIF · Churchill<br/>Pre-approval and final approval by email · replies recorded · investor tape sent · Churchill also supplies a No Fly list, loaded by upload"]
  ven["Title · Escrow · Legal · Flood<br/>Kick-off and order emails to the loan's contacts · updated closing statement back from Title · loan documents to Escrow"]
  por["Borrower portal<br/>One personal link per guarantor, no password · shows only their outstanding items · uploads land as Received"]
  srv["Loan servicer<br/>Receives the servicing tape after funding"]
  os <-->|"sends · replies recorded"| ol
  os <-->|"envelopes out · signed status back"| ds
  os <-->|"order · invoice · report"| amc
  os <-->|"order · review"| bv
  os <-->|"request · findings"| sp
  os -->|"field set"| ld
  ld -->|"loan documents"| os
  os <-->|"requests · decisions · tape"| inv
  os -->|"kick-offs · orders"| ven
  ven -->|"closing statement"| os
  os <-->|"needs list · uploads"| por
  os -->|"servicing tape"| srv
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef ext fill:#fff,stroke:#6b7280,stroke-dasharray:4 3,color:#111
  class os sys
  class ol,ds,amc,bv,sp,ld,inv,ven,por,srv ext
```

**Not connected in Phase 1:** automated credit or background pulls · an API into
any AMC's system · pushing documents into Churchill's Streamline · text
messaging · an inbox inside the system · workflow configuration · AI.

---

## 13 · The borrower's side

Runs alongside from Stage 2 onward. Each guarantor gets their own link. Almost
nobody will use the portal, so the Needs List always travels in the email too.

```mermaid
flowchart TD
  pre["Before the Kick-off the portal says only: your document list is being prepared"]
  pre --> k(["Kick-off Email received — the Needs List in the email, and a personal portal link"])
  k --> view["The guarantor sees only the items that concern them — never internal items, never Spreo's review states"]
  view --> st{"Each item shows one of four states"}
  st --> o["Outstanding"]
  st --> u["Under Review — received, being actioned"]
  st --> r["Resubmission needed"]
  st --> m["More information needed — the follow-up question in plain words"]
  o --> up["Upload through the portal — add to what is there, or explicitly replace it · or reply to the email with the files attached, and Spreo staff upload them on the guarantor's behalf"]
  r --> up
  m --> up
  up --> rec[("Lands as Received on Spreo's side · the item reads Under Review")]
  sg["DocuSign envelopes arrive separately — application · disclosures · authorization"] --> rec
  rec --> mail>"The recurring Needs List email keeps listing what is still outstanding — no due dates, nothing overdue"]
  mail --> view
  classDef sys fill:#e5e7eb,stroke:#374151,color:#111
  classDef ext fill:#fff,stroke:#6b7280,stroke-dasharray:4 3,color:#111
  classDef status fill:#111827,stroke:#111827,color:#fff
  class pre,view,o,u,r,m,up,sg ext
  class rec,mail sys
  class k status
```

**No deadlines on the client's screen.** Each loan has its own delay points
outside the client's control — an entity has to exist before it can have a bank
account, and a bank account before it can have statements.

---

## 14 · Questions for Dan, in order

Each one hangs off the step it concerns in the diagrams above. Once answered,
the box comes off and the diagram is corrected; the answer is recorded here.

| Q | Where | The question | What the flowchart shows today |
|---|---|---|---|
| Q1 | §3 · before the Pre-Pre-Approval email | Guarantor names are not captured until after Pre-Approved, so the No Fly check runs after both approvals. Should the LO or Credit enter the names up front? | Names entered after Pre-Approved; No Fly runs then |
| Q2 | §3 · the One Send | Construction Order — Credit at the LOI (Sept), or the CM after signing (31 Jul)? Do the Purchase / Refi / Refi-Mid-Construction variants still stand? | Credit, at the One Send, for renovation, construction and mid-construction refi |
| Q3 | §6 · Pre-Processing email | Sent by Credit (Sept) or by the CM (31 Jul)? It carries the invoice link and the CM sends a separate invoice email — are both intended? | Credit sends it with the link; the CM sends the invoice email as well |
| Q4 | §3 · Hand-off | At LOI Issued or LOI Signed? If Issued, the invoice link has a CM to go to | LOI Signed |
| Q5 | §4 · authorizations | "One attached to LOI and other sent separately, for each guarantor" — Guarantor 1 in the packet and the others separately, or two authorizations per guarantor? | Guarantor 1 signs the packet; every other guarantor gets one short authorization |
| Q6 | §5 · Adding SF | Plans only when adding square footage — or for Heavy Reno and GUC as well? | Adding SF only |
| Q7 | §5 · permutations | Condo Map — evidence of condo map? Lot Split, ADUs, Weather Tight, Repeat Broker, Portfolio Refi — what does each add or take away? | Captured; nothing added |
| Q8 | §6 · the vendor emails | Two emails on Jonathan's sheet are not on your list — VOM and Payoff Request to the current lender on a refinance, and Appraisal Invoice Request to the AMC. Do they exist? | Neither drawn |
| Q9 | §6 · CM assigned | How is the CM chosen — by rule from the LO, from a queue, or by hand? | By hand, reassignable |
| Q10 | §6 · Kick-off | Is there a kick-off call with the client? Jonathan's sheet has a Kick-Off Call date | No call drawn |
| Q11 | §8 · §9 · Setpoint | Documents already push to Setpoint as each is approved. Is the Setpoint Request a separate ask for the final report card — or does it replace the pushes? | Both: per-document pushes in §8, one Setpoint Request in §9 |
| Q12 | §9 · structure approval | The Internal Loan Structure Approval Request goes to the LO — is the LO the one who approves the structure? | The LO approves |
| Q13 | §9 · Internal Final Approval | It goes to internal Management — which named individuals? Is this the same step as the internal underwriter's exception review? And which system role do the principals hold for the Fortress send? | One step, one role — Management / Internal UW |
| Q14 | §3 · Not Pre-Approved | A dead end — or back to Internal Approved with a different capital partner? | Dead end |
| Q15 | §1 · the journey | Eight live loans sit in Signed LOI On Hold today. Is an On Hold state needed — and at which stages? | No On Hold state |
| Q16 | §10 · Cleared to Close | Closing's post-Lightning-Docs checklist has not reached us yet — for Jonathan | A placeholder step |
