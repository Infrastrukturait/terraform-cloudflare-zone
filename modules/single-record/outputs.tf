output "record_ids" {
  value       = cloudflare_record.this.id
  description = "The record ID."
}

output "record_hostnames" {
  value       = cloudflare_record.this.hostname
  description = "The FQDN of the record."
}

output "record_proxiable" {
  value       = cloudflare_record.this.proxiable
  description = "Show record is proxied."
}

output "record_created_on" {
  value       = cloudflare_record.this.created_on
  description = "The RFC3339 timestamp of when record was created."
}

output "record_modified_on" {
  value       = cloudflare_record.this.modified_on
  description = "The RFC3339 timestamp of when record were last modified."
}

output "record_metadata" {
  value       = cloudflare_record.this.metadata
  description = "A key-value map of string metadata Cloudflare associates with a record."
}
