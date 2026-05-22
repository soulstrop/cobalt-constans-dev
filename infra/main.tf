terraform {
  required_version = ">= 1.6"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }

  # State backend — starts local. To migrate to R2:
  #   1. Create an R2 bucket (e.g. "tofu-state") via dashboard or wrangler
  #   2. Create an R2 API token with read+write on that bucket
  #   3. Uncomment the block below, fill in account_id + endpoints
  #   4. `tofu init -migrate-state`
  #
  # backend "s3" {
  #   bucket                      = "tofu-state"
  #   key                         = "constans-dev/terraform.tfstate"
  #   region                      = "auto"
  #   endpoints                   = { s3 = "https://<ACCOUNT_ID>.r2.cloudflarestorage.com" }
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   skip_region_validation      = true
  #   skip_requesting_account_id  = true
  #   skip_s3_checksum            = true
  #   use_path_style              = true
  #   use_lockfile                = true   # object-based locking; OpenTofu 1.10+
  # }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
