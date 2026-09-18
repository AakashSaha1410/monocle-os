# Decisions

Append-only. Every ruling that shapes the build, with its source. Newest first.

Format: **ID · date · ruling · source · consequence.**

---

### D-026 · 2026-08-09 · The reviewed Spreo design system is ported, not replaced
**Source:** Aakash. *"the client is not going to be okay to see a whole new design
system… we need to bring in that design system at this stage rather than doing it
later as it will be difficult to follow."*

The first build shipped an invented visual system. That was wrong: Dan and
Jonathan had already aligned on the Spreo OS tokens, the loan header, the widgets
and the metrics, and re-opening settled ground costs review time for nothing.

Ported verbatim: tokens (`index.css`, `tailwind.config.ts`), Geist, the control
heights, `UIButton` / `Surface` / `Modal` / `Badge` / `SegmentedControl` /
`ChipToggle` / `ProgressDonut`, the loan header with Dan's badge row, the
Quick actions dropdown, the four operating-signal widgets in their overview and
detail modes, the metrics row, and the pipeline Queue / Board views.

Also ported, and the specific gap Aakash named: the **`JourneyBar`** — six
phases, numbered, the active one ringed and pulsing with its sub-status beneath.
A phase chip alone says where the loan is now; the spine says where that sits in
the whole journey.

**Consequence:** the design system is now part of the contract. Layout
may be rearranged where Dan or Jonathan asked; tokens, components and content
are settled and are not to be redesigned.

### D-025 · 2026-08-09 · Deployed name is `Spreo-Capital-P1`
**Source:** Aakash. The Cloudflare Worker, the D1 database and the review URL all
carry this name. It is the link Aakash reviews; it does not change.

### D-001 · 2026-08-09 · The Pre-Approval status chain is replaced
**Source:** Dan's answers to open questions, Q1.

`Credit Request` and `Pre-Approval Requested` are gone. The chain is now:

```
Credit Review → Pre-Pre-Approval Requested → Internal Approved
             → Investor Approval Requested → Pre-Approved | Not Pre-Approved
             → LOI Issued → LOI Signed
```

Two approvals, not one: Dan approves internally first, then the investor.
`Not Pre-Approved` is new and terminal — Aakash raised the missing rejection path
on 2026-07-31 and it is now answered.

**Consequence:** four new statuses, two new email-composer surfaces, four new
manual mark-the-reply points.

### D-002 · 2026-08-09 · The record is created by hand, by the LO, with five fields
**Source:** Dan's answers, Q1.

The `submissions@` email carrying loan structure, write-up and valuation happens
**offline in Outlook, outside the system.** The LO then creates the record
in-system with: Full Address · Purchase or Refi · Portfolio Refi (Y/N) · Repeat
Borrower (Y/N) · Approximate Loan Amount.

**Consequence:** loan creation no longer runs the needs-list generator — there
are no permutations yet. Generation moves to Credit's permutation save. The
inbound-email-creates-record mechanism is demoted to a demo control (Q-016).

### D-003 · 2026-08-09 · Emails are composed by hand from a template shell
**Source:** Dan's answers, Q1.

Pressing a template button opens an **editable email form inside the system**:
merged subject (`Pre-Approval Request: &Address&`), a body the user types,
attachments they pick, and pre-configured recipients.

**Consequence:** templates need a `body_mode` of `composed` or `manual`, plus
attachments and recipient groups. This is not the fully-rendered template model.

### D-004 · 2026-08-09 · Internal underwrite is email-first
**Source:** Dan's answers, Q5 and Q6.

The reviewer receives a templated email with the loan summary and needed files —
explicitly *"a dry run"* for the investor package. They reply in Outlook:
approved, or a list of issues that kicks the loan back to the CM. Repeats until
approved.

**Consequence:** no in-app review workbench. A free-form issue list and
approve / send-back, with both legs timestamped. Findings never reach the client.

### D-005 · 2026-08-09 · Investor submission is a role-gated queue in the portal
**Source:** Dan's answers, Q7.

Loans sit in an `Internal Underwrite Approved` queue. Spreo Capital staff
(role-gated) send to the capital partner via template. Status becomes
`Investor Review`. The investor responds Approved, Conditionally Approved, or
Feedback Requested — repeatable.

**Overrides** Jonathan's workbook Sheet1 row 21, which said submission to the
capital partner *"will occur outside the system via email and portals."*

### D-006 · 2026-08-09 · Appraisal and budget are ordered by email from the system
**Source:** Dan's answers, Q2 — "Confirmed."

Orders are initiated by email from the system; statuses update from email
correspondence.

