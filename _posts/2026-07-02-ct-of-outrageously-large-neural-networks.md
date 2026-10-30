---
layout: note.liquid
title: "The Category Theory of 'Outrageously Large Neural Networks'"
published_date: 2026-07-02 12:00:00 -0500
tags:
  - ai
  - llm
  - category-theory
  - mixture-of-experts
  - philosophy
  - paper-club
description: "Shazeer, Mirhoseini, et al.'s 'Outrageously Large Neural
Networks: The Sparsely-Gated Mixture-of-Experts Layer' gets much easier
to read once you see conditional computation as swapping products for
coproducts, and the gate as a Kleisli arrow of the distribution monad."
data:
  kind: note
  read_time: "20 min"
  math: true
---



The Sparsely-Gated Mixture-of-Experts (MoE) paper makes one central
move. It takes a layer that *computes everything and then mixes* and
turns it into a layer that *routes, and then computes only what was
routed to*. Category theory has a precise name for each of these
shapes: the first is a **product**, the second is a **coproduct**.

What makes the paper interesting from this angle is that in
$\mathbf{Vect}$, the category neural networks mostly live in, finite
products and coproducts are *the same object*: the **biproduct**
$\oplus$. So as equations, a dense mixture and a sparse mixture are
indistinguishable. A gate value of $0$ just multiplies an expert's
output by zero. As computations, they are very different, and the
1000x capacity gain lives in that difference.

Below I go through the paper's constructions one at a time and give
each its categorical reading.

---

### 1. Dense vs. Sparse: Product vs. Coproduct

The MoE layer's output (the paper's Eq. 1) is

$$y = \sum\_{i=1}^{n} G(x)\_i \, E\_i(x)$$

with experts $E\_i : X \to Y$ and a gate $G : X \to \mathbb{R}^n$.

#### A. The dense reading: the product

Read literally, this formula factors through the **product** of the
experts:

$$X \xrightarrow{\;\langle G,\; \langle E\_1, \dots, E\_n \rangle \rangle\;} \mathbb{R}^n \times Y^n \xrightarrow{\;\text{pair}\;} Y$$

