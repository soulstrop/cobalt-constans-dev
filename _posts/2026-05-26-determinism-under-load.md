---
layout: whitepaper.liquid
title: "Determinism under load"
published_date: 2026-05-26 09:00:00 -0500
tags:
  - determinism
  - audit
  - inference
description: "A working definition of audit-grade inference, and what it costs."
data:
  kind: whitepaper
  subtitle: "A working definition of audit-grade inference, and what it costs."
  version: "1.0"
  author: "J. Michael Constans"
  pages: "8 min · ~1,400 words"
  epigraph: "An audit is only as deep as its replays."
  epigraph_attr: "engineering folklore, attribution unclear"
  pdf_url: "/papers/determinism-under-load-v1.pdf"
---

<p class="lede">Determinism, as a property of a system, is easy to define and hard to keep. A system is deterministic when the same input set, under the same configuration, produces the same output. The challenge is the second half — <em>the same configuration</em> — because configuration is the part that drifts.</p>

Drift can be enumerated. Library upgrades, kernel patches, hardware substitutions, schema additions, prompt edits, the occasional cosmic ray<span class="sn-ref"></span><span class="sidenote">We exclude here genuinely non-deterministic operations — hardware RNG taps, wall-clock reads, network jitter. Those are out-of-scope by construction: an audit-grade system either avoids them or vendors them through a seeded interface.</span>. Each is a transition that, on a long enough timeline, will change an output you swore last week was settled. The question is not whether your system drifts — it does — but whether you can prove what it did, when.

## What we mean by audit-grade

Audit-grade is not the same as bit-stable<span class="sn-ref"></span><span class="sidenote">This distinction matters because bit-stability is impossible past certain hardware boundaries. FP determinism on a single-vendor GPU is one thing; across mixed accelerators it is fiction. Audit-grade is achievable; bit-stability is a strict subset.</span>. A bit-stable system produces identical output for identical input across deploys. An audit-grade system produces output whose provenance can be reconstructed from a signed trace, <em>whether or not</em> the bits match.

The difference matters because real workloads make bit-stability prohibitively expensive — and frequently impossible — past a certain hardware boundary. Audit-grade asks a weaker question and answers it well: <em>can you, at any later time, produce the trace that explains this output?</em>

## The signed-trace primitive

The atom is a signed execution trace. Every inference produces one:

```json
{
  "trace_id": "01HX8K3RYV5N7K2QZ9F8X4M6B0",
  "input_hash":  "sha256:7a3f…",
  "config_hash": "sha256:c2e1…",
  "model":       "claude-sonnet-4.5@2025-09-15",
  "tool_calls":  [ … ],
  "output":      "…",
  "signed_by":   "tee:nv-h100-prod-04",
  "signature":   "ed25519:…"
}
```

The signature binds output to input + config at the time of execution<span class="sn-ref"></span><span class="sidenote">Whether a field is "meaningful" is a policy decision, not a technical one. The infrastructure produces all fields; the spec says which fields must match on replay and which are permitted to drift.</span>. Replay produces a <em>new</em> trace; the audit question is whether the new trace agrees with the original on the fields the spec marks as meaningful.

<span class="marginnote">Trace IDs use ULIDs. Sortable by time, collision-resistant under load.</span>

This is a quietly powerful inversion. We stop asking the system to be deterministic and instead ask it to be <em>legible</em>. Legibility is something you can engineer; determinism past a certain scale is something you can only approximate.

## Replay under drift

Replay is the operation that converts a stored trace into a fresh trace and compares them. The comparison is field-wise against a policy.

<figure>
  <div class="frame">trace pipeline · figure placeholder · 16:9</div>
  <figcaption>The replay pipeline. Stored trace on the left, fresh execution on the right; the comparator produces a signed verdict against the field policy. Drift in non-meaningful fields is recorded but does not invalidate the audit.</figcaption>
</figure>

In practice, the comparator is the entire product. A weak comparator that marks everything meaningful gives you the bit-stability problem in a hat. A permissive comparator that marks nothing meaningful gives you the comfort of a green checkmark with none of the substance.<span class="sn-ref"></span><span class="sidenote">We have settled, empirically, on three tiers: <em>identity</em> (output must match exactly), <em>equivalence</em> (output must satisfy a structural predicate — same JSON schema, same tool sequence, etc.), and <em>witnessed</em> (output must be derivable from the same intermediate states under the spec's permitted transformations).</span> Building the right comparator is the design work.

## What this costs

Audit-grade inference is not free. The honest numbers, from our own deployment:

| measure | overhead | notes |
| ---- | ---- | ---- |
| inference latency | +6–9% | trace assembly + signing |
| storage | ~4 KB / trace | compressed, before tool I/O |
| build time | +30s | config-hash computation |
| eng time | the largest cost | comparator + policy design |

The first three are bounded.<span class="sn-ref"></span><span class="sidenote">Storage scales linearly with throughput, of course. At 10 RPS sustained, you accumulate roughly 100 GB of traces per month. Cold-storage them; the access pattern is "investigate one trace from six months ago," not "scan everything weekly."</span> The fourth is unbounded and is the real reason most systems don't have audit-grade traces — not the latency, not the storage, but the work of writing down which fields matter and defending that policy under pressure.

## A working definition

Pulling the thread back:

> A system is **audit-grade** if every execution produces a signed trace, and if a replay-policy comparator can derive, from any stored trace plus the current build, a verdict that distinguishes meaningful drift from incidental drift.

Three load-bearing words. **Signed** — the trace is binding under the signing authority. **Replay-policy** — the spec is written down and versioned. **Comparator** — the verdict is mechanical, not editorial.

The system that ships under this definition is slower, more expensive, and considerably more deployable into regulated environments than its bit-stable cousin<span class="sn-ref"></span><span class="sidenote">It is also, in our experience, the system that produces the better engineering culture around it. The discipline of writing down what counts as meaningful drift is the discipline of writing down what your system actually claims to do.</span>. We think this is the right tradeoff. We think it generalizes.

The remainder of this work expands each of the three pieces — the signing authority, the policy schema, the comparator algebra — and reports failure modes from the deployments that have been wearing the design for a year.
