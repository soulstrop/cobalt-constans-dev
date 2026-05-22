# Import blocks — capture EXISTING Cloudflare resources into OpenTofu state
# so the first `tofu apply` is "no changes" instead of "create everything"
# (which would fail or duplicate).
#
# Workflow:
#   1. Find the real resource IDs (dashboard, `dig`, or the CF API).
#   2. Fill in the `id` fields below.
#   3. `tofu plan -generate-config-out=generated.tf` (optional — generates
#      tf for any resources it can find but doesn't have a resource block for).
#   4. `tofu apply` — runs the imports, then converges.
#   5. Once stable: delete this file (import blocks are one-shot).
#
# How to find IDs:
#   - DNS record: `dig <name>` won't give it; use the CF API:
#       curl -H "Authorization: Bearer $TF_VAR_cloudflare_api_token" \
#         "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=constans.dev" | jq
#   - Zone setting: id is "<zone_id>/<setting_id>" for the v5 provider.
#   - Worker route: list via
#       curl -H "Authorization: Bearer $TF_VAR_cloudflare_api_token" \
#         "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/workers/routes" | jq

# --- Zone settings -----------------------------------------------------------

# import {
#   to = cloudflare_zone_setting.ssl
#   id = "${var.zone_id}/ssl"
# }
#
# import {
#   to = cloudflare_zone_setting.always_use_https
#   id = "${var.zone_id}/always_use_https"
# }
#
# import {
#   to = cloudflare_zone_setting.min_tls_version
#   id = "${var.zone_id}/min_tls_version"
# }

# --- DNS records -------------------------------------------------------------

# import {
#   to = cloudflare_dns_record.apex["185.199.108.153"]
#   id = "${var.zone_id}/<record_id>"
# }
# … one per apex IP, plus www, plus staging.

# --- Worker routes -----------------------------------------------------------

# import {
#   to = cloudflare_workers_route.staging
#   id = "${var.zone_id}/<route_id>"
# }
