locals {
  zone_id        = cloudflare_zone.this.id
  global_comment = trimspace(var.comment) != "" ? var.comment : null
}

resource "cloudflare_zone" "this" {
  account = {
    id = var.account_id
  }

  name   = var.zone
  paused = var.paused
  type   = var.type
}

resource "cloudflare_zone_dnssec" "this" {
  count = var.enable_dnssec ? 1 : 0

  zone_id = local.zone_id
}

resource "cloudflare_dns_record" "this" {
  for_each = var.records != null ? { for record in var.records : record.record_name => record } : {}

  zone_id = local.zone_id

  name    = coalesce(each.value.name, "@")
  type    = each.value.type
  content = each.value.value
  comment = coalesce(try(each.value.comment, null), local.global_comment)
  data    = each.value.value == null ? each.value.data : null

  priority = lookup(each.value, "priority", null)
  proxied  = lookup(each.value, "proxied", false)
  ttl      = lookup(each.value, "ttl", 1)
}
