---
layout: whitepaper.liquid
title: "The Document Set as Infrastructure"
published_date: 2026-07-31 08:00:00 -0700
tags:
  - ai
  - agents
  - architecture
  - software
description: "When documentation is free to write and free to maintain, it stops being overhead and becomes the coordination substrate for agent-era development."
data:
  kind: whitepaper
  subtitle: "How free documentation changes what documentation is for."
  version: "0.1"
  author: "J. Michael Constans"
  pages: "12 min · ~2,800 words"
  epigraph: "Context that is not written down does not exist."
  epigraph_attr: "the lesson that keeps paying"
  watermark: "draft"
---
<p class="lede">Large language models collapsed the cost of writing code. Everybody noticed. The same tools collapsed the cost of writing documentation by the same amount. Fewer people noticed, because maintaining documentation still <em>feels</em> like overhead — the professional habit of treating it as a tax on the real work is older than most of the people doing the work. But when the cost falls to zero, the economics invert, and documentation becomes something it was never economical enough to be: the coordination substrate for a project built by cheap, memoryless agents and the institutional memory that lets it survive them.</p>

This paper describes a method learned by doing it — one project, one developer, one coding agent, five days of building<span class="sn-ref"></span><span class="sidenote">The numbers: 92 commits, ~20k lines of source, ~13.5k of tests, ~11.3k lines of documentation, 31 architectural decision records, 15 journey documents, and a 234-line glossary that includes rejected names and the reasons they were rejected. The documentation-to-source ratio is roughly 1:2, and that ratio has been affordable. Whether it stays affordable at three times the scale is unknown.</span>. What follows is not a methodology; it is a record, and the parts that are genuinely portable will not be obvious until a second project exists to compare against. I offer it as a case for a hypothesis: that the document set, properly structured, is not a side effect of the work but the mechanism that makes the work composable across sessions, agents, and people.

## The hypothesis

The developer consensus on documentation has been stable for a generation.  The code is the documentation.  Comments rot.  Maintaining a separate document set is overhead that competes with shipping for the same scarce resource — programmer hours — and shipping wins.

That consensus was rational when it was formed.  Writing a page of documentation cost roughly what writing a page of code cost, and the documentation depreciated faster.  But LLMs changed both costs by the same factor, and the depreciation problem is tractable now too — an agent can rewrite a roadmap or an architecture document as a side effect of the commit that invalidated it.  The filing cost that was never worth paying is now a rounding error, and what it buys is no longer a luxury.

Specifically, a maintained document set does four things that the code alone cannot:

1. **It eliminates duplicative inference costs.** Every time an agent re-derives a convention, re-discovers a constraint, or re-argues a settled decision, that is tokens spent producing knowledge that already existed in someone's head but not in the repository.  At current pricing that is a minor cost; at the scale of a team running dozens of agent sessions a day it compounds<span class="sn-ref"></span><span class="sidenote">The compounding is not mainly financial. It is attentional. A human reviewing agent output burns the same minutes whether the output is novel or re-derived, and the re-derived version is subtly more dangerous because it can arrive at a different conclusion from the original, silently.</span>.

2. **It substitutes written memory for cognitive memory.** A human developer holds conventions, settled decisions, and rejected alternatives in their head.  An agent cannot.  A document set that captures these is the price of the collaboration — and the side effect is a project that a new *human* contributor can also enter cold.

3. **It creates checkable interfaces between sessions.** Cross-references between documents can be verified mechanically.  A roadmap that names a journey, a journey that cites a design note, a design note that references an ADR — each link is an assertion that the documents are talking about the same system.  A link checker is a cheap, total integrity test on the documentation surface<span class="sn-ref"></span><span class="sidenote">The project this paper draws from runs <code>mise run links</code> as part of its gate. A renamed heading breaks every document that cites it, and the failure is immediate. This is the documentation equivalent of a type system — it catches a class of structural error that prose review cannot.</span>.

4. **It keeps the project legible to everyone who is not the code.** Stakeholders, regulators, maintainers, the person who inherits the project two years from now — for all of them, the code is not, in fact, the documentation, and never was.

## The method: one journey at a time