**Overrides** Jonathan's workbook Sheet1 row 26, which excluded *"Appraisal
Ordering and tracking via email"* from Phase 1.

### D-007 · 2026-08-09 · No AMC API integration
**Source:** Dan's answers, Q3. Where an AMC has its own ordering system, staff
update statuses manually.

### D-008 · 2026-08-09 · Phase 1 continues past Lightning Docs
**Source:** Dan's answers, Q4.

Servicer tape, wire reference and funding date are captured after loan docs are
signed. Dan is documenting the rest (Q-002).

**Consequence:** a Closing group on the Transaction tab, gated to the Closing
role. Contradicts the earlier "Phase 1 ends at loan doc generation" line.

### D-009 · 2026-08-06 · The Pipeline tab stops being an editing surface
**Source:** Jonathan/Aakash call. Jonathan: *"when I looked at the pipeline tab,
I'm seeing lending-wise here. This looks just like lending-wise."*

Pipeline data becomes a read-only, phase-aware, grouped report — the **Pulse**
tab. All editing moves into the domain tabs, filtered by phase and role.

**Consequence:** Pulse is derivative and is built **last**.

### D-010 · 2026-08-06 · Every input opens in a popup
**Source:** Jonathan/Aakash call. Long scrolling field pages were rejected;
centred modals chosen over jump-navigation. Aakash: *"keep things very simple in
the tabs. And whatever complexity arises, you click on it, and it opens up in a
pop-up."* Jonathan: *"I think the pop-ups are a good direction, because it keeps
things very contained."*

### D-011 · 2026-08-06 · LOI generation is one composite step
**Source:** Jonathan/Aakash call.

Generate LOI, adjust the document checklist (checkboxes, checked by default,
add or remove), select the AMC, and send — one action that fires **both** the
LOI and the appraisal order email. Jonathan: *"I don't see any reason to not do
it that way."*

### D-012 · 2026-08-06 · DocuSign is in Phase 1
**Source:** Jonathan/Aakash call. With download/print and manual
mark-as-sent / mark-as-signed as fallback.

### D-013 · 2026-08-06 · Credit removes documents; the CM may only add
**Source:** 2026-07-31 and 2026-08-06 calls. Dan: *"only credit can remove an
item."* A CM needing a removal emails Credit using a template — **no button.**
Dan was emphatic: *"I don't want a button… it's distracting."*

### D-014 · 2026-08-04 · No SLAs anywhere
**Source:** Dan. *"For Phase 1, I'm fairly certain we won't need this, because
the issue here is that there's really no SLAs. Everything is as soon as
possible."*

Days in status replaces due dates entirely. Nothing is ever overdue. No
escalation chains, no SLA object, no SLA reporting.

### D-015 · 2026-08-04 · The status email
**Source:** Dan. One message to the client on a schedule — Mon/Wed/Fri 08:00 by
default, configurable — listing everything outstanding in one place, including
non-document items like paying the appraisal and scheduling the inspection. No
due dates. Satisfied items simply drop off the next send.

Client-facing wording is **Under Review** and **Outstanding**. Dan rejected
"Received": *"why are you sending them a list if you're saying it's already been
received? It's kind of like it's under review."*

### D-016 · 2026-08-04 · The workflow configuration engine is Phase 2
**Source:** Dan, on seeing it: *"I see the word workflow, and that's why I didn't
think that was part of this phase."* Jonathan: *"I love this engine… but I think
we look at this as more phase two."*

Phase 1 work happens in the tabs. The process is fixed and built for Spreo.

### D-017 · 2026-08-04 · Text messaging is out; the communication hub is Phase 2
**Source:** Dan and Jonathan. Sending a text is cheap; handling the reply is not.
Dan: *"if somebody texts, they expect to text back, not email back."*

### D-018 · 2026-07-31 · Inspection is not a status
**Source:** Dan's process document §4a. It is three separate facts — scheduled,
occurred, occurred date — so a visit early or late does not rewind the order.

### D-019 · 2026-07-31 · "Flag UW docs based on findings" is retracted
**Source:** Dan, on his own written line: *"I don't even think they should flag
any UW docs. Let's just get rid of that. I think that's weird."* Internal review
is holistic, because the documents already went through third-party review.

### D-020 · 2026-07-31 · Prior evidence still goes through full review
**Source:** Dan. A document carried over from a previous loan satisfies only the
*submission*; it still runs the whole review path. *"Maybe something got missed.
You never know."*

### D-021 · 2026-07-31 · Documents append or replace, nothing is deleted
**Source:** Jonathan's bank-statement example — two of three months submitted, the
third appends rather than replaces. Superseded evidence stays in history.

