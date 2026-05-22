# infra/ — Cloudflare via OpenTofu

Declarative Cloudflare config: DNS records, zone settings (SSL mode, TLS
floor, always-use-https), and the worker route for `staging.constans.dev`.

The **worker script** itself stays under `worker/` and is deployed by
wrangler. OpenTofu only manages the *route* that binds the hostname to
the script — they cooperate, they don't conflict.

## First-time setup

```sh
# 1. Make sure opentofu is installed (pinned in ../mise.toml)
tofu version

# 2. Get a Cloudflare API token with the "Edit Cloudflare Workers"
#    template (already configured for this project — same token the
#    GH Actions deploy uses). Export it:
export TF_VAR_cloudflare_api_token="<token>"

# 3. Copy and fill in the non-secret vars:
cp terraform.tfvars.example terraform.tfvars
$EDITOR terraform.tfvars   # set zone_id

# 4. Initialize:
tofu init

# 5. Capture the EXISTING cloudflare state. Edit imports.tf, fill in the
#    real resource IDs (instructions in that file), then:
tofu plan
# … expect: imports happen, "0 to add, 0 to change, 0 to destroy"
tofu apply
```

After the first successful apply, **delete `imports.tf`** — import blocks
are one-shot.

## Day-to-day

```sh
# Change something in *.tf
tofu fmt           # canonicalize whitespace
tofu validate      # syntactic + provider schema check
tofu plan          # preview
tofu apply         # commit
```

## State

Starts local (a `terraform.tfstate` file in this directory, gitignored).
Once comfortable, migrate to R2-backed state — see the commented `backend`
block in `main.tf`. Local state is fine for solo work; R2 (or HCP Terraform)
matters once you want CI to run `apply` or share with collaborators.

## What's *not* in here

- Cloudflare Pages projects (when/if we migrate)
- Transform Rules (would land here when we add security headers)
- Subdomain project DNS (each lives in its own repo's GH Pages settings)
- Worker script, secrets, bindings (wrangler owns these)

## Provider notes

Targets cloudflare/cloudflare ~> 5.0. Resource names changed from v4
(`cloudflare_record` → `cloudflare_dns_record`,
`cloudflare_zone_settings_override` → `cloudflare_zone_setting`). If you
see a "Resource not found in schema" error after a provider bump, check
the provider changelog first.
