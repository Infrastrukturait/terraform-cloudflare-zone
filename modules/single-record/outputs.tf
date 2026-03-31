output "record_ids" {
  value       = cloudflare_dns_record.this.id
  description = "The record ID."
}

output "record_proxiable" {
  value       = cloudflare_dns_record.this.proxiable
  description = "Show record is proxied."
}

output "record_created_on" {
  value       = try(cloudflare_dns_record.this.created_on, null)
  description = "The RFC3339 timestamp of when record was created."
}

output "record_modified_on" {
  value       = cloudflare_dns_record.this.modified_on
  description = "The RFC3339 timestamp of when record were last modified."
}