### D-022 · 2026-07-31 · Guarantors 2+ get an identity-only authorization
**Source:** Dan. Guarantor 1 signs the four-page packet. Everyone after gets a
single authorization for credit and background only — **no payoff, no VOM, no
escrow.**

### D-023 · 2026-07-31 · Every email subject carries the address and a loan ID
**Source:** Dan. *"just have the address in the subject line… and then to have the
loan ID embedded in the email somewhere… that would be a really good building
block for us as we go into phase two."*

### D-024 · 2026-08-09 · Where sources conflict on scope, build it
**Source:** Aakash. *"i would rather do more than less."*

Applied to D-005, D-006, and the Pre-Approval chain, all of which Jonathan's
7.27.26 workbook excluded and Dan's later answers include.

### D-027 · 2026-08-09 · Phase gating is applied per group, not per field
**Source:** Jonathan, 2026-08-06: *"you don't have to necessarily see all the
fields that are associated with processing at that time… that's why I had the
phase column."*

Rather than hiding individual inputs, a whole **group** appears when its phase is
reached. On Transaction, Loan documents and Post-funding stay hidden until the
loan reaches Investor Review, or immediately for the Closing role. On Contacts,
title / escrow / insurance / legal / appraiser / budget vendor appear at
Pre-Processing, when their kick-off emails go out.

A group is a coherent unit of work; a half-populated group reads as broken. The
tab says on screen how many groups are hidden and why, so nothing looks missing.

### D-028 · 2026-08-09 · Pulse is read-only and names each field's home tab
**Source:** D-009, made concrete. Jonathan rejected the old Pipeline tab because
*"this looks just like lending-wise"* — a wall of editable fields.

Pulse renders the pipeline sheet for one loan, grouped and **read-only**. Every
row states which tab owns that value ("Edited on Transaction", "Calculated"), so
there is one place to change a thing and one place to read it.

Columns follow the phase, as Dan's sheet does. Where fields are not yet
applicable the tab says how many rather than hiding the fact. Once a loan is
approved the appraisal, budget, VOM, payoff and track-record groups drop away —
that work is done.

### D-029 · 2026-08-09 · The Processing gate is enforced server-side
**Source:** QA finding F1. The gate reported but did not block, while the UI and
the walkthrough both claimed it did.

`POST /api/loans/:id/status` into Processing now returns `409` with the unmet
conditions named. `override: true` still passes, because hard-block versus
advisory is Dan's call (Q-004) — but the default matches his words: *"Until that
happens, the loan stays in pre-processing."*

**Principle this establishes:** a rule the UI claims must be enforced by the API.
Hiding a button is not a rule.

### D-030 · 2026-08-09 · Review findings are a free-form list, surfaced on Transaction
**Source:** QA finding F3, resolving D-004 into a surface.

Internal and Investor review each get a group on the Transaction tab, following
the precedent in the reviewed build. Inside: raise a finding, clear one **with a
required note**, approve, or send back.

Enforced at the API: approve returns `409` while any finding is open; clearing
without a note returns `400`. Sending back moves the loan to Items Requested and
generates the numbered findings email to the CM and the working group — never to
the client.

Deliberately not per-document annotation. Jonathan: *"they're not going to
necessarily click on the guarantor application and mark that as bad. They're
going to just sort of give their diagnosis back to the CM."*

### D-031 · 2026-08-09 · Role and phase visibility live in one matrix
**Source:** QA finding F4, implementing `05-roles.md`.

`apps/web/src/access.ts` answers `access(role, surface, phase, status)` with
`none` · `read` · `edit`. Never add a role check anywhere else — add a surface
here.

Two rulings encoded beyond the plain role matrix:

- **Dan's handover.** During Pre-Approval a client manager gets `read` on the
  domain surfaces — *"literally in pre-approval, there's nothing client
  management will do."* After the LOI is signed Credit drops to `read` on the
  same surfaces, **but keeps document removal forever** (D-013).
- **The closing record** stays hidden until Investor Review unless you are
  Closing or Admin.

A read-only surface says **why** on screen rather than looking broken, and a
hidden tab is counted in a line under the tab strip so nothing looks missing.

### D-032 · 2026-08-09 · Builds typecheck first
**Source:** a duplicate JSX attribute that the bundler accepted silently and
`tsc` caught. `npm run build` now runs `tsc --noEmit` before Vite, so the same
class of defect cannot reach the deployed link.

### D-033 · 2026-08-09 · The borrower portal is a per-guarantor link, and Phase 1 scope
**Source:** QA finding F9, correcting the withdrawn F8.

