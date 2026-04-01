output "zone_id" {
  description = "The zone ID."
  value       = module.zone.zone_id
}

output "record_ids" {
  description = "Managed DNS record IDs keyed by record key."
  value       = module.zone.record_ids
}

output "record_names" {
  description = "Managed DNS record names keyed by record key."
  value       = module.zone.record_names
}
