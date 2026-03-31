provider "cloudflare" {}

data "cloudflare_zones" "domain" {
  name = var.domain_name

  account = trimspace(var.account_id) != "" ? {
    id = var.account_id
  } : null
}

resource "cloudflare_dns_record" "this" {
  zone_id = data.cloudflare_zones.domain.result[0].id

  name    = coalesce(var.name, "@")
  type    = var.type
  content = var.value
  comment = var.comment
  data    = length(var.data) > 0 ? var.data[0] : null

  priority = var.priority
  proxied  = var.proxied
  ttl      = var.ttl
}
