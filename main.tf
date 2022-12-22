locals {
  zone_id = cloudflare_zone.this.id
}

resource "cloudflare_zone" "this" {
  zone       = var.zone
  account_id = var.account_id
  paused     = var.paused
  jump_start = var.jump_start
  plan       = var.plan
  type       = var.type
}

resource "cloudflare_zone_dnssec" "this" {
  count = var.enable_dnssec ? 1 : 0

  zone_id = local.zone_id
}

resource "cloudflare_record" "this" {
  for_each = var.records != null ? { for record in var.records : record.name => record } : {}

  zone_id = local.zone_id

  name  = coalesce(each.value.name, "@")
  type  = each.value.type
  value = each.value.value

  dynamic "data" {
    for_each = each.value.value == null && each.value.data != null ? [1] : []

    content {
      algorithm      = each.value.data.algorithm
      altitude       = each.value.data.altitude
      certificate    = each.value.data.certificate
      content        = each.value.data.content
      digest         = each.value.data.digest
      digest_type    = each.value.data.digest_type
      fingerprint    = each.value.data.fingerprint
      flags          = each.value.data.flags
      key_tag        = each.value.data.key_tag
      lat_degrees    = each.value.data.lat_degrees
      lat_direction  = each.value.data.lat_direction
      lat_minutes    = each.value.data.lat_minutes
      lat_seconds    = each.value.data.lat_seconds
      long_degrees   = each.value.data.long_degrees
      long_direction = each.value.data.long_direction
      long_minutes   = each.value.data.long_minutes
      long_seconds   = each.value.data.long_seconds
      matching_type  = each.value.data.matching_type
      name           = each.value.data.name
      order          = each.value.data.order
      port           = each.value.data.port
      precision_horz = each.value.data.precision_horz
      precision_vert = each.value.data.precision_vert
      preference     = each.value.data.preference
      priority       = each.value.data.priority
      proto          = each.value.data.proto
      protocol       = each.value.data.protocol
      public_key     = each.value.data.public_key
      regex          = each.value.data.regex
      replacement    = each.value.data.replacement
      selector       = each.value.data.selector
      service        = each.value.data.service
      size           = each.value.data.size
      tag            = each.value.data.tag
      target         = each.value.data.target
      type           = each.value.data.type
      usage          = each.value.data.usage
      value          = each.value.data.value
      weight         = each.value.data.weight
    }
  }

  priority = lookup(each.value, "priority", null)
  proxied  = lookup(each.value, "proxied", false)
  ttl      = lookup(each.value, "ttl", 1)

  allow_overwrite = lookup(each.value, "allow_overwrite", false)
}
