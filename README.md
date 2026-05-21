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
_includes/
  head.liquid                  # <head> partial: meta + fonts + /site.css
  header.liquid                # nav with conditional aria-current
  footer.liquid                # bottom links
_layouts/
  default.liquid               # full HTML doc, slots in head/header/footer + page.content
  note.liquid                  # default doc + .post-sidekick note shell
  paper.liquid                 # default doc + .post-sidekick paper shell
projects/
  index.md                     # /projects/ — case-study cards (templated:true)
  media/                       # case-study screenshots/diagrams
writing/
  index.md                     # /writing/ — mixed feed of papers + notes (templated:true)
_posts/
  YYYY-MM-DD-slug.md           # posts; layout determines kind
404.html                       # standalone error page (no _includes — resilient)
maintenance.html               # portal-stub / generic maintenance shield (standalone)
```

## Why _includes + _layouts?

This Cobalt build only resolves the *one* layout named in a post's frontmatter
— it does not chain layouts via `extends:` (that's frontmatter on layout files,
which Cobalt does not parse). So every post-layout has to be a full HTML
document on its own. To stay DRY, we pull the head/header/footer chrome into
`_includes/` and have each layout `{% include "head.liquid" %}` it.

If you find yourself with a fragment layout (just an inner `<div>` and nothing
else), you'll get a chrome-less page with no stylesheet — that was the original
bug. The fix is the include pattern above.

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
  read_time: "4 min"
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

## Pages with Liquid (`templated: true`)

`projects/index.md` and `writing/index.md` use Liquid. They each declare
`templated: true` in their frontmatter so Cobalt processes them as templates.
Plain HTML files without frontmatter (like the root `index.html`) are copied
verbatim — no Liquid evaluation.

## Key Liquid patterns

- **Iterate posts**: `{% for post in collections.posts.pages %}` (sorted newest-first by default)
- **Per-post custom field**: `{{ post.data.kind }}`
- **Per-page custom field**: `{{ page.data.read_time }}`
- **Build a URL**: `/{{ post.permalink }}`
- **Format a date**: `{{ post.published_date | date: "%Y.%m" }}`
- **Strip HTML for excerpts**: `{{ post.description | strip_html | truncatewords: 30 }}`

## What's deliberately *not* used

- `{% extends %}` — this is Liquid-inheritance syntax used by older Cobalt
  (pre-0.15) and by other generators. Cobalt 0.20 uses the frontmatter
  `layout:` field instead — *and* Cobalt does not parse frontmatter on layout
  files, so you can't chain layouts via `extends:` either. Use `_includes/`.
- `| relative_url` / `| absolute_url` — Jekyll-only filters. We use absolute
  paths (`/projects/`, etc.) directly.
- `| markdownify` — Jekyll-only. Markdown post bodies are processed
  automatically by Cobalt.
- `site.posts` — old Jekyll convention. Use `collections.posts.pages`.

## Deploy

GitHub Actions workflow at `.github/workflows/deploy.yml` installs Cobalt,
runs `cobalt build`, and ships `_site/` to GitHub Pages on every push to
`main`.
