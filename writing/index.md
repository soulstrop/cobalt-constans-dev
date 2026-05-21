---
layout: default.liquid
title: Writing
description: Notes and journal-style papers on systems, AI &amp; category theory.
permalink: /writing/
templated: true
data:
  section: writing
---
<h1 class="page-title">— writing<span class="dot">.</span></h1>
<p class="page-sub">papers &amp; notes · reverse-chronological</p>

<div class="w-mixed">
{% for post in collections.posts.pages %}
<a class="row" href="/{{ post.permalink }}">
<span class="date">{{ post.published_date | date: "%Y.%m" }}</span>
<div>
<span class="title">
{% assign kind = post.data.kind | default: "note" %}
<span class="kind{% if kind == "paper" %} paper{% endif %}">{{ kind }}</span>{{ post.title }}
</span>
{% if post.description %}
<p>{{ post.description | strip_html | truncatewords: 30 }}</p>
{% elsif post.excerpt %}
<p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
{% endif %}
</div>
</a>
{% endfor %}
</div>

<p style="margin-top:2rem;color:var(--fg-3);font-size:0.78rem;"><a href="/feed.xml">rss</a></p>
