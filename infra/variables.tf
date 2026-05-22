variable "cloudflare_api_token" {
  type        = string
  sensitive   = true
  description = "Cloudflare API token. Pass via TF_VAR_cloudflare_api_token env var, never hard-code."
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID. Visible on the dashboard right sidebar."
}

variable "zone_id" {
  type        = string
  description = "Zone ID for constans.dev. Dashboard → constans.dev → Overview → right sidebar."
}

variable "domain" {
  type        = string
  default     = "constans.dev"
  description = "The apex domain."
}

variable "worker_name" {
  type        = string
  default     = "constans-edge"
  description = "Name of the edge worker (managed by wrangler, referenced by routes here)."
}

variable "gh_pages_ips" {
  type = list(string)
  default = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]
  description = "GitHub Pages anycast IPs for apex A records."
}
