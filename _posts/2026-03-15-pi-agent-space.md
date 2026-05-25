---
layout: paper.liquid
title: "A Category Theoretic Framework for Multi-Agent
Workflows"
published_date: 2026-03-15 09:00:00 -0500
tags:
- applied-category-theory
- large-language-models
- bayesian-optimization
- pareto-optimization
- monoidal-categories
- haskell
description: "Explore the multidimensional solution space for
optimized agent construction by treating it as a combinatorial
Bayesian Optimization problem and defining the categorical semantics
of agent workflows."
data:
  kind: paper
  pdf_url: "https://raw.githubusercontent.com/soulstrop/pi-agent-space/main/docs/math.pdf"
---

**ABSTRACT**—As large language model (LLM) agents become
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