The unit of implementation is the *journey* — one actor completing one goal end to end.  "An admin opens a bid cycle, seniority is frozen, wave 1 is notified."  Building it means touching the domain, the schema, the persistence layer, the routes, and the templates in one pass.

The alternative — build all the models, then all the repositories, then all the routes — produces layers that have never met.  Nothing is demonstrable until the last layer lands, and every integration problem arrives at once, at the end<span class="sn-ref"></span><span class="sidenote">The project that grounded this had a domain lock reached from three unrelated route modules, whose hard cases — per-row rejection for imports, checking expanded pattern dates rather than typed ranges — only appeared when the rule and its three callers were built together. That lock could not have been designed layer-first.</span>.

Each journey follows an eight-step loop:

1. Write the journey document — actor, precondition, steps, outcome, edge cases
2. Write the failing end-to-end test.  **This is the definition of done**
3. Red-green-refactor inward: domain, then persistence, then API, then UI
4. Accessibility assertions inside the same E2E
5. **Deploy**
6. Simplification pass, then redeploy
7. Update the architecture document; write ADRs for anything significant
8. **Fold what the journey taught into the plan that is left**

Steps 5 and 6 are in that order deliberately.  They were the other way round until the first journey ran them both.  Deploying asks questions the source tree cannot: which credential does this process actually use, what is in the artifact, what happens on a restart.  A simplification pass before the deploy found the route surface.  The same pass *after* it found a configuration fallback that let the application connect as the schema owner, and a module-level application instance doing I/O at import time in every test process.  Neither was visible from the code alone, because neither is wrong until something outside the repository has an opinion<span class="sn-ref"></span><span class="sidenote">The corollary: deploy every journey, not every release. The packaging cost of a journey is paid in the journey that introduced it. The first deploy found that database migrations were not in the package at all — a release-level deploy would have discovered this much later, and at much higher cost.</span>.

Step 8 is the load-bearing step.  It is also the easiest to skip, because it happens after the work feels finished and produces nothing demonstrable.  But it is the step that keeps the plan a plan.  The journey is complete; what it changed about the *unbuilt* work is not written down anywhere yet.  Step 8 routes each durable thing to where it will be read, and then **rewrites** the affected parts of the plan rather than appending notes about what changed.

The test of a finished step 8: a reader who has never seen the previous version cannot tell which parts changed.

Running it for the first time — retroactively, over a completed journey — produced six changes across three documents, and the most valuable was not a lesson but a contradiction: a lock built in one journey silently conflicted with a decision recorded in an ADR for a later one.  That was invisible from inside the finished journey and only appeared when looking forward.  The question step 8 asks is not "what did we learn" but **"what does this make false elsewhere"**<span class="sn-ref"></span><span class="sidenote">This is why the step demands <em>rewriting</em> rather than <em>annotating</em>. An annotation that says "this used to be true" is history, and history belongs in <code>git log</code>. The plan must say what is now known, not what was once assumed.</span>.

## The document set as a system

Each document has one job.  They cross-reference rather than repeat.  The cross-references are checked mechanically.

| Document | Its one job | Explicitly does *not* contain |
|---|---|---|
| README | What the system is, how to run it | Design rationale, journey detail |
| Roadmap | What is left to build | History, completed work |
| Journey docs | What each screen must do | Architecture, UI specifics |
| Architecture | Components, responsibilities, how they relate | Decision rationale — that goes in ADRs |
| ADRs | One architecturally significant decision each | Anything not architecturally significant |
| Glossary | The domain language, including rejected names | Anything that is not a word in active use |
| Design notes | Rules learned by getting them wrong | Narrative — the story lives in git |
| CLAUDE.md | The conventions a coding agent needs | Anything a person would not also want |

**Where a thing goes** is answered as an ordered question: Is it architecturally significant? → ADR.  A rule worth having before writing similar code? → Design notes.  A word, or a word you nearly used? → Glossary.  Changes what is left to build? → Roadmap, by rewriting it.  Must change how the next change is made? → CLAUDE.md.

History is `git log`.  Nothing in the committed document set is a record of what used to be true.

### The three failure modes

All three happened in the project that informed this paper.