The tupling $\langle E\_1, \dots, E\_n \rangle : X \to Y^n$ is the
universal map into a product. Its universal property says it is
determined by *all* of its components, so you have to compute every
$E\_i(x)$. The final pairing $(g, \vec{y}) \mapsto \sum\_i g\_i y\_i$
then collapses the tuple back into $Y$. This is the softmax gating of
Jordan & Jacobs (the paper's Eq. 2): every expert runs on every input.

#### B. The sparse reading: the coproduct

Now suppose the gate makes a *hard* choice $r(x) \in \{1, \dots, n\}$
(top-1 routing). The layer then factors through the **coproduct**:

$$X \xrightarrow{\;\langle r, \text{id} \rangle\;} \coprod\_{i=1}^{n} X \xrightarrow{\;[E\_1, \dots, E\_n]\;} Y$$

The first map tags $x$ with the injection $\iota\_{r(x)}$. The
copairing $[E\_1, \dots, E\_n]$ is the universal map *out of* a
coproduct, and its universal property says that on the summand
$\iota\_i$ it is exactly $E\_i$ and nothing else. **The copairing only
evaluates the branch you are in.** That one sentence is all of
conditional computation.

#### C. Why the paper can have it both ways

In $\mathbf{Vect}$, $Y^n \cong Y \oplus \cdots \oplus Y \cong \coprod
Y$. The product and the coproduct coincide, so the same formula can
be read either way. Equationally, the sparse layer is just the dense
layer with most gate entries set to $0$. Operationally, a zero entry
in the product reading is computed and then thrown away, while in the
coproduct reading it is never computed at all.

So the paper's approach comes down to this: **keep the algebra of
biproducts (so everything is still differentiable and composable), but
schedule it as a coproduct (so cost scales with the branch taken, not
with the number of branches).**

---

### 2. The Gate as a Kleisli Arrow of the Distribution Monad

Top-$k$ routing with $k > 1$ is neither a hard choice nor a dense
mix. The categorical tool for it is the **finite distribution monad**
$\mathcal{D}$ on $\mathbf{Set}$. $\mathcal{D}(A)$ is the set of finitely
supported probability distributions on $A$; the unit $\eta$ sends $a$
to the point mass $\delta\_a$; the multiplication $\mu$ flattens a
distribution over distributions into a single one.

The noisy top-$k$ gate (Eqs. 3–5)

$$G(x) = \text{Softmax}(\text{KeepTopK}(H(x), k))$$

is non-negative and sums to $1$, so it is a **Kleisli arrow**
$G : X \to \mathcal{D}(n)$, where $n = \{1, \dots, n\}$ indexes the
experts. KeepTopK makes sure the support has at most $k$ points.

Any real vector space $Y$ is an **Eilenberg–Moore algebra** for
$\mathcal{D}$. It is a convex space, with structure map
$\alpha : \mathcal{D}(Y) \to Y$ given by $\sum\_j p\_j \delta\_{y\_j}
\mapsto \sum\_j p\_j y\_j$ (take the expectation). With these pieces the
whole MoE layer is the composite

$$X \xrightarrow{\;\langle G, \text{id} \rangle\;} \mathcal{D}(n) \times X \xrightarrow{\;\text{st}\;} \mathcal{D}(n \times X) \xrightarrow{\;\mathcal{D}([E\_i])\;} \mathcal{D}(Y) \xrightarrow{\;\alpha\;} Y$$

where $\text{st}$ is the monad's strength and $n \times X \cong
\coprod\_{i} X$ is the coproduct from §1.B.

The key observation is about the third arrow. **$\mathcal{D}$ acts on
a map by pushing each support point forward**, so
$\mathcal{D}([E\_i])$ evaluates $[E\_i]$ only at the points in the
support of $G(x)$. The cost of the layer is therefore proportional to
$\lvert \text{supp}\, G(x) \rvert = k$ and does not depend on $n$.
Softmax gating has full support, so it pays for all $n$. Noisy top-$k$
gating restricts the gate to the subfunctor $\mathcal{D}\_{\le k}
\subseteq \mathcal{D}$ of distributions with at most $k$ support
points. Restricting to that subfunctor *is* the sparsity.

This picture also tells you that KeepTopK is a **forgetting** map in
exactly the sense of the companion note on *Scaling Discovery Requires
Forgetting*. It is an idempotent retraction of $\mathbb{R}^n$ onto
"vectors with at most $k$ finite entries", and it throws away the
$n-k$ losing scores completely.

---

### 3. Hierarchical MoE is Monad Multiplication

Appendix B defines a two-level MoE: a primary gate $G\_{primary} : X
\to \mathcal{D}(a)$ picks among $a$ groups, and each group $i$ has its
own secondary gate $G\_i : X \to \mathcal{D}(b)$ over $b$ experts. The
output is

$$y\_H = \sum\_{i=1}^{a} \sum\_{j=1}^{b} G\_{primary}(x)\_i \cdot G\_i(x)\_j \cdot E\_{i,j}(x)$$

The coefficients $G\_{primary}(x)\_i \cdot G\_i(x)\_j$ are exactly what
you get from **Kleisli composition**. Apply the secondary gates inside
the primary distribution to get an element of
$\mathcal{D}(\mathcal{D}(a \times b))$, then flatten with $\mu$:

$$\mu\Big( \sum\_i G\_{primary}(x)\_i \, \delta\_{\,\sum\_j G\_i(x)\_j \, \delta\_{(i,j)}} \Big) = \sum\_{i,j} G\_{primary}(x)\_i \, G\_i(x)\_j \, \delta\_{(i,j)} \in \mathcal{D}(a \times b)$$

So a hierarchical MoE is an ordinary MoE over the $a \cdot b$ leaves,
with a gate that has been *factored*. Because $\mu$ is associative,
any depth of hierarchy flattens to one gate over the leaves. This fits
the paper's footnote: "We have not found the need for deeper
hierarchies." Depth changes how the gate is computed (the branching
factor), not what it can express.

The load metric shows the same structure. The paper defines

$$Load\_H(X)\_{i,j} = \frac{Load\_{primary}(X)\_i \cdot Load\_i(X^{(i)})\_j}{\lvert X^{(i)} \rvert}$$

This is the chain rule $P(i, j) = P(i) \cdot P(j \mid i)$: a marginal
times a conditional, which is a **disintegration** in the language of
Markov categories. The paper remarks that the "simpler" formula
$Load\_i(X\_i)\_j$ "would not have a gradient with respect to the
primary gating network". Categorically, that formula keeps only the
conditional and drops the marginal, so it can't see the first factor
of the composite.

---

### 4. The Gate as a Partition of Unity

There is also a geometric reading. For each expert, define the region
where it is active:

$$U\_i = \{\, x \in X : G(x)\_i > 0 \,\}$$

Under top-$k$ gating every $x$ lies in exactly $k$ of these regions,
so $\{U\_i\}$ is a **cover** of the input space. The gate values
satisfy

