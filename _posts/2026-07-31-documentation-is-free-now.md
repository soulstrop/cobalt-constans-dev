---
title: "Documentation is free now"
layout: note.liquid
published_date: 2026-07-31 08:00:00 -0700
tags:
  - ai
  - agents
  - software
  - architecture
description: "LLMs collapsed the cost of writing code. They also collapsed the cost of writing documentation. That second thing matters more."
data:
  kind: note
  read_time: "4 min"
---

The developer consensus on documentation has been stable for twenty
years: the code is the documentation, comments rot, and maintaining
a separate document set is overhead that nobody has time for and
nobody trusts anyway.  That consensus was rational when it was formed.
Writing documentation cost the same as writing code, so it competed
with code for the same scarce resource — programmer hours — and
code won, because code ships.

LLMs changed the cost of writing code.  Everybody noticed that.
What I think fewer people have noticed is that the same tools changed
the cost of writing documentation by the same amount, and that changes
what documentation is *for*.

When documentation is expensive, it has to justify itself against the
code it displaces.  It rarely can.  When documentation is effectively
free to produce and free to maintain — because an agent can rewrite a
roadmap or an ADR as a side effect of the commit that invalidated it —
the economics flip.  Documentation stops being overhead and starts
being infrastructure.

Specifically, it becomes three things.

**It is the memory your collaborator does not have.** A coding agent
starts every session cold.  It has the repository and nothing else — no
recollection of yesterday's reasoning, no sense of which decisions are
settled.  Every convention it needs has to be in the repo, in the place
it will look.  This is not a hypothetical: I have watched a glossary
entry that lacked the reason a name was rejected get re-proposed within a
week, and a deferred finding that lived only in a gitignored handoff
vanish when the handoff was deleted.  Context that is not written down
does not exist, for an agent or for a new hire six months from now.

**It eliminates duplicative inference costs.**  Every time an agent
re-derives a convention, or re-discovers a constraint, or re-argues a
settled decision, that is tokens spent producing knowledge that already
existed in someone's head but not in the repository.  A design-notes
file that captures the rule "make the door refuse, rather than writing
down a convention" saves every future session from re-learning it by
getting it wrong.  Thirty-one ADRs with "reconsider this if" clauses
stop thirty-one decisions from being relitigated from scratch by someone
— human or agent — with no memory of settling them.

**It keeps the project legible to everyone who is not the code.**
Stakeholders, maintainers, future builders, the regulatory person who
needs to understand what the system *claims* to do — these are people
for whom the code is not, in fact, the documentation, and never was.
They need the roadmap, the architecture document, the glossary.  Those
documents used to be stale within a quarter.  An agent that rewrites
the plan as a side effect of finishing each unit of work keeps them
true by construction.

I have been experimenting with what this looks like in practice —
a small document set where each document has one job, they
cross-reference rather than repeat, and the cross-references are
checked mechanically.  The methodology is built around an eight-step
loop where the last step, the one that runs after the work feels
finished, is the one that folds what the work taught back into the
plan that remains.  It is the hardest step to do and the easiest to
skip, and everything in the document set that stays short is short
because that step ran.

I wrote it up as a whitepaper: [The document set as
infrastructure](/writing/the-document-set-as-infrastructure/).  The
short version is that the filing cost we used to refuse to pay is now
the collaboration's operating cost, and the side effect — a project
that a new contributor can enter cold — may be the more durable
benefit.
