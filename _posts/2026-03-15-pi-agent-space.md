---
layout: paper.liquid
title: "Categorical Insurance: Learners and Comonadic Governance"
published_date: 2026-03-15 09:00:00 -0500
tags:
- Category theory
- comonad
- parametric learner
- lens
- governance
- insurance pricing
- Bühlmann credibility
- gradient descent
- Para construction
- co-Kleisli
description: "Use the machinery of Category Theory to create provably
correct Insurance Contracts."
data:
  kind: paper
  pdf_url: "https://github.com/soulstrop/pi-agent-space/raw/main/docs/math.pdf"
---

ABSTRACT — We describe the mathematical structure underlying a Haskell library for machine-learning–driven design of
insurance contracts. Learners, in the sense of Fong–Spivak–
Tuyéras and Cruttwell–Gavranovic–Ghani–Wilson–Zanasi, appear ´
as morphisms in a symmetric monoidal category that uniformly
captures both classical actuarial estimators (we exhibit Bühlmann
credibility) and gradient-based methods (we exhibit linear regression). Governance is carried by the Env comonad over a
monoid of rule sets, so federal, state, and internal regulations
compose via the monoid operation. Contract construction is
a co-Kleisli arrow factoring through this comonadic context,
making the rule *“no contract may be made that violates governance”*
a static guarantee rather than a runtime convention. Layered
regulation reduces, by conjunctivity of satisfaction over the monoid
sum, to a single co-Kleisli composite, and switching jurisdiction
becomes a substitution at the carrier level that is functorial in
`$Mon(Set) → CoMon(Set)$`.

