---
layout: note.liquid
title: "The Unreasonable Effectiveness of Category Theory in Preventing LLM Drift"
published_date: 2026-05-25 12:00:00 -0500
tags:
  - ai
  - agents
  - philosophy
description: "Can Category Theory tame the &ldquo;AI slop&rdquo; that coding agents produce? We pressure-test the thesis that a CT-derived skeleton lets an LLM iterate toward production code while catching intent drift at checkpoints—and found the surprising answer is yes, but not for the reason you'd think. The win comes from forcing humans to make intent explicit in an executable Haskell oracle, not from the LLM reasoning over abstraction—plus where this pipeline quietly leaks slop back in."
data:
  kind: note
  read_time: "15 min"
---

With apologies to Eugene Wigner...

## My thesis
Expressing the shape of a software architecture solution for a problem
domain using Category Theory creates a skeleton upon which an LLM
coding assistant can iterate towards an implementation and detect and
eliminate intent drift more efficiently and effectively, producing
codebases that are more legible and contain far less "AI Slop".


## Evidence supporting the thesis
The architectural half of your claim rests on solid, decades-old
ground. Category theory has been used to formalize software structure
since Goguen's "categorical manifesto," with Fiadeiro's work giving
rigorous mathematical semantics to architectural connectors and the
box-and-line decomposition of systems into components, and Diskin and
Maibaum framing CT as "arrow thinking" — a toolbox of structural
design patterns and guiding principles for model-driven engineering.
More recent compositional-systems work (Censi, Zardini, Bakirtzis,
Spivak) shows the approach scaling to real co-design of
hardware/software systems. So the premise that architecture can be
expressed categorically is well-established.<br> 
[Theory and Practice of Software Architecture](http://www.cs.ox.ac.uk/research/pdt/ap/ssgp/slides/fiadeiro.pdf)<br>
[Category Theory and Model-Driven Engineering](https://arxiv.org/pdf/1209.1433)


The LLM half is where the recent and most relevant evidence lives, and
 it's encouraging for the spirit of my thesis. The strongest single
 data point: in a 2025 study on type-constrained generation, on
 average 94% of compilation errors stem from failing type checks, and
 constraining the model's decoding with the type system measurably
 improves well-typedness. The mechanism that keeps recurring is
 entropy reduction — a structured specification collapses the LLM's
 option space. One practitioner framing puts it starkly: vague types
 leave millions of valid-but-wrong implementations, whereas precise
 types reduce the space to under a thousand, with type errors
 immediately flagging invalid approaches and guiding the model toward
 correct solutions. The spec-driven-generation papers say the same
 thing in formal terms: symbolic-execution-guided specs work by
 structurally constraining the LLM's output space, significantly
 reducing hallucinations and syntactic errors, and multi-agent
 frameworks like ReDeFo use formal specifications to bridge the gap
 between ambiguous natural language requirements and precise
 executable code, enabling rigorous reasoning about correctness.<br>
[Type-Constrained Code Generation with Language Models](https://arxiv.org/pdf/2504.09246)<br>
[Type-Driven Development: Specifications Over Implementation](https://understandingdata.com/posts/type-driven-development/)<br>
[Integrating Symbolic Execution with LLMs for Automated Generation of
 Program Specifications](https://arxiv.org/abs/2506.09550)<br>
[Requirements Development and Formalization for Reliable Code Generation: A Multi-Agent Vision]( https://arxiv.org/pdf/2508.18675)
 
The "intent drift" intuition is also empirically real and addressable.
 Drift is now a named failure mode — the model gradually loses track
 of original intent over a session, introducing logic that wasn't in
 the spec — and the MAST taxonomy (a NeurIPS 2025 spotlight over
 1,600+ traces) attributes a large share of multi-agent failures to
 requirement/specification drift, which "living specifications" are
 claimed to mitigate. SpecRover demonstrates the corrective loop
 directly: inferring intent as an explicit specification and having a
 reviewer agent vet patches against it yielded more than 50%
 improvement in efficacy over its predecessor on SWE-Bench. That's the
 closest existing analog to your "skeleton catches drift" claim.<br>
[Keeping AI Programmers on Track: Minimizing Context Drift in
 LLM-Assisted Workflows](https://leonas5555.github.io/ai-tech-site/articles/v1-llm-context-drift/)<br>
[SpecRover: Code Intent Extraction via LLMs](https://arxiv.org/pdf/2408.02232)

## Evidence undermining the theses
The trouble is that almost none of this evidence implicates Category
Theory as the medium. What's been shown to work is types, contracts,
tests, and lightweight formal specs. CT is one route to a clean
compositional structure, but its payoff to an LLM arrives through its
shadow — the type signatures and interface laws — not through
categorical vocabulary. A thesis that says "express the architecture
categorically" may be claiming credit for work that ordinary good
types already do.

Worse, there's direct evidence that LLMs reason poorly over abstract
 formalism, which attacks the core premise that a categorical skeleton
 is a representation the model can fluently iterate against. In a
 study of LLMs as abstract interpreters, models facing abstract
 reasoning retreated into ambiguous natural language to describe
 abstract state updates instead of specifying the concrete operations
 the formalism required. A 2026 review notes that despite the surface
 parallel between code and proof, formalized mathematics has proven
 significantly more challenging for LLMs than coding, with performance
 degrading sharply when problems require depth and precision, and
 abstraction gaps persist even with chain-of-thought. There's also a
 distributional problem you can infer from this body of work: heavily
 categorical code (Haskell with deep abstractions, Idris, Lean) is
 rare in training data, so a CT skeleton risks being out of
 distribution — making the model less fluent, not more.<br> 
[Understanding Formal Reasoning Failures in LLMs as Abstract Interpreters](https://arxiv.org/abs/2503.12686v2)<br>
[Thinking Machines: Mathematical Reasoning in the Age of LLMs](https://www.mdpi.com/2504-2289/10/1/38)

Finally, your "more legible, less slop" claim cuts both ways. The
accessibility critique of CT is long-standing and comes from inside
the tent. Milewski himself acknowledges the nagging worry that the
concepts are too abstract for the setting, thrown around gratuitously,
and that highly abstract language can obfuscate a solution more than
illuminate it, and SIGPLAN's teaching retrospective concedes CT works
at an extremely high level of generality, layering abstraction on
abstraction, where good grounding examples are genuinely hard to find.
A skeleton only improves legibility if the humans maintaining it are
fluent in it; otherwise it adds a layer of slop of a more rarefied
kind.<br>
[Bartosz Milewski's Programming Café](https://bartoszmilewski.com/2014/10/28/category-theory-for-programmers-the-preface/)<br> 
[Theory and Practice of Software Architecture](http://www.cs.ox.ac.uk/research/pdt/ap/ssgp/slides/fiadeiro.pdf)<br>
[Category Theory and Model-Driven Engineering](https://arxiv.org/pdf/1209.1433)

##  Evaluation
I think your thesis is right in its weak form and unsupported (partly contradicted) in its strong form.
The weak form — *a precise, compositional specification skeleton, kept
external to the prose, lowers the LLM's output entropy and gives a
stable oracle against which intent drift is detected and corrected* —
is well-evidenced. That's the consistent finding across
type-constrained decoding, spec2code, ReDeFo, and SpecRover. If that's
what you mean, build it; you'll get cleaner code and less drift.

The strong form — *Category Theory specifically is the right
expressive medium, and an LLM iterates better against a categorical
skeleton than against alternatives* — I'd bet against on current
evidence. The active ingredient is a low-entropy constraint surface
plus a mechanical checker (compiler, type system, property tests,
verifier). CT is a fine *human* discipline for *deriving* such a
surface — its emphasis on composition and interface laws is exactly
what produces good decomposition — but the artifact the model should
consume is the projection of that thinking into types, contracts, and
executable tests, not the categorical diagrams themselves. Use CT to
think; hand the LLM the types. 

A genuinely testable prediction falls out of this: take a fixed
problem, give one cohort an LLM with a rich typed/contract skeleton
derived via categorical reasoning but expressed as ordinary
types+tests, and another the same skeleton expressed in explicit
categorical terms (functor/monad/natural-transformation framing in the
prompt). My expectation is the two perform similarly on correctness
and drift, with the explicit-CT cohort possibly worse on
legibility-to-reviewers. If the CT framing wins on a held-out drift
metric, that would be the real evidence your strong thesis needs — and
as far as I can find, nobody has run that experiment yet. That gap is,
honestly, the most interesting thing here.

## Rescuing the thesis in light of research
My sense is that it is more about clarity of intent being communicated
than llms being better at reasoning over abstract formalism.  You
mention that the effect may result from forcing the human to clarify
intent being communicated rather than the llm being able to better
reason over the abstraction.


My current architectural method is to explore the shape of the
solution being expressed through study of the problem domain.  Then
take the Category Theory produced and implement it in Haskell to give
it the rigor of compile time proof.  And it is from the Haskell
expression of the solution that an LLM can create the ultimate
solution in a programming language suitable for production deployment,
while minimizing drift and creation of slop by correcting drift at
regular checkpoints using the Haskell.  If the llm encounters a
challenge that is not expressed in the Category Theory, it can better
recognize that and signal that further thinking is required from the
human in the loop.

## Evaluating the update
Your reframe is the right one, and the underspecification literature
basically confirms it. The cleanest evidence that the mechanism is
human-side intent clarification rather than LLM-side abstraction
reasoning comes from a 2025 study finding that models fill an
unspecified requirement only about 41% of the time, and do so
inconsistently — a requirement one model version handles well, the
next version can degrade on by more than 20%. If the model reliably
reconstructed missing intent, forcing yourself to pin it down up front
would buy little. It doesn't, so the act of making intent explicit and
external is where the value lives. That's your hypothesis, vindicated.<br>
[What Prompts Don't Say](https://arxiv.org/pdf/2505.13360)


Your CT→Haskell→production pipeline also lands close to where the
hybrid-workflow research is independently converging. On the
translation step specifically: SpecTra shows that generating
invariants, tests, and descriptions from a program and feeding them
alongside the source improves cross-language translation by up to 10
absolute points and 23% relative across four LLMs on C-to-Rust and
C-to-Go. A recent position paper makes your high-assurance argument
almost verbatim — that plausibility isn't enough and LLMs alone cannot
satisfy correctness obligations, so formal reasoning tools must
constrain, guide, and certify translation both during and after
generation. Your Haskell artifact is exactly such a constraining
oracle. The caveat from the same literature: even the best models
fully translate only roughly half of samples in benchmarks, so the
oracle helps but doesn't close the gap — which means you want a
runtime equivalence check between the Haskell reference and the
production output (differential testing on shared inputs,
TRACE-style), not just a checkpoint where you read the diff and nod.<br>
[SPECTRA: Enhancing the Code Translation Ability of Language Models by
Generating Multi-Modal Specifications](https://arxiv.org/abs/2405.18574v1)<br>
[LLM-Based Code Translation Needs Formal Compositional Reasoning](https://openreview.net/forum?id=wGj8LU2EOf)

Now two places I'd push, because they're where the method is weaker
than it sounds.

First, "compile-time proof" overstates what vanilla Haskell gives you.
Haskell's type system pins down shape and whatever invariants you
bother to lift into the types, but it isn't total — partial functions,
bottom, non-termination, and effects sliding through IO all mean a
well-typed Haskell program is not a proved-correct one. Genuine
compile-time proof is Idris/Agda/Lean territory, or Haskell pushed
hard with GADTs, refinement types (Liquid Haskell), or dependent-ish
encodings. This matters concretely for your drift oracle: the LLM's
production code can only be checked against intent to the degree that
intent actually lives in the signatures. If a lot of it lives in
function bodies, the Haskell catches less drift than you're hoping,
and slop re-enters through the under-specified parts. The fix is to
deliberately migrate intent up into types and property tests
(QuickCheck/Hedgehog) so the checkpoint has more to bite on — the
strength of the checkpoint is the strength of what the types encode.

Second, the gap-recognition claim — the LLM noticing "this isn't
 covered by the CT" and escalating to you — is the most optimistic
 part, and unprompted it's poorly supported. AbstentionBench reports
 that state-of-the-art models, including reasoning-tuned ones, fail to
 abstain on unanswerable questions, possibly from a fundamental
 inability to reason about uncertainty; the Ambig-SWE work finds
 models struggle to distinguish well-specified from underspecified
 instructions; and there's a documented "hallucination tax" where
 RL-tuned models invent missing constraints and answer with high
 confidence when queries omit necessary conditions, traced partly to
 reward structures that incentivize guessing over abstention. So a
 model running on vibes will tend to confabulate plausible filler for
 the uncovered case rather than flag it.<br>
[AbstentionBench: Reasoning LLMs Fail on Unanswerable Questions](https://arxiv.org/pdf/2506.09038)<br>
 [Ambig-SWE: Interactive Agents to Overcome Underspecificity in
 software engineering](https://arxiv.org/pdf/2502.13069)<br>
 [Abstrain-R1: Calibrated Abstention and Post-Refusal Clarification
 via Verifiable RL](https://arxiv.org/abs/2604.17073)

But — and this is the part that actually rescues your design — the gap
 detection gets dramatically more reliable when there's an explicit
 external artifact to diff against, which is exactly what your Haskell
 provides. The "Ask or Assume" study used an intent agent that watches
 state to detect underspecification and found interactive agents can
 identify and retrieve missing information, reaching resolve rates
 comparable to an autonomous agent given a fully specified issue, and
 Ambig-SWE shows that once models do interact on underspecified
 inputs, performance climbs by up to 74% over the non-interactive
 setting. The lesson: don't ask the model to introspect on whether
 it's uncertain; frame the task as "implement exactly this contract,
 and enumerate anything the production target requires that the
 contract doesn't determine." That converts an unreliable
 metacognitive judgment into a tractable diff against a concrete spec
 — and Haskell's own machinery (non-exhaustive pattern warnings, types
 that simply don't admit the case) mechanically surfaces a subset of
 those gaps for free. So the weakest claim in your thesis becomes a
 structural strength, but only because the spec is explicit and
 executable, not because the LLM got smarter.<br>
[Ask or Assume? Uncertainty-Aware Clarification-Seeking in Coding Agents](https://arxiv.org/html/2603.26233)<br>
[AMBIG-SWE: Interactive Agents to Overcome Underspecificity in
 Software Engineering](https://arxiv.org/abs/2502.13069)

One risk worth naming that the literature doesn't foreground: lossy
 projection across the chain. Categorical laws you can state but can't
 encode in Haskell's types, and Haskell invariants that have no home
 in, say, Go's type system, both vanish silently at the boundary. The
 most valuable thing your gap-detector can flag isn't "this case is
 undefined" but "this Haskell invariant cannot be expressed in the
 target language" — that boundary is precisely where the slop you're
 trying to eliminate creeps back in, and it's invisible to a
 checkpoint that only compares behavior on the cases both layers
 happen to express.
 
## Net 
The refined thesis is sound, and notice it no longer depends on
the LLM reasoning over CT at all — the model consumes Haskell types
and code, which are far more in-distribution than categorical
diagrams, so you've quietly dissolved my original objection. The CT is
doing its work entirely in your head, upstream, as the discipline that
produces a clean compositional Haskell skeleton. That's the honest
shape of why this works.

