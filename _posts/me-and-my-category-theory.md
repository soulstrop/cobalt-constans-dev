---
title: Me and my Category Theory 
layout: note.liquid
is_draft: true
---
Purely as a matter of my own process, I tend to approach new software
problems by trying to get a sense of their shape.  This habit was
instilled in the early days of Design Patterns from the GoF, where it
offered a higher level of abstraction than code, or even pseudo-code
to sketch out what the problem domain looked like.  As such things go,
Design Patterns ended up being a barrier to thinking instead of an
aid, when people started to apply them to everything, sometimes
seeminigly trying to cram as many patterns into one poor program as
they could.  Instead of clarifying, the application of Design Patterns
muddied.  But I still remember that first electric shock of having
something named whose presence I had only sensed before the naming.

I had a similar feeling when I first heard about Category Theory.  All
I had known was that there some libraries, like LINQ in the .Net
world, that were a joy to use.  They had this magical property of
coherency that never forced you to leak an abstraction
to get something to work, of a consistency that never surpised you by
changing the api depending on the granularity you were working with,
and an almost lego-like ability to snap pieces together to create
larger wholes.

Later when Big Data, Hadoop and Spark motivated me to learn Scala, I
started dealing in problem domains where Functional programming wasn't
just a different approach, but a necessary one in order to deal with
complexity, I was introduced to Algebraic Data Types, and the
marvelous way that they modularity in architectures.  Lessons that
just got reinforced when architecting solutions for web scale problems
of distributed computing.  And Scala had this library called Cats.

Such a playful name for something that changed my view of programming
as much as the Standard Template Library did when it was introduced.
Such power, such expressibility, such elegance.  Such a shame that the
Scala community imploded and made it untenable as a platform.

But it was Cats that made me aware that there even was something
called Category Theory.  I have always been unable to to be satisfied
with the surface of things, I need to know the "meta", find the
organizing principles, the 2nd order effects.  I had no idea how deep
a rabbit hole I was about to dive into.

At one memorable Scala meetup from the days that companies sponsored
extravagant dinners with open bars in an attempt to get a good
reputation among engineers that were the bottleneck to making their
product dreams come true, Bartosz Milewski was the invited speaker.
And he started his talk by telling us that he knew nothing about
Scala.  And I think he might even have ended with "A monad is a monoid
in the category of endofunctors."  I was enraptured.

From there, I was attending his weekly seminar on category theory,
sponsored by the local Haskell users group.  I barely understood what
was being said, but the little that I did felt like a had taken a
wrong turn with math as an undergrad.  All that analysis to prepare me
for engineering, when it was abstract algebra that made my mind humm.
And Bartosz was putting names to the structures that were water to my
fish.

Of course, from there I got to Bartosz's book, and since you can't get
enough category theory I went looking for more.  Eugenia Cheng, Emily
Ruehle, David Spivak, Ed Wong.  The whole Topos Institure and their
now twice weekly seminar series.  John Baez coming in strong with a
compositional model for epidemiology duriong the Covid 19 pandemic.

I would not ever claim that I do Category Theory.  At most I'm a
tourist that has come to recognize landmarks, knows the well travelled
itinerary, and has enough of the local vocabulary to talk a caveman
version of the lingo.  But I have become practiced in the application
of the Category Theory to the problem domains that I encounter, and
the virtuous cycle of going back and forth between the math and the
implementation views creating a better embodied understanding of both.
