variable "zone" {
  type        = string
  description = "The DNS zone name which will be added, e.g. example.com."
}

variable "account_id" {
  type        = string
  default     = ""
  description = "Account ID to manage the zone resource in. You can get more information on how to find `account_id` at [this page](https://developers.cloudflare.com/fundamentals/get-started/basic-tasks/find-account-and-zone-ids/)."
}

variable "paused" {
  type        = bool
  default     = false
  description = "Indicates if the zone is only using Cloudflare DNS services. A true value means the zone will not receive security or performance benefits."
}

variable "jump_start" {
  type        = bool
  default     = false
  description = "Automatically attempt to fetch existing DNS records on creation. Ignored after zone is created."
}

variable "plan" {
  type        = string
  default     = "free"
  description = <<-EOT
    The desired plan for the zone. Can be updated once the one is created. Changing this value will create/cancel associated subscriptions.
    Possible values: `free`, `partners_free`, `pro`, `partners_pro`, `business`, `partners_business`, `enterprise`, `partners_enterprise`."
    You can get more information about available plans at [this page](https://www.cloudflare.com/plans/).
  EOT
}

variable "type" {
  type        = string
  default     = "full"
  description = <<-EOT
    A full zone implies that DNS is hosted with Cloudflare. A partial zone is typically a partner-hosted zone or a CNAME setup. Possible values: `full`, `partial`.
    To learn more and choose the right configuration for you, see the documentation about [full](https://developers.cloudflare.com/dns/zone-setups/full-setup/) or [partial CNAME](https://developers.cloudflare.com/dns/zone-setups/partial-setup/) setups.
  EOT
}


variable "enable_dnssec" {
  type        = bool
  default     = false
  description = "Enable or disable DNSSEC."
}


variable "records" {
  type = list(object({
    record_name = string
    type        = string
    name        = optional(string)
    value       = optional(string)
    data = optional(object({
      algorithm      = optional(number)
      altitude       = optional(number)
      certificate    = optional(string)
      content        = optional(string)
      digest         = optional(string)
      digest_type    = optional(number)
      fingerprint    = optional(string)
      flags          = optional(string)
      key_tag        = optional(number)
      lat_degrees    = optional(number)
      lat_direction  = optional(string)
      lat_minutes    = optional(number)
      lat_seconds    = optional(number)
      long_degrees   = optional(number)
      long_direction = optional(string)
      long_minutes   = optional(number)
      long_seconds   = optional(number)
      matching_type  = optional(number)
      name           = optional(string)
      order          = optional(number)
      port           = optional(number)
      precision_horz = optional(number)
      precision_vert = optional(number)
      preference     = optional(number)
      priority       = optional(number)
      proto          = optional(string)
      protocol       = optional(number)
      public_key     = optional(string)
      regex          = optional(string)
      replacement    = optional(string)
      selector       = optional(number)
      service        = optional(string)
      size           = optional(number)
      tag            = optional(string)
      target         = optional(string)
      type           = optional(number)
      usage          = optional(number)
      value          = optional(string)
      weight         = optional(number)
    }))
    priority        = optional(number)
    ttl             = optional(number)
    proxied         = optional(bool)
    allow_overwrite = optional(bool)
  }))
  default     = []
  description = <<-EOT
    Zone's DNS records.
    Possible values:
      * for the `type` argument: \"A\", \"AAAA\", \"CAA\", \"CERT\", \"CNAME\", \"DNSKEY\", \"DS\", \"HTTPS\", \"LOC\", \"MX\", \"NAPTR\", \"NS\", \"PTR\", \"SMIMEA\", \"SPF\", \"SRV\", \"SSHFP\", \"SVCB\", \"TLSA\", \"TXT\", \"URI\".
      *for the `priority` argument: between 0 and 65535.\nPossible values for the `ttl` argument: between 60 and 86400, or 1 for automatic."
  EOT

  # The provider does not check if either `value` or `data` is provided at the `terraform plan` stage
  validation {
    condition = alltrue([
      for i in var.records : try(i.value != null || i.data != null)
    ])
    error_message = "Either the value or the data must be provided for each record."
  }

  # The provider does not validate the `ttl` values at the `terraform plan` stage
  validation {
    condition = alltrue([
      for i in var.records : try(i.ttl == 1 || i.ttl >= 60 && i.ttl <= 86400, true)
    ])
    error_message = "The ttl values must be between 60 and 86400, or 1 for automatic."
  }

  # Actually, `priority` values validation is not required, it accepts any values, including negative ones, but for values outside the range from 0 to 65535, the resulting value may be unexpected for the end user
  validation {
    condition = alltrue([
      for i in var.records : try(i.priority >= 0 && i.priority <= 65535, true)
    ])
    error_message = "The priority values must be between 0 and 65535."
  }

  # The provider does not check if `priority` are provided for "MX" type records at the `terraform plan` stage
  validation {
    condition = alltrue([
      for i in var.records : try(i.type == "MX" ? i.priority != null : true)
    ])
    error_message = "The priority must not be null for each record of type \"MX\"."
  }
}