**Documents accumulate history unless something forces rewriting.** The roadmap grew a findings section per journey and reached over two thousand lines, half of it retrospective.  Someone looking for the next step read a thousand lines of completed work first.  The fix was distilling the rules into a design-notes document and deleting the narrative.  The reason it grew is simply that appending is easier than revising, which is why step 8 now names rewriting as the requirement<span class="sn-ref"></span><span class="sidenote">This is also why "the code is the documentation" persists as a norm. Appending nothing — treating the code as self-documenting — is even easier than appending, and the cost is invisible until someone who is not the author needs to understand the project.</span>.

**A document with no stated job collects everything unfiled.**  The handoff document was the only one without a defined purpose, so anything that fitted nowhere landed there.  Two consciously-deferred findings, with their reasoning, existed nowhere else and were one `rm` from being lost.

**A threshold nothing measures only gets crossed.**  An ADR named ~600 lines as the signal to split a module.  One module was flagged by hand at 707 and reached 1,078 unnoticed, with two others also over.  A number in prose is not a check.

### The residue test

Write the handoff at the end of a unit of work.  Whatever you find yourself typing that is not already somewhere is, by definition, something with no home.  Then ask which kind it is:

- **Knowledge** — it should have been routed. The handoff caught a miss.
- **Checkable state** — a document is the wrong fix. Make a task refuse.
- **Neither** — an unanticipated kind of residue means a document is missing a job, or a category is wrong. That is information about the system, not a filing problem.

## Designed for a collaborator with no memory

This is the part most specific to building with a coding agent, and it explains practices that would otherwise look like overhead.

The agent starts every session cold.  It has the repository and nothing else — no recollection of yesterday's reasoning, no sense of which decisions are settled, no memory of the thing that was tried and abandoned.  Everything it needs has to be *in the repository, in the place it will look*.

That single constraint produces most of this method:

| Practice | What it is really for |
|---|---|
| CLAUDE.md | Conventions, loaded every session, so they do not have to be re-derived or re-argued |
| ADRs with "reconsider this if" | Stops settled decisions being relitigated from scratch by someone with no memory of settling them |
| The glossary, with rejected names | A name turned down without its reason gets re-proposed within a week |
| Journey documents | The specification survives the session that wrote it |
| The handoff | The current unit's state, for a resume that starts from zero |
| Lesson: commit trailers | Capture at the moment of insight, because the insight will not survive the session |
| Dense docstrings carrying *why* | The reasoning is where the code is, which is the only place it is certain to be read |

A human developer holds most of this in their head and pays no filing cost.  An agent cannot, so the filing cost is the price of the collaboration<span class="sn-ref"></span><span class="sidenote">The filing cost here — step 7 and step 8 of the loop, plus the handoff — runs about fifteen minutes per journey in agent time and two or three minutes of human review. Against the three to six hours each journey takes to build, it is a small fraction. Whether it stays small at scale is not yet known.</span>.  The side effect is a project that a new human contributor can also enter cold.  That side effect may be the more durable benefit; it has not been tested here.

The corollary is that context which is not written down does not exist.  A decision made in conversation and not committed is gone.  This is why step 8 routes rather than remembers, and why the handoff is a document rather than a habit.

## What is untested, and what I would watch

**Portability.** Everything here was learned on one project.  The parts that generalize and the parts that are idiosyncratic are not yet distinguishable.

**Whether the documentation cost scales.** ~11k lines of documentation against ~20k of source is a high ratio.  It has been affordable because each document has one job and step 8 keeps them from growing history.  Whether that holds at three times the size is unknown.

**Whether the loop survives a team.** Everything here assumes one developer plus an agent, and a linear history committed straight to the main branch.  Concurrent journeys, review, and merge conflicts in the documentation set are all untested.

**Whether cheap documentation stays cheap as the floor rises.** Not every project needs this method.  It sits above the size of project you can hand to a frontier model and say "make me one of these" — and then "try again" if it is not quite right.  That floor keeps rising.  The method will have to keep changing to justify its overhead against simply regenerating.  It is convenient that the tools are good at maintaining the method too.

**The thing I would watch first:** step 8.  It is the load-bearing step and also the easiest to skip, because it happens after the work feels finished and produces nothing demonstrable.  Everything short in this document set is short because step 8 ran.  The first time it is skipped, the plan starts accumulating again — and that is slow enough that nobody notices for several journeys.
