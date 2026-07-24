---
title: Somebody should still be doing it the hard way
layout: note.liquid
is_draft: false
published_date: 2026-03-08 13:41:00 -0700
tags:
  - software
  - philosophy 
description: ""
data:
  kind: note
  read_time: ""
---
It strikes me that in this day of coding agent enhanced productivity,
software teams should have someone on them that has done
things the hard way.

I'm a huge fan of coding agents.  I haven't had as much fun creating
with code since I don't remember when.  The constraint is still time, but the
tradeoffs in quality and features I have to make feels very different.
Back in the days of hand-crafted code I would inevitably feel like I
had gotten the hives there were so many itches I didn't get a chance
to scratch.  Make it: more robust! more resilient! simpler![^pascal]

Every step away from direct implementation of the code is a win.  The
productivity gains we've been promised are going to come from here,
they're going to allow us to be more ambitious, which means the world
gets more software that fits demand need.

However... that same step also leads to the implementation being a
little more opaque.  Same thing happened as we moved up abstractions
from machine code to machine language and compilers, to higher level
languages like C, to interpreted languages like python.

And at every step in that evolution, there had to be somebody on the
team deeply familier with what went on before, because when something
does not go as expected, they are the ones that are oriented to a
lower layer enough to recognize what it is.  People who only ever had
exposure to the higher layer have to rely on an academic understanding
of how things should be down there. Similar in benefits to
pair-programming, by having someone who was required to do it the hard
way, you will be building a living repository of institutional knowledge.

Doing it the hard way is what makes distinguishes being knowing from
being knowledgeable. I'll always be grateful to [Kelsey
Hightower](https://bsky.app/profile/kelseyhightower.com) for teaching
me this with [Kubernetes the hardway](https://github.com/kelseyhightower/kubernetes-the-hard-way).
It took me from demo and tutorial "knowing" to "knowledgable" enough
to be the go to guy when the k8s cluster started acting up.


[^pascal]: Blaise Pascal, *Seizième Lettre Provincial*

     > Je n'ai fait celle-cí plus longue que parce que je n'ai pas
     > eu loiser de la faire plus courte.

