variable "domain_name" {
  type        = string
  description = "Domain name to which we will add the record."
}

variable "name" {
  type        = string
  default     = null
  description = "The name of the record."
}

variable "type" {
  type        = string
  description = "The type of the record."
}

variable "value" {
  type        = string
  default     = null
  description = "The value of the record."

  validation {
    condition     = (var.value != null && length(var.data) == 0) || (var.value == null && length(var.data) > 0)
    error_message = "Exactly one of value or data must be provided."
  }
}

variable "account_id" {
  type        = string
  default     = ""
  description = "Cloudflare account ID."
}

variable "comment" {
  type        = string
  default     = null
  description = "Optional Cloudflare DNS record comment."
}

variable "priority" {
  type        = number
  default     = 1
  description = "The priority of the record. Default value is `1`."

  validation {
    condition     = try(var.priority >= 0 && var.priority <= 65535, true)
    error_message = "The priority values must be between 0 and 65535."
  }
}

variable "ttl" {
  type        = number
  default     = 1
  description = "The TTL of the record. Default value is `1`."

  validation {
    condition     = try(var.ttl == 1 || var.ttl >= 60 && var.ttl <= 86400, true)
    error_message = "The ttl values must be between 60 and 86400, or 1 for automatic."
  }
}

variable "proxied" {
  type        = bool
  default     = false
  description = "Set the record to gets Cloudflare's origin protection"
}

variable "data" {
  type = list(object({
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
  default     = []
  description = "List of metadata objects for a record."
}
