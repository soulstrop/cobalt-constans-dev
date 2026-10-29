---
layout: note.liquid
title: "The Category Theory of 'Scaling Discovery Requires Forgetting'"
published_date: 2026-10-28 12:00:00 -0500
tags:
  - ai
  - llm
  - category-theory 
  - agents
  - philosophy
  - paper-club 
description: "The recent paper from Shangyin Tan, et al 'Scaling
Discovery Requires forgetting' becomes far more legible to me by applying the Natural Transformation of Forgetting: The Counit"
data:
  kind: note
  read_time: "15 min"
  math: true
---



In category theory, the concept of "forgetting" is primarily
formalized as a **Forgetful Functor** (often denoted $U$), along with
its associated **natural transformations** (specifically the **counit
of an adjunction** or **projections**).

Depending on whether you mean the mapping between categories itself or
a specific *natural transformation*, here are the exact categorical
constructs:


### 1. The Forgetful Functor ($U: \mathcal{C} \to \mathcal{D}$)
Strictly speaking, "forgetting" is first and foremost a **functor**,
not a natural transformation. A **forgetful functor** (also called a
*stripping functor*) maps objects and morphisms from a richly
structured category $\mathcal{C}$ to a less structured category
$\mathcal{D}$ by discarding structure, axioms, or properties:
 * **Forgetting structure:** $U: \mathbf{Grp} \to \mathbf{Set}$ takes
   a group $(G, \cdot, e)$ and forgets the group operation, returning
   its underlying set $G$, and maps group homomorphisms to plain set
   functions.
 * **Forgetting properties:** $U: \mathbf{Ab} \to \mathbf{Grp}$ takes
   an abelian group and forgets that the operation is commutative.

---

### 2. The Natural Transformation of Forgetting: The Counit ($\varepsilon$) and Comonads

If you are looking specifically for a
**natural transformation** that performs "forgetting" or "extracting"
inside a category, there are two main candidates:

#### A. The Counit of a Free-Forgetful Adjunction ($\varepsilon: F U \Rightarrow \text{Id}\_{\mathcal{C}}$)

A forgetful functor $U:
\mathcal{C} \to \mathcal{D}$ almost always has a left adjoint—the
**Free Functor** $F: \mathcal{D} \to \mathcal{C}$ ($F \dashv U$).
 * Their relationship is governed by two natural transformations: the
   **unit** ($\eta: \text{Id}\_{\mathcal{D}} \Rightarrow U F$) and the
   **counit** ($\varepsilon: F U \Rightarrow
   \text{Id}\_{\mathcal{C}}$).
 * While $U$ forgets the structure of $\mathcal{C}$, the counit
   $\varepsilon\_X: F(U(X)) \to X$ takes the "freely generated"
   structure built on the forgotten underlying object $U(X)$ and
   collapses/evaluates it back into the original structured object
   $X$, effectively **forgetting the formal scaffolding** of the free
   construction.

#### B. The Comonad Counit / Extract ($\varepsilon: W \Rightarrow \text{Id}$)

Dual to a Monad (which adds context/effects), a
**Comonad** $(W, \varepsilon, \delta)$ models objects situated in a
context (Note: every $F \dashv U$ adjunction induces a comonad $W = F
U$ on $\mathcal{C}$).
 * Its primary natural transformation is the **counit** $\varepsilon:
   W \Rightarrow \text{Id}$ (called `extract` in functional
   programming).
 * Given a value wrapped in a context $W(A)$ (such as an environment,
   a stream history, or a store), $\varepsilon\_A: W(A) \to A$
   **forgets the surrounding context** and extracts the underlying
   value $A$.

#### C. Terminal and Projection Transformations
 * **Terminal morphism ($!: X \to 1$):** Viewed as a natural
   transformation from the identity functor to the constant functor at
   the terminal object ($!: \text{Id} \Rightarrow \Delta\_1$), this
   forgets *all* internal information of an object $X$, collapsing it
   to a single point.
 * **Product projection ($\pi\_1: A \times B \to A$):** A natural
   transformation that forgets the second component $B$ of a pair
   (which, in a Cartesian category, is equivalent to applying the
   terminal map $!\_B$ to $B$: $A \times B \xrightarrow{\text{id}\_A
   \times !\_B} A \times 1 \cong A$).

### Reference

* **Scaling Discovery Requires Forgetting**  
  Shangyin Tan, Ben Zhou, Lakshya A. Agrawal, Jialin Zhang, Yilin Chen, Qiuyang Mang, Donghyun Lee, Dennis Jacob, Koushik Sen, Alex Dimakis, and Matei Zaharia.  
  *arXiv preprint arXiv:2610.20563* (2026).  
  [[PDF](https://arxiv.org/pdf/2610.20563)] &bull; [[arXiv](https://arxiv.org/abs/2610.20563)]

<details>
<summary>BibTeX</summary>

```bibtex
@misc{tan2026scalingdiscoveryrequiresforgetting,
  title         = {Scaling Discovery Requires Forgetting},
  author        = {Shangyin Tan and Ben Zhou and Lakshya A. Agrawal and Jialin Zhang and Yilin Chen and Qiuyang Mang and Donghyun Lee and Dennis Jacob and Koushik Sen and Alex Dimakis and Matei Zaharia},
  year          = {2026},
  eprint        = {2610.20563},
  archivePrefix = {arXiv},
  primaryClass  = {cs.AI},
  url           = {https://arxiv.org/pdf/2610.20563}
}
```
</details>
