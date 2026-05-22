---
permalink: /sitemap.xml
templated: true
layout: raw.liquid
---
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>{{ site.base_url }}/</loc>
  </url>
  <url>
    <loc>{{ site.base_url }}/projects/</loc>
  </url>
  <url>
    <loc>{{ site.base_url }}/writing/</loc>
  </url>
  <url>
    <loc>{{ site.base_url }}/publickey.html</loc>
  </url>
  <url>
    <loc>{{ site.base_url }}/terms/privacy-policy.html</loc>
  </url>
  <url>
    <loc>{{ site.base_url }}/terms/t-o-s.html</loc>
  </url>
  {%- for post in collections.posts.pages %}
  <url>
    <loc>{{ site.base_url }}/{{ post.permalink }}</loc>
    <lastmod>{{ post.published_date | date: "%Y-%m-%d" }}</lastmod>
  </url>
  {%- endfor %}
</urlset>
