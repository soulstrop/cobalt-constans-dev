---
layout: page.liquid
title: Public Key
description: "PGP public key for J. Michael Constans."
permalink: "/publickey/"
---

<p class="pgp-fingerprint">
  <span class="pgp-fingerprint-label">Fingerprint</span>
  <code>52E0 7AB6 C421 5078 5163 DA04 FBC4 5020 9552 9355</code>
</p>

<div class="act-row">
  <button id="copy-btn" class="act" type="button">copy key <span class="arr">↗</span></button>
  <a class="act" href="/public-key.asc" download="jmc-pubkey.asc">download .asc <span class="arr">↗</span></a>
</div>

<pre class="pgp-key"><code id="pgp-key">-----BEGIN PGP PUBLIC KEY BLOCK-----
mDMEaI7q0BYJKwYBBAHaRw8BAQdAibLxpxPrHHoeEtsVS7qKL9LBR9oMqkG8EHRo
qrZXrgS0UUouIE1pY2hhZWwgQ29uc3RhbnMgKFB1Ymxpc2hlZCBvbiBodHRwczo6
Ly9jb25zdGFucy5kZXYvYWJvdXQpIDxqbWNAY29uc3RhbnMuZGV2PoiZBBMWCgBB
FiEEUuB6tsQhUHhRY9oE+8RQIJVSk1UFAmiO6tACGwMFCQPCZwAFCwkIBwICIgIG
FQoJCAsCBBYCAwECHgcCF4AACgkQ+8RQIJVSk1WqUQEA3SUKU/zlspjjZG6G/7dc
MyBYaCc/m3eZ7pnCNTfYrcsBAPKdGuZXPyiWkZVr648XnJizUp39VkxZP5LERL3P
KaQCuDgEaI7q0BIKKwYBBAGXVQEFAQEHQIVxd5RDTa9qKPebgcz96nqlR1OD0+vT
nUbY4WXT+speAwEIB4h+BBgWCgAmFiEEUuB6tsQhUHhRY9oE+8RQIJVSk1UFAmiO
6tACGwwFCQPCZwAACgkQ+8RQIJVSk1UiKAD+IuDUXUZm6fdXJnQRXTgRtgv0fM8G
nYblG+N4649PungA/iw2EwMbKy9JXGWhvU70MOFqvS7y0VDFwN6S2NtOJAAO
=M5L9
-----END PGP PUBLIC KEY BLOCK-----</code></pre>

<script>
  (function () {
    var btn = document.getElementById('copy-btn');
    var key = document.getElementById('pgp-key').textContent;
    btn.addEventListener('click', function () {
      navigator.clipboard.writeText(key).then(function () {
        var orig = btn.innerHTML;
        btn.textContent = 'copied';
        setTimeout(function () { btn.innerHTML = orig; }, 2000);
      });
    });
  })();
</script>