Each guarantor carries a `portal_token`. The link renders on its own — no
sidebar, no role switcher, no loan number.

Three rules, all from the 2026-07-29 call:

- **Before release** the borrower sees *"your document list is being prepared"*
  and nothing else. Not the list, not a count.
- **Internal items never appear.** Dan: *"make sure that that internal document
  never shows up on the borrower portal."* Enforced in the query and again on
  submit — posting an internal item's id returns `404`.
- **Internal states never appear.** The borrower sees only *needs your attention ·
  under review · update requested · question from Spreo Capital · complete*. They
  never learn something passed Spreo review but is still with a third party.

Uploading auto-moves the item to Received and clears any prior Spreo decision,
so a resubmission genuinely re-enters review.

### D-034 · 2026-08-09 · Run loan docs is merge → view → tweak → send
**Source:** QA finding F10. Dan's final step, in his order; Jonathan's shape.

Two gates before generation: the capital partner must have approved, and
Closing's eight required fields must be populated — named individually when they
are not. Then Dan's five statuses, one step at a time, with *Docs Sent* writing
a real send to the log.

The servicing tape is step 6 and is refused before Funded.

### D-035 · 2026-08-09 · A rule the interface claims, the API refuses
**Source:** Bug B9, and the rule in `01-the-process.md` Part 4 — *"Enforce rules in
the system, not only in the interface."*

Every write now carries the acting role in an `x-spreo-role` header, and the API
checks it against the same matrix the interface uses. Hiding a button is not
enforcement: before this, a third-party reviewer could change the note rate with
one line of curl.

The matrix lives in two files that must agree — `apps/web/src/access.ts` and
`apps/api/src/auth.ts`. Add a role rule to both, never to a route.

### D-036 · 2026-08-09 · Outstanding means third-party approval, not Spreo approval
**Source:** Bug B6. Dan, 2026-07-29: *"I would have it stay till they see the
third party, because then they can maybe give a nudge if it isn't getting pushed
through."*

An item leaves the outstanding list when the **third party** approves it. Spreo
approval moves it to *With third party*, which is a visible state a client
manager can chase. The same definition drives the loan header count and the
Outstanding Item by Loan report — there is one function, `settled()`.

Two exceptions, both because they never reach a third party: information items
(B12) and internal items settle on Spreo's decision.

### D-037 · 2026-08-09 · The borrower has four states and none of them is Complete
**Source:** Bug B5, correcting D-033. Jonathan, 2026-07-28: *"They don't need to
know that something was internally approved. They don't need to know that
something was third-party approved… What they need to know is if a resubmission
is needed or an additional document is required."*

The borrower sees: **not received · submitted · resubmission needed · more
information needed**. *Complete* is gone — saying it tells them where the file
sits inside Spreo, which is the leak Jonathan was describing. Once we hold a
document it reads *submitted* and stays there until we ask for something.

D-033's list of five states, which included *complete* and *under review*, is
superseded by this.

### D-038 · 2026-08-09 · Every decision carries a note, and the note is asked for
**Source:** Bug B10. Jonathan: *"even if it's approved, there could be notes that
are important to just track that people downstream may want to know about."*

Choosing Approve, Reject or Need Additional opens a note field before anything is
recorded. Spreo's note and the third party's note are stored separately, and both
are shown back on the item.

### D-039 · 2026-08-09 · The schedule composes real emails and the triggers are evaluated
**Source:** Bugs B3 and B4.

The Mon/Wed/Fri email is built from what is actually outstanding — documents,
plus the non-document items Dan listed: paying the appraisal invoice, scheduling
the inspection, the unsigned authorizations, the escrow contact. Three headed
sections, no due dates. A loan with nothing outstanding gets no email.

The six vendor triggers have real predicates, evaluated by the same code the cron
runs. The Communications tab shows which would fire right now, and the schedule
can be run on demand rather than waited for. One of each per loan per two days —
chasing, not harassing.

### D-040 · 2026-08-09 · Prior evidence is offered, never assumed
**Source:** Bug B8. Dan, 2026-07-31: *"we just did a loan with this guy a month
ago. Oh, I already got his credit report. Credit reports are good for 90 days."*

Approved documents from another loan for the same guarantor are matched by email
and offered on the item, flagged **stale** past 90 days. Carrying one over copies
the files and clears both review decisions, so it re-enters the full path — Dan:
*"Maybe something got missed. You never know."*

The seed carries a prior funded loan, `SPR-2026-0100`, so the path is reachable
in a demo rather than theoretical.

### D-041 · 2026-08-09 · Hand-added items never retire
**Source:** found while testing B17.