* $G\_i \ge 0$,
* $\sum\_i G\_i = 1$,
* $\text{supp}\, G\_i \subseteq U\_i$.

That is precisely the definition of a **partition of unity subordinate
to the cover $\{U\_i\}$**. The MoE output $\sum\_i G\_i E\_i$ is then
the standard partition-of-unity construction: take local functions
$E\_i|\_{U\_i}$, one per patch, and blend them into a global function.

This framing explains two things in the paper.

* **Experts specialize.** Appendix E's Table 9 shows experts that fire
  on, for example, "innovation / research / technology" contexts. In
  this framing, specialization is the cover becoming *semantically
  meaningful*: each $U\_i$ is a region of meaning, and $E\_i$ only
  needs to be a good function *on that patch*. Strict sheaf gluing
  requires local sections to agree on overlaps. A partition of unity
  needs no agreement, because it averages. That is why experts can
  disagree and the layer still works.
* **The "theoretically scary discontinuities."** A real partition of
  unity is smooth, and each $G\_i$ goes to zero gradually at the
  boundary of its patch. KeepTopK does not do that. At $\partial U\_i$,
  when expert $i$ drops out of the top $k$, $G\_i$ jumps from a
  positive value straight to $0$. The gate is a partition of unity
  everywhere *except* at the patch boundaries, and the boundaries are
  exactly the discontinuities the authors flag (and then report
  aren't a problem in practice).

When $k = 1$ the cover becomes a **partition**, $X \cong \coprod\_i
U\_i$, and the construction reduces to the copairing of §1.B: no
blending, only routing.

---

### 5. Noise as Smoothing: Moving to a Kleisli Category of Kernels

The noise term in Eq. 4,

$$H(x)\_i = (x \cdot W\_g)\_i + \text{StandardNormal}() \cdot \text{Softplus}((x \cdot W\_{noise})\_i)$$

matters a lot from a categorical point of view.

Backpropagation is functorial. In "Backprop as Functor" (Fong, Spivak,
Tuyéras) and in reverse-derivative categories (Cockett et al.),
gradient-based learning is a functor out of a category of
**smooth parametric maps**. KeepTopK is not a smooth map, so the
membership indicator $\mathbb{1}[\, i \in \text{top-}k(H(x)) \,]$
is not a morphism in that category, and the number of examples routed
to each expert can't be differentiated.

The noise moves the problem into a different category. With noise,
$H$ is a **Markov kernel** $X \rightsquigarrow \mathbb{R}^n$, an arrow
in the Kleisli category of the Giry monad. Composing the kernel with
the discontinuous indicator gives a kernel $X \rightsquigarrow
\{0,1\}$, and the probability that it outputs $1$ is smooth in $x$:

$$P(x, i) = \Phi\Big(\frac{(x \cdot W\_g)\_i - \text{kth\\_excluding}(H(x), k, i)}{\text{Softplus}((x \cdot W\_{noise})\_i)}\Big)$$

Convolving a step function with a Gaussian gives the Gaussian CDF
$\Phi$. In categorical terms: **a deterministic map that isn't a
morphism of the smooth category becomes, after you randomize its
input, a kernel whose expectation is a smooth morphism.** The
$Load(X)\_i = \sum\_x P(x, i)$ estimator of Appendix A is exactly that
expectation, and its differentiability is the reason the noise is
there. The paper says so directly: "This is the purpose of the noise
term."

(The paper resamples only coordinate $i$'s noise and holds the others
fixed. That is conditioning on the other noise coordinates. You can
read it as a partial disintegration of the joint kernel, but nothing
in the argument depends on that refinement.)

---

### 6. Parameters in the Product, Compute in the Projection

Now look at the parameters instead of the activations. In the
$\mathbf{Para}$ construction, a layer is a map $P \times X \to Y$
together with its parameter object $P$. For the MoE layer:

$$P\_{\text{MoE}} = P\_G \times \prod\_{i=1}^{n} P\_i$$

The parameter object is a **product**, and *capacity* in the paper's
sense, "the capacity of a neural network to absorb information", grows
with this product. Adding experts adds factors.

On a single input $x$ with active set $S(x) = \text{supp}\, G(x)$,
the forward pass reads only the projection

$$\pi\_{S(x)} : P\_G \times \prod\_{i=1}^{n} P\_i \longrightarrow P\_G \times \prod\_{i \in S(x)} P\_i$$

On the backward pass, the reverse derivative gives a zero cotangent on
every factor outside $S(x)$. As a lens, the MoE layer's backward map
factors through the cotangent space of the *projected* parameters.

Product projection is the forgetting map in §2.C of the companion
note. The MoE layer's design principle is to **store parameters in
the full product and compute through a $k$-factor projection that
depends on $x$.** The 137-billion-parameter model is the size of the
product; the FLOPs per token are set by the size of the projection.
The paper's headline result is that you can grow the first by 1000x
while the second barely moves.

---

### 7. Batches: Routing as a Span

The performance sections (§3 of the paper) are about batches, and
batches have a clean categorical description too.

#### A. Routing is a relation, i.e. a span

Fix a batch $B$ and the set of experts $n$. One routing step is a
relation $R \subseteq B \times n$ ("example $b$ is sent to expert
$i$"), which is a **span**

$$B \xleftarrow{\;p\;} R \xrightarrow{\;q\;} n$$

There are two ways to impose sparsity, one on each leg:

* **Token choice (noisy top-$k$, §2):** every fibre of $p$ has size
  exactly $k$. Each example picks $k$ experts.
* **Expert choice (the batchwise mask, Appendix F):** every fibre of
  $q$ has size exactly $m = k\lvert B \rvert / n$. Each expert picks
  $m$ examples.

Counting $R$ both ways gives $\lvert R \rvert = k\lvert B \rvert =
mn$, which is why the paper chose that value of $m$: it is the only
one consistent with the span. Token choice and expert choice are the
same span with the role of the legs swapped. Expert-choice routing
later became a separate line of MoE work, and here it already appears
as the transpose of the main construction.

#### B. Dispatch and combine are reindexing

A family of sets over $n$ is the same thing as an $n$-tuple of sets
($\mathbf{Set}/n \simeq \mathbf{Set}^n$). Looking at $R$ through $q$
gives the **per-expert batches**: the fibre $q^{-1}(i)$ is what expert
$i$ actually processes. The all-to-all communication step in an MoE
implementation is this change of perspective, from "$R$ over $B$" to
"$R$ over $n$". The combine step goes back: a weighted dependent sum
along $p$ adds up each example's expert outputs.

#### C. The shrinking batch problem

With token choice, the average fibre of $q$ has size $k\lvert B \rvert
/ n$. Adding experts makes every expert's batch smaller. The paper's
fix is to take a **coproduct of batches**: $d$ data-parallel replicas
each contribute a batch $B\_r$, and the layer routes the combined
batch $B\_1 + \cdots + B\_d$, so each fibre of $q$ grows to about $kbd/n$.
Treating the timesteps of a sequence as one batch ("convolutionality")
is the same move, a coproduct over positions. In both cases the
remedy is to make the domain of the span bigger so that fibres over
$n$ get bigger.

#### D. Balancing is about the pushforward measure

The empirical distribution on $B$ can be pushed forward to $n$ in two
different ways:

* along the gate's weights, which gives $Importance(X) = \sum\_x G(x)$
  (Eq. 6), the total gate *mass* per expert;
* along the support indicator (smoothed as in §5), which gives
  $Load(X)$, the *number of examples* per expert.

Each balancing loss penalizes $CV^2$, a measure of how far one of
these pushforwards is from uniform on $n$. Since they are different
pushforwards, matching one doesn't control the other. The paper's
example of "a few examples with large weights" versus "many examples
with small weights" is a pair of measures with equal mass and unequal
counts.

The failure mode the losses guard against also has a clean
description. Without them, the routing map $q$ **collapses onto a
small image**. The gate only ever sends examples to a few experts, and
the factors of $\prod\_i P\_i$ outside that image never get a
gradient (see §6). The paper notes this is self-reinforcing: experts
in the image get trained, so they get chosen more. Table 6 shows the
cost. With no balancing loss, $CV(Load) = 3.01$, the most loaded
expert carries $17.8\times$ the mean load, and test perplexity is
$39.8$. With either loss it is $35.6$–$35.7$.

---

### 8. Naturality, and Why the Batchwise Mask Breaks at Inference

Appendix F has a problem that is really about **naturality**. Call a
routing rule $\rho$ something that assigns each batch $B$ a relation
$R\_B \subseteq B \times n$. A rule is **per-example** exactly when it
commutes with taking sub-batches: for every inclusion $\iota : B'
\hookrightarrow B$,

$$R\_{B'} = (\iota \times \text{id}\_n)^{-1}(R\_B)$$

So routing a sub-batch is the same as routing the full batch and
restricting. Put differently, $\rho$ is natural with respect to the
category of finite batches and inclusions.

* Top-$k$ and the threshold mask $M\_{threshold}(x, T)$ are natural.
  Whether example $b$ goes to expert $i$ depends only on $b$.
* The batchwise mask $M\_{batchwise}(X, m)$ is **not** natural. Whether
  $b$ makes it into expert $i$'s top $m$ depends on everything else in
  the batch.

At inference you may only have a batch of size one, and an unnatural
rule has no well-defined restriction to it. That is the same issue
that makes BatchNorm need separate inference statistics, which the
paper points out by citing Ioffe & Szegedy. The paper's fix is to
learn per-expert thresholds $T$ with the loss $L\_{batchwise}$ (Eq.
20), which is minimized when the natural rule $M\_{threshold}$ agrees
with the unnatural one $M\_{batchwise}$. In effect it **learns the
best natural approximation** to a rule that isn't natural, so the
model can be evaluated one example at a time.

---

### 9. What the Categorical View Does Not See

Most of the paper is engineering, and the reason is structural. Every
construction above is **invisible to the equational theory of
$\mathbf{Vect}$**. Since $\oplus$ is a biproduct, there is no equation
that tells a sparse MoE apart from a dense one with zero gates.

* **Network bandwidth (§3.2):** the requirement that an expert's
  compute-to-I/O ratio, roughly its hidden-layer size, exceed the
  device's compute-to-network ratio is a fact about hardware, not
  about morphisms.
* **GPUs prefer arithmetic to branching:** in categorical terms, the
  hardware would rather evaluate the product than the coproduct. The
  paper's design (few, large experts and large combined batches) makes
  each branch of the coproduct big enough that branching on hardware
  pays off.
* **Memory and out-of-memory errors:** the paper initializes $W\_g$
  and $W\_{noise}$ to zero so the initial load is balanced, purely to
  avoid running out of memory before the soft constraints take
  effect.

So the categorical lens describes **what** the MoE layer computes and
**why it can be trained** (the distribution monad, partitions of
unity, smoothing kernels, natural routing). It does not explain **why
it is fast**. The speed comes from choosing, among the many ways to
schedule one biproduct, the way that is cheapest on real hardware.

---

### Summary

| Paper construct | Categorical reading |
|---|---|
| Dense softmax mixture | Tupling into a product $Y^n$, then pairing |
| Sparse routing (top-1) | Tagging into a coproduct $\coprod X$, then copairing $[E\_i]$ |
| Noisy top-$k$ gate $G$ | Kleisli arrow $X \to \mathcal{D}\_{\le k}(n)$ |
| Output $\sum\_i G\_i E\_i$ | Eilenberg–Moore algebra $\alpha : \mathcal{D}(Y) \to Y$ |
| KeepTopK | Idempotent forgetting of $n-k$ scores |
| Hierarchical MoE | Kleisli composition, monad multiplication $\mu$ |
| $Load\_H$ formula | Disintegration: marginal $\times$ conditional |
| Gate values over active regions | Partition of unity subordinate to a cover |
| Expert specialization | The cover becoming semantically meaningful |
| Gaussian noise + $\Phi$ | Markov kernel whose expectation is smooth |
| Capacity vs. compute | Product of parameters vs. $x$-dependent projection |
| Routing a batch | A span $B \leftarrow R \rightarrow n$ |
| Token vs. expert choice | Fixing fibre sizes over $B$ vs. over $n$ |
| Mixing data and model parallelism | Coproduct of batches to enlarge fibres over $n$ |
| Importance vs. Load | Two different pushforwards of the batch measure |
| Batchwise mask $\to$ threshold mask | Learning a natural approximation to an unnatural rule |

### Reference

* **Outrageously Large Neural Networks: The Sparsely-Gated Mixture-of-Experts Layer**  
  Noam Shazeer, Azalia Mirhoseini, Krzysztof Maziarz, Andy Davis, Quoc Le, Geoffrey Hinton, and Jeff Dean.  
  *International Conference on Learning Representations (ICLR)* (2017). *arXiv preprint arXiv:1701.06538*.  
  [[PDF](https://arxiv.org/pdf/1701.06538)] &bull; [[arXiv](https://arxiv.org/abs/1701.06538)]

<details>
<summary>BibTeX</summary>

```bibtex
@misc{shazeer2017outrageouslylargeneuralnetworks,
  title         = {Outrageously Large Neural Networks: The Sparsely-Gated Mixture-of-Experts Layer},
  author        = {Noam Shazeer and Azalia Mirhoseini and Krzysztof Maziarz and Andy Davis and Quoc Le and Geoffrey Hinton and Jeff Dean},
  year          = {2017},
  eprint        = {1701.06538},
  archivePrefix = {arXiv},
  primaryClass  = {cs.LG},
  url           = {https://arxiv.org/abs/1701.06538}
}
```
</details>
