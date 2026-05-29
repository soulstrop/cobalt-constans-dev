---
title: My current architecture methodology
layout: whitepaper.liquid
published_date: 2026-05-29 14:58:00 -0800
tags:
    - architecture
    - ai
    - agents 
    - philosophy 
data: 
    kind: whitepaper
    watermark: draft 
    description: "In a volatile world building software, this is a
statement of what I think are best practices.  At least for today."
    subtitle: "What me worry?  I'm an architect."
    version: "0.1"
    author: "J. Michael Constans"
    pages: "15 min · ~1,500 words"
    epigraph: "You, yes you, are relevant."
    epigraph_attr: "ai carreer coach"
    watermark: "rough draft"
---
## Architecture? Er...
Architecture is one of those words that means different things to
different people, and carries different emotional valence according to
the a person's history with people that called themselves architects,
or with groups called `architecture team'.  All of the definitions I've
heard carry truth, but the only one that struck me as universally
applicable was "architecture is what everybody contributing to the
project needs to know."

Of course you can nitpick the "everybody", but the spirit is that the
software contributers all need to have a shared understanding of
project in order to, at a minimum, not step on each others toes.  So,
for example, everyone knows the source control system and associated
conventions.  Everybody knows how the project is to be deployed, and
what classes of users are going to be using it.  Everyone will know
the big picture separation of concerns, e.g., front end/back end/db.
If applicable, everybody needs to know the scaling method being used
on each tier.

Off the top of my head, that is the minimum set of things that
"everyone" needs to know, so my contention is that it all belongs in
the architecture.  If there is a change to any of it, everybody needs
to update their picture of how the piece they are working on relates
to the architecture as a whole and what the delta to be reconciled
will be.

Of course real architectures will contain a lot more than the minimum,
but I'm leery of universalizing everything else.  However, some very
common elements are the CI/CD process, monolith/REST as default
design, the domain boundaries in the sense of Evans' Domain Driven
Design, the chosen implementation languages and frameworks that are
going to be used within given domains, the data layer, the semantic
layer, the consistency and latency guarantees, etc, etc.

## What do I do now?
When I am brought onto a project, my first order of business is to get
as much context for the project as I can.  What context contains is
always project dependent.  Is it a greenfield project?  Is it a
genesis project?  An expand or exploit project?  The answer directs my
research efforts.

But to make sense of the answers, I also need to know about the
business that the project is a part of.  The best tool I have found
for this is to start Wardley mapping.  The process of creating one is
a great way to start having conversations that psychologically
sidestep egos.  If you are asking someone what they do and why, it is
impossible for them to factor in a large dose of proof that they and
what they do are vital to the business, which politically is an
excellent response and a valuable skill, but for getting a picture of
what is happening it just roils up the waters making it difficult to
see.

If you shift the discussion to a map and its accuracy, I have found
that the tone is completely different.  A person isn't being asked to
defend their work, they are being consulted as an expert.  And even if
their viewpoints are biased by politics, at least they aren't muddying
the waters quite so much.  You can make so many Wardley maps: 
- the business as a whole in the territory of the market 
- a division or department in the territory of the business
- a team in the territory of the department, or an IC on the team.
Even if not definitive, or even completely accurate, the process of
creating them gets you a multidimensional sense of the context, and
soaks you in the vernacular.

Most saliently, it gives you the context in which the project you are
working on exists.

## In a green field
This is the less common case, and I have to contain my temptation to
throw all the shiny new things at it.  Instead, the first order of
business is to the get a sense of the shape of the project, how its
borders define it, the constraints under which it has to operate
(speed, lag, resources, capability).  Only then can you start
proposing stack pieces to fit the problem space.  Your first choice
should always be for the known, reliable and boring.  Anything else
has to have an articularable benefit that outweighs the additional
risk that it brings.

It can be that the tech solves a particular problem, or the tech
provides measurable business value.  Brings down costs, accellerates
cadence, attracts needed new employees, ... so many possibilities.
Although the risk they need to outweigh isn't easy to measure, the
exercise of figuring it out will be good for the architecture
regardless.

## In a brown field 
You are either there to alleviate pain, or to bash a legacy investment
into a shape that is more suitable to the current landscape.  Today's
LLM assissted world is the best it has ever been to come in cold to an
existing codebase.  But hopefully that will be a supplementary
resource.  The gold is in the institutional knowledge that the people
that have worked on it have.

So step one is to do a round of interviews and find out what the pain
points are.  What is hard?  What is slow?  Where are the skeletons?
Where there be dragons?  A bonus from this activity is that, as an
architect, the quickest way to get credibility on a new team is get
some quick wins from addressing what you have found out.  Not that you
are doing anything anybody else couldn't do, but during onboarding,
you are given the time and have the bandwidth to meaningfully
concentrate on one thing and fix/solve it.

Credibility is the cornersone of trust between the architect and the
team(s) they serve.  Which reminds me, architecture groups are best
positioned as service teams instead of "higher level deciders".
Functionally they will be doing exactly the same thing, but
relationships with other teams will be so much better if they see you
as another resource they can draw on, instead as the source of even
more work than they already have.

# It's going to be different 
I have had my "Deep Blue" moment.  I've gone from using coding
assistans accompanied by a steady stream of invective at the way they
were interfering with my intent, to trusting them with well defined
bounded problems, to collaborating in formulating the well defined
bounded problems, to leading swarms of agents coding to an issue
tracker, to setting up software factories using agents to closely
model the best practices of software engineering teams, to a moment
when it dawned on me that I was clearly the bottleneck.  Just like
when Kasparov lost to Deep Blue in chess, it became clear that the
coding assistants will soon be much better at coding than I have ever
been, if they aren't already.

This has implications that software development teams are still trying
to figure out.  The entire history of these teams is geared towards
creating code.  And it was the code that was teh reification of the
value created.  It has always been prohibitiley expensive to rewrite
working code, and the industry is littered with the corpses of
products whose first sign of doom was an announcement that the next
version would be a complete rewrite.

But now? Complete rewrites are trivial at nearly all scales.  Working
code presents a surface that can be treated abstractly by the coding
LLM who can then write code to exactly replicate it using whatever
constraints you want to impose on it. ("I want it to work like this,
but implement it in Rust.")  So the value of the code that is created is on a
steep dive towards an asmptote of zero.  And it is always going to be
cheaper to hit the "try again" button than to try and retrofit a new
realization to the existing code.  "Legacy code" is now everything
that you have written.

So where do we put our attention as context providers.  See my
whitepaper on "The unreasonable effectiveness of Category Theory for
preventing Drifts" for one answer.