Saving the permutations retires rule-generated items that nobody has touched. An
item a person added by hand is not in the catalogue, so it was being swept away
by an unrelated edit. Only rule-generated items retire now.

### D-042 · 2026-08-09 · A field update can never move a loan
**Source:** found while running the regression after D-035.

`PATCH /api/loans/:id` accepted `phase` and `status` like any other column, so
the Processing gate — the one rule Dan asked to be blocking — could be skipped
with a single field update. Phase and status now change only through
`POST /api/loans/:id/status`, which is where the gate, the audited override and
the history row live. The PATCH returns 400 and names the route to use.

### D-043 · 2026-08-10 · Email intelligence is not Phase 1
**Source:** Jonathan/Aakash call, 2026-08-10.

Jonathan opened the call expecting inbox integration in Phase 1 — Microsoft
Graph, templated sends tracked back to the loan, and replies read for their
content and mapped to fields: *"based on the context of those emails … we'd be
able to automatically, through automation, understand that's what it said in the
email, and map it to status or a field."*

Both agreed by the end that this is its own project. Aakash: *"that in itself
could be a project as complex as phase one"* — the permutations across inboxes,
the training data needed, and the way one changed variable ripples through the
whole email layer. Jonathan: *"you almost look at it as a phase 1.5 sort of
thing."*

The line drawn: **deterministic is cheap, free-form is not.** A binary
approve/reject carried on a button in a templated email, and a structured form a
vendor fills, both map one-to-one and are affordable. Reading intent out of
free-form correspondence is an engine of its own.

Phase 1 keeps: templated sends, decision buttons on the email, and replies
recorded against the loan. It does not connect to a mailbox.

This narrows **Q-027** — the question was whether staff live in the platform or
in Outlook. For Phase 1: Outlook.

### D-044 · 2026-08-10 · Quick actions read the stage registry
**Source:** Jonathan, 2026-08-10; the model settled by Aakash, 2026-08-11.

Jonathan could not find where work was started: *"where am I ordering the
budget? How am I ordering?"* and *"it should show more the current stage, not the
prior stages."* The header menu was a fixed list of seven that never changed.

It now reads `actionsFor()` in `apps/api/src/stage.ts` — the same map that
already drove the tab badges and the status tracker. One registry, three
surfaces.

Two groups and no more. **Now**: what this stage needs, filtered to what the
role can actually finish, with the first promoted out of the menu to a button
carrying its real verb. **Always**: a note, and an email.

Move-to-next-status left the menu for the tracker. It is a jump, not a task, and
putting it beside the work invited skipping the work.

### D-045 · 2026-08-10 · The demo shows the interaction, and back undoes it
**Source:** Jonathan, 2026-08-10; specified by Aakash, 2026-08-11.

The demo executed steps without showing them. Jonathan: *"it's executing the
step, but I was kind of not always clear what was actually happening on screen,
like which button."*

Three rulings, all Aakash's:

1. **Minimised is the normal state.** Three buttons dock in the sidebar and
   nothing ever covers the page: *"it should never block anything."* No
   auto-play — *"I just need the front and back options to work, really work."*
2. **Back is a real undo.** Each step photographs the loan before it runs and
   back restores it, so the same step plays again as many times as the room
   needs. Replaying from step one was not viable at the pace below.
3. **Every step performs the interaction**, slowly: scroll to the section, open
   the popup by pressing the control a person would press, fill it field by
   field, press the button, show the result land.

`demo/stage.ts` drives the real controls, found by their visible words, so no
screen had to be instrumented to become demonstrable. Where the screen path
cannot be driven the runner falls back to the API and says so — a demo being
given live must never dead-end — but never after the write has landed.

### D-046 · 2026-09-10 · A working dialog stays open; a form dialog closes
**Source:** The guided demo, steps 48 to 58, failing on the deployed link.

Every action inside the needs item and the review findings dialog was dismissing
it. A client manager who approved a document with a note was returned to the list
before they could set its routing, ask a follow-up or record the third-party
layer. A reviewer with two findings could clear the first and then had to reopen
the dialog for the second.

Two shapes, and they behave differently:

- **A form dialog** holds one input and closes when it saves — `FormModal`, add a
  contact, add an item, compose an email.
- **A working dialog** holds several independent actions on one record, and stays
  open. It refreshes in place so the state it shows is the state that came back.
  Needs item and Review findings are the two.

Only a decision that ends the stage closes a working dialog: **Approve** and
**Send back to CM** on review, and removal, which takes the record away.

The demo was written against the second behaviour a year before the screens had
it, which is what makes it the test.
