output "zone_id" {
  value       = cloudflare_zone.this.id
  description = "The zone ID."
}

output "meta" {
  value       = cloudflare_zone.this.meta
  description = "Map of booleans, indicating some zone statuses or flags."
}

output "name_servers" {
  value       = cloudflare_zone.this.name_servers
  description = "Cloudflare-assigned name servers. This is only populated for zones that use Cloudflare DNS."
}

output "status" {
  value       = cloudflare_zone.this.status
  description = "Status of the zone. Valid values: active, pending, initializing, moved, deleted, deactivated."
}

output "vanity_name_servers" {
  value       = cloudflare_zone.this.vanity_name_servers
  description = "List of Vanity Nameservers (if set)."
}

output "verification_key" {
  value       = cloudflare_zone.this.verification_key
  description = "Contains the TXT record value to validate domain ownership. This is only populated for zones of type partial."
}

output "dnssec_status" {
  value       = try(cloudflare_zone_dnssec.this[0].status, null)
  description = "The status of the Zone DNSSEC."
}

output "flags" {
  value       = try(cloudflare_zone_dnssec.this[0].flags, null)
  description = "Zone DNSSEC flags."
}

output "algorithm" {
  value       = try(cloudflare_zone_dnssec.this[0].algorithm, null)
  description = "Zone DNSSEC algorithm."
}

output "key_type" {
  value       = try(cloudflare_zone_dnssec.this[0].key_type, null)
  description = "Key type used for Zone DNSSEC."
}

output "digest_type" {
  value       = try(cloudflare_zone_dnssec.this[0].digest_type, null)
  description = "Digest Type for Zone DNSSEC."
}

output "digest_algorithm" {
  value       = try(cloudflare_zone_dnssec.this[0].digest_algorithm, null)
  description = "Digest algorithm use for Zone DNSSEC."
}

output "digest" {
  value       = try(cloudflare_zone_dnssec.this[0].digest, null)
  description = "Zone DNSSEC digest."
}

output "ds" {
  value       = try(cloudflare_zone_dnssec.this[0].ds, null)
  description = "DS for the Zone DNSSEC."
}

output "key_tag" {
  value       = try(cloudflare_zone_dnssec.this[0].key_tag, null)
  description = "Key Tag for the Zone DNSSEC."
}

output "public_key" {
  value       = try(cloudflare_zone_dnssec.this[0].public_key, null)
  description = "Public Key for the Zone DNSSEC."
}

output "modified_on" {
  value       = try(cloudflare_zone_dnssec.this[0].modified_on, null)
  description = "Zone DNSSEC updated time."
}

output "record_ids" {
  value       = { for k, v in cloudflare_record.this : k => v.id }
  description = "The record IDs."
}

output "record_hostnames" {
  value       = { for k, v in cloudflare_record.this : k => v.hostname }
  description = "The FQDN of the records."
}

output "record_proxiable" {
  value       = { for k, v in cloudflare_record.this : k => v.proxiable }
  description = "Shows whether these records can be proxied, must be true if setting proxied=true."
}

output "record_created_on" {
  value       = { for k, v in cloudflare_record.this : k => v.created_on }
  description = "The RFC3339 timestamp of when the records were created."
}

output "record_modified_on" {
  value       = { for k, v in cloudflare_record.this : k => v.modified_on }
  description = "The RFC3339 timestamp of when the records were last modified."
}

output "record_metadata" {
  value       = { for k, v in cloudflare_record.this : k => v.metadata }
  description = "A key-value map of string metadata Cloudflare associates with the records."
}
