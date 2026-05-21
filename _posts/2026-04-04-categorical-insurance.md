---
layout: paper.liquid
title: "Categorical learners and governance for insurance contracts"
published_date: 2026-04-04 09:00:00 -0500
tags:
  - applied-category-theory
  - large-language-models
  - bayesian-optimization
  - pareto-optimization
  - monoidal-categories
  - haskell
  - category-theory
  - insurance
  - governance
description: "We develop a category-theoretic treatment of insurance
contracts in which policies, endorsements, and claim events are
objects and morphisms in a structured category. Claim resolution is
recast as composition of morphisms, yielding a deterministic and
auditable semantics for contract execution. Worked examples are drawn
from the `categorical-insurance` reference implementation, which
exposes the constructions described here as a small embedded DSL. A category-theoretic model of insurance contracts; deterministic, auditable claim resolution via composable morphisms."
data:
  kind: paper
  pdf_url: "https://github.com/soulstrop/categorical-insurance/raw/main/docs/math.pdf"
---

Abstract—As large language model (LLM) agents become
increasingly modular, the orchestration of their components—
such as discrete skills, model providers, and external data
servers—presents a complex optimization problem. In this paper,
we introduce a category theoretic framework for constructing and
optimizing complex agent workflows. We define a strict monoidal
category where objects are typed data streams and morphisms
represent parameterized agent capabilities. By implementing this
framework in Haskell using Generalized Algebraic Data Types
(GADTs), we provide compile-time guarantees of well-formedness
for agent topologies. Furthermore, we formalize the search for
optimal agent configurations as a Bayesian Optimization problem
over this categorical space, employing Pareto optimization to
balance resource constraints against solution quality.

