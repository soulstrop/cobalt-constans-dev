# merge-bundle/ — ship the whitepaper system to constans.dev

A commit-ready set of files for `soulstrop/cobalt-constans-dev`. Mirrors
the target tree exactly: copy paths under `merge-bundle/` to the same
paths in your local clone of that repo, on the **`staging`** branch.

## What's in here

| File | Verb | Reason |
|------|------|--------|
| `_includes/head.liquid` | **modify** | Conditional `<link rel="stylesheet" href="/whitepaper.css">` for `data.kind == "whitepaper"` pages only — keeps the asset off non-whitepaper pages. |
| `_includes/footer.liquid` | **modify** | Absorbs the trailing-punctuation autoscript from `default.liquid`. Selector broadened to `.post-body, .wp-body` so the whitepaper layout participates without duplicating code. Now the only place body-foot scripts live. |
| `_layouts/default.liquid` | **modify** | (1) Removes the stale autoscript (now in `footer.liquid`). (2) Fixes a latent rendering bug: two bare `//` comment lines were sitting *outside* the `<script>` tag and rendering as visible text on every default-layout page. |
| `_layouts/whitepaper.liquid` | **new** | Full HTML document, follows the `paper.liquid` / `note.liquid` pattern (head / header / footer includes). The previous `dist-cobalt/whitepaper.liquid` was a fragment with `extends: default:liquid` frontmatter — Cobalt 0.20 doesn't chain layouts, so that file would have rendered chrome-less. |
| `whitepaper.css` | **new** | Long-form layout: meta header, epigraph, drop cap on lede, auto-numbered `§` headings, Tufte-style sidenotes/marginnotes floating into a 260px right rail, full-bleed figures, footnotes block. Scoped under `.wp` so it can't leak into `.post` / `.paper`. Collapses inline on `<= 880px`. |
| `_posts/2026-05-26-determinism-under-load.md` | **new** | First whitepaper post. Frontmatter matches `whitepaper.liquid`'s contract. |
| `writing/index.md` | **modify** | Adds an `elsif kind == "whitepaper"` branch so the kind badge can take the `.kind.whitepaper` inverse-fill style. Without this the badge would render as a plain `.kind` pill. |

Seven files. Three modifications, four additions.

## Why not the previously-discussed `dist-cobalt/` resync

Inspecting the live repo showed `dist-cobalt/` here is a stale snapshot
of an earlier `main`. Production has since added self-hosted JetBrains
Mono fonts in `/fonts/`, the `.qm` accent-dot system in `site.css`, five
new posts, a staging branch + `POSTING.md` workflow, the
`terms/` / `security/` / `worker/` / `tasks/` / `.well-known/` trees,
and assorted infra files (`favicon.svg`, `robots.txt`, `sitemap.md`,
`lychee.toml`, `mise.toml`, `.htmlvalidate.json`, `_cobalt.staging.yml`,
`publickey.md`, `public-key.asc`). None of that was tracked here.

The right move is to **stop syncing `dist-cobalt/`** — it's pretending to
be a deploy mirror but isn't one. Either delete it, or move it under
`reference/` as a historical snapshot. The only valuable bits in it were
the whitepaper system, which this bundle promotes directly into the live
repo.

## How to land it (per `POSTING.md`)

```sh
# In your local clone of cobalt-constans-dev
git switch staging && git pull --ff-only

# Copy bundle files in
cp -r /path/to/this/merge-bundle/. .

# Verify
git status
# Expected: M _includes/head.liquid
#           M _includes/footer.liquid
#           M _layouts/default.liquid
#           A _layouts/whitepaper.liquid
#           A whitepaper.css
#           A _posts/2026-05-26-determinism-under-load.md
#           M writing/index.md

mise run build:staging

git add _includes/head.liquid _includes/footer.liquid \
        _layouts/default.liquid _layouts/whitepaper.liquid \
        whitepaper.css \
        _posts/2026-05-26-determinism-under-load.md \
        writing/index.md
git commit -m "whitepaper: layout + css + first post (determinism under load)

Adds the long-form whitepaper system as a third writing kind alongside
notes and papers. Tufte-style sidenotes/marginnotes in a 260px right
rail, auto-numbered sections, drop cap on the lede, optional epigraph
and footnotes blocks.

- _layouts/whitepaper.liquid: full HTML doc, head/header/footer includes
- whitepaper.css: scoped under .wp, collapses inline at <= 880px
- _includes/head.liquid: conditionally loads /whitepaper.css for
  data.kind == \"whitepaper\" pages
- _includes/footer.liquid: absorbs the trailing-punctuation autoscript
  (was duplicated/misplaced in default.liquid); selector broadened to
  cover .wp-body too
- _layouts/default.liquid: drops the autoscript (moved to footer.liquid)
  and fixes a latent bug where two bare // comment lines outside the
  <script> tag rendered as visible text on every default-layout page
- writing/index.md: kind badge gains a whitepaper branch
- _posts/2026-05-26-determinism-under-load.md: first whitepaper"

git push origin staging
# Preview at https://staging.constans.dev/writing/determinism-under-load/
# Sanity-check: sidenotes float right at >= 880px, collapse inline below.
# Check the kind badge on /writing/ shows the inverse-fill whitepaper pill.

mise run ship
```

## Open question for you

`whitepaper.css` declares `.kind.whitepaper` at the bottom of the file
(inverse fill — black on light, light on dark). The comment in that file
suggests promoting it into `site.css` once the kind is committed to.
You could do that in this commit or wait until the second whitepaper
ships. I'd wait — keeping it next to the layout it relates to is fine
for now, and the promotion is a clean follow-up commit.
