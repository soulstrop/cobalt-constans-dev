# constans.dev — Cobalt 0.20.x build

A static site for [constans.dev](https://constans.dev) targeting **Cobalt 0.20.4**.

## Quickstart

```sh
cargo install cobalt-bin --version "^0.20"
cobalt build          # outputs to _site/
cobalt serve          # dev server with live reload
```

## File layout

```
_cobalt.yml                    # site config
site.css                       # all production styles (copied verbatim)
index.html                     # hero-only landing (no frontmatter, copied as-is)
_layouts/
  default.liquid               # site chrome (header/nav/footer)
  note.liquid                  # single note template
  paper.liquid                 # single paper template
projects/
  index.html                   # /projects/ — case-study cards
writing/
  index.html                   # /writing/ — mixed feed (papers + notes)
_posts/
  2026-04-04-morphology-becomes-ontology.md   # note example
  2026-04-04-categorical-insurance.md         # paper example
  2026-03-15-pi-agent-space.md                # paper example
```

## Cobalt 0.20 frontmatter rules

Cobalt only recognizes a fixed set of top-level frontmatter fields:

```
permalink, slug, title, description, excerpt, categories, tags,
excerpt_separator, published_date, format, templated, layout,
is_draft, weight, data, pagination
```

**Anything else MUST live under `data:`**. The templates access these as
`page.data.<field>`.

### Adding a note

Create `_posts/YYYY-MM-DD-slug.md`:

```yaml
---
layout: note.liquid
title: "Your title"
published_date: 2026-05-18 12:00:00 -0500
tags: [tag-a, tag-b]
description: "1-2 sentence summary that shows up on /writing/."
data:
  kind: note
  read_time: "4 min"   # optional, displays in side meta
---

Your body in markdown.
```

### Adding a paper

Create `_posts/YYYY-MM-DD-slug.md` with `layout: paper.liquid`:

```yaml
---
layout: paper.liquid
title: "Paper title"
published_date: 2026-05-18 09:00:00 -0500
tags: [topic-a, topic-b]
description: "1-2 sentence summary that shows up on /writing/."
data:
  kind: paper
  pdf_url: "https://github.com/.../docs/math.pdf"
  pages: 18              # optional, displays in side meta
---

The abstract goes in the body (markdown).
```

The paper detail page renders only:
- Title · date · pages · tags
- Read-PDF button (from `data.pdf_url`)
- The abstract (post body)

No authors, no BibTeX, no .tex link — per your card spec.

## Key Liquid patterns

- **Iterate posts**: `{% for post in collections.posts.pages %}` (sorted newest-first by default)
- **Per-post custom field**: `{{ post.data.kind }}`
- **Per-page custom field**: `{{ page.data.read_time }}`
- **Build a URL**: `/{{ post.permalink }}`
- **Format a date**: `{{ post.published_date | date: "%Y.%m" }}`
- **Strip HTML for excerpts**: `{{ post.description | strip_html | truncatewords: 30 }}`

## Pages with Liquid (`templated: true`)

`projects/index.html` and `writing/index.html` use Liquid. They each declare
`templated: true` in their frontmatter so Cobalt processes them as templates.
Plain HTML files without frontmatter (like the root `index.html`) are copied
verbatim — no Liquid evaluation.

## Replacing PLACEHOLDER content

The two paper posts ship with placeholder abstracts. Replace the body markdown
with the real abstract from each PDF.

## What's deliberately *not* used

- `{% extends %}` — this is Liquid-inheritance syntax used by older Cobalt
  (pre-0.15) and by other generators. Cobalt 0.20 uses the frontmatter
  `layout:` field instead.
- `| relative_url` / `| absolute_url` — Jekyll-only filters. We use absolute
  paths (`/projects/`, etc.) directly.
- `| markdownify` — Jekyll-only. Markdown post bodies are processed
  automatically by Cobalt.
- `site.posts` — old Jekyll convention. Use `collections.posts.pages`.
