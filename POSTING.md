g# Posting guide

How to produce new posts or project content for constans.dev.

No drafts workflow — `staging` *is* the draft environment. Author on the
`staging` branch, preview at `staging.constans.dev`, then promote to
production with `ship`.

## Order of operations

```
clean → write → serve → commit → build:staging → deploy:staging → ship
```

### 0. Start on the staging branch

All authoring happens on `staging`. `main` only ever receives content via
`promote`.

```sh
git switch staging
git pull --ff-only        # make sure you're current
```

### 1. Clean

Clear stale build artifacts so nothing old lingers.

```sh
mise run clean
```

### 2. Write the post

Create `_posts/YYYY-MM-DD-slug.md`:

```yaml
---
layout: note.liquid        # or paper.liquid
title: "Your title"
published_date: 2026-05-22 12:00:00 -0500
tags: [tag-a, tag-b]
description: "1-2 sentence summary that shows up on /writing/."
data:
  kind: note               # or paper
  read_time: "4 min"       # note-specific
  # pdf_url: "..."         # paper-specific
  # pages: 18              # paper-specific
---

Your body in markdown.
```

For **project content**, edit `projects/index.md` and drop assets in
`projects/media/`.

Custom fields must live under `data:` — Cobalt 0.20 only recognizes a
fixed set of top-level frontmatter keys. See `README.md`.

### 3. Serve — local iteration loop

```sh
mise run serve      # live-reload preview at localhost
```

Edit, save, refresh. `Ctrl-C` when the content reads right. (A plain
`mise run build` shows production output without the dev server if you
want it, but `serve` covers the writing loop.)

### 4. Add + commit — once it looks good locally

```sh
git add _posts/YYYY-MM-DD-slug.md          # + projects/media/* if applicable
git commit -m "post: <title>"
```

This is the "content is done" checkpoint. Everything downstream operates
on committed, pushed history — see [When to commit](#when-to-commit).

### 5. build:staging

Sanity-build the staging variant.

```sh
mise run build:staging
```

### 6. deploy:staging

Push the commit to the staging branch — this publishes staging:

```sh
git push origin staging      # triggers deploy-staging.yml → mise run deploy:staging
```

(Or run `mise run deploy:staging` locally first for a faster preview
before pushing.) Then eyeball **https://staging.constans.dev/** (basic
auth: `preview` / your secret): check the post renders, the
`/writing/<slug>/` URL works, the feed updated.

### 7. ship

Promote staging → production.

```sh
mise run ship        # = check + promote
```

`check` re-validates both builds (lychee + html-validate); `promote`
fast-forwards `main` from `staging` and pushes it, which triggers
`deploy-prod.yml` → GitHub Pages.

## When to commit

**Right after the local `serve` preview looks good (step 4), before
anything touches staging.** The reason is mechanical:

- `mise run deploy:staging` builds from your **working tree**, so it
  *would* run with uncommitted changes — but that's a trap, because…
- `ship` → `promote` fast-forwards `main` from **`origin/staging`**. It
  promotes *committed, pushed* history, not your working tree. Anything
  you haven't committed and pushed to `staging` won't reach production.

Rule of thumb: **commit when you're happy with the writing, push to
`staging` to publish the preview, then `ship`.**

If you tweak the post *after* previewing staging, just commit again and
re-push `staging` before shipping. Staging can accumulate several commits;
`promote` carries all of them to `main` at once.
