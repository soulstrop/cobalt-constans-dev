# Posting guide

How to produce new posts or project content for constans.dev.

No drafts workflow — `staging` *is* the draft environment. Author on the
`staging` branch, preview at `staging.constans.dev`, then promote to
production with `ship`.

## Order of operations

```
clean → write → serve → commit → push staging → deploy:staging → ship
```

**Commit and push to `origin/staging` before deploying or shipping.**
`deploy:staging` builds from the working tree (so it will show your
changes), but `ship` → `promote` operates on `origin/staging` (committed,
pushed history). If you haven't pushed, promote will skip your content.

**Never run `mise run promote` directly.** Always use `mise run ship`,
which runs `check` (full rebuild + html-validate + lychee) first. Running
`promote` alone bypasses the validation gate and pushes unvalidated HTML
to production. Use `mise run check` if you want to validate without
promoting.

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

#### Footnotes — name them, don't number them

Cobalt derives the footnote's HTML `id` from the footnote's *name*, so a
numeric `[^1]` emits `id="1"` and fails `check` with:

```
error  element id "1" must begin with a letter  valid-id
```

Use a semantic name instead:

```markdown
...more robust! more resilient! simpler![^pascal]

[^pascal]: Blaise Pascal, *Seizième Lettre Provincial*
```

**The visible numbering is unaffected** — Cobalt auto-numbers the
superscript, so `[^pascal]` still renders as "1". Only the anchor changes
(`href="#pascal"` / `id="pascal"`). Named footnotes are also stable when you
reorder them, since the displayed number is computed at render time.

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

Stage specific files rather than `git add .` — the latter can pick up
build artifacts if `.gitignore` has a gap.

This is the "content is done" checkpoint. Everything downstream operates
on committed, pushed history — see [When to commit](#when-to-commit).

### 5. Push staging

```sh
git push origin staging
```

`origin/staging` must have the commit before you ship. `promote`
fast-forwards `main` from `origin/staging`, not from your working tree.

### 6. deploy:staging

Publish to the staging Worker so you can eyeball the live URL:

```sh
mise run deploy:staging      # depends on build:staging; runs it automatically
```

Then check **https://staging.constans.dev/** (basic auth: `preview` /
your secret): the post renders, `/writing/<slug>/` works, feed updated.

`deploy:staging` also triggers via `git push` → `deploy-staging.yml` in
CI, but running it locally is faster.

### 7. ship

Promote staging → production.

```sh
mise run ship        # = check + promote
```

`check` rebuilds both sites from scratch, then runs html-validate and
lychee against the fresh output — it does not reuse whatever is in `_site/`.
If validation passes, `promote` fast-forwards `main` from `origin/staging`
and pushes it, triggering `deploy-prod.yml` → GitHub Pages.

If `check` fails, nothing is promoted. Fix the source, commit, push
staging, and re-run `ship`. Do not run `promote` to work around a
failing `check`.

#### The lychee "Followed 1 redirect" hint is expected — ignore it

`check` prints a hint suggesting you replace redirecting URLs with their
resolved ones. **Don't.** The one redirect is
`https://openreview.net/forum?id=wGj8LU2EOf` — a sidenote link in
*the-unreasonable-effectiveness-of-category-theory-in-preventing-llm-drift* —
which 307s to an OpenReview anti-bot challenge page. That target is a
transient gate that embeds the real URL as a `redirect=` parameter and
bounces real browsers back; swapping it in would replace a good permanent
link with a throwaway one. The link resolves `200 OK`, reports 0 errors, and
never fails `check`. It's also deliberately *not* in `lychee.toml`'s exclude
list — the entries there are for links that genuinely fail; this one passes.

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
