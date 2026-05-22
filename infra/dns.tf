# DNS records.
# Resource: cloudflare_dns_record (v5 — was cloudflare_record in v4).
#
# Note on apex: GitHub Pages requires apex A records (no CNAME at the apex
# unless you use CNAME flattening). Four anycast IPs for resilience.

resource "cloudflare_dns_record" "apex" {
  for_each = toset(var.gh_pages_ips)

  zone_id = var.zone_id
  name    = var.domain
  type    = "A"
  content = each.value
  ttl     = 1     # 1 = "automatic" in Cloudflare
  proxied = true
  comment = "GitHub Pages apex (managed by OpenTofu)"
}

resource "cloudflare_dns_record" "www" {
  zone_id = var.zone_id
  name    = "www.${var.domain}"
  type    = "CNAME"
  content = var.domain
  ttl     = 1
  proxied = true
  comment = "Redirects to apex via GH Pages (managed by OpenTofu)"
}

resource "cloudflare_dns_record" "staging" {
  zone_id = var.zone_id
  name    = "staging.${var.domain}"
  type    = "CNAME"
  content = "${var.worker_name}.workers.dev"
  ttl     = 1
  proxied = true
  comment = "Staging worker route (managed by OpenTofu)"
}

# Subdomain projects (catins, threadscout, …) intentionally NOT managed here —
# each lives in its own GH Pages site and registers its custom domain via the
# repo's Pages settings, which writes the CNAME into Cloudflare on our behalf.
# Keeping them out of state avoids accidental drift / deletion.
