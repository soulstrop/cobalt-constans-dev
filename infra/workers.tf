# Worker routes. The worker SCRIPT itself is deployed by wrangler
# (see ../worker/). OpenTofu only owns the routes that bind hostnames
# to that script.

resource "cloudflare_workers_route" "staging" {
  zone_id     = var.zone_id
  pattern     = "staging.${var.domain}/*"
  script_name = var.worker_name
}
