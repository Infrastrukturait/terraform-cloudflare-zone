variable "account_id" {
  type        = string
  description = "Account ID to manage the zone resource in. You can get more information on how to find `account_id` at [this page](https://developers.cloudflare.com/fundamentals/get-started/basic-tasks/find-account-and-zone-ids/)."
}

variable "zone" {
  type        = string
  description = "The DNS zone name which will be added, e.g. example.com."
}

variable "zone_settings" {
  type = list(object({
    setting_id = string
    value      = optional(string)
    enabled    = optional(bool)
  }))
  default     = []
  description = <<-EOT
    Zone settings applied with `cloudflare_zone_setting`.

    Some settings use `value`, while others use `enabled`.
  EOT

  validation {
    condition = length(var.zone_settings) == length(distinct([
      for s in var.zone_settings : s.setting_id
    ]))
    error_message = "Each zone setting_id must be unique."
  }

  validation {
    condition = alltrue([
      for s in var.zone_settings : length(trimspace(s.setting_id)) > 0
    ])
    error_message = "Each zone setting must define a non-empty setting_id."
  }
}

variable "paused" {
  type        = bool
  default     = false
  description = "Indicates if the zone is only using Cloudflare DNS services. A true value means the zone will not receive security or performance benefits."
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
    comment     = optional(string)
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
    priority = optional(number)
    ttl      = optional(number)
    proxied  = optional(bool)
  }))
  default     = []
  description = <<-EOT
    Zone's raw DNS records.

    Use this input for records that are not covered by dedicated helpers.
    Possible values:
      * for the `type` argument: "A", "AAAA", "CAA", "CERT", "CNAME", "DNSKEY", "DS", "HTTPS", "LOC", "MX", "NAPTR", "NS", "PTR", "SMIMEA", "SPF", "SRV", "SSHFP", "SVCB", "TLSA", "TXT", "URI".
      * for the `priority` argument: between 0 and 65535.
      * possible values for the `ttl` argument: between 60 and 86400, or 1 for automatic.
      * `comment` is an optional Cloudflare DNS record comment.
  EOT

  validation {
    condition = length(var.records) == length(distinct([
      for r in var.records : r.record_name
    ]))
    error_message = "Each raw record_name must be unique."
  }

  validation {
    condition = alltrue([
      for i in var.records : try(i.value != null || i.data != null)
    ])
    error_message = "Either the value or the data must be provided for each raw record."
  }

  validation {
    condition = alltrue([
      for i in var.records : try(i.ttl == 1 || i.ttl >= 60 && i.ttl <= 86400, true)
    ])
    error_message = "The ttl values must be between 60 and 86400, or 1 for automatic."
  }

  validation {
    condition = alltrue([
      for i in var.records : try(i.priority >= 0 && i.priority <= 65535, true)
    ])
    error_message = "The priority values must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for i in var.records : try(i.type == "MX" ? i.priority != null : true)
    ])
    error_message = "The priority must not be null for each raw record of type \"MX\"."
  }
}

variable "mx" {
  type = object({
    names = optional(list(string), ["@"])
    servers = list(object({
      host     = string
      priority = number
    }))
    ttl     = optional(number)
    comment = optional(string)
  })
  default     = null
  description = <<-EOT
    Helper for MX records.

    The helper creates one MX record for each combination of `names` and `servers`.
    Example:

    ```hcl
    mx = {
      names = ["@", "mail"]
      servers = [
        {
          host     = "mx1.provider.com"
          priority = 10
        },
        {
          host     = "mx2.provider.com"
          priority = 20
        }
      ]
    }
    ```
  EOT

  validation {
    condition     = var.mx == null ? true : length(var.mx.servers) > 0
    error_message = "The mx helper must define at least one server."
  }

  validation {
    condition = var.mx == null ? true : alltrue([
      for name in try(var.mx.names, ["@"]) : length(trimspace(name)) > 0
    ])
    error_message = "Each mx helper name must be non-empty. Use \"@\" for the zone apex."
  }

  validation {
    condition = var.mx == null ? true : alltrue([
      for server in var.mx.servers :
      length(trimspace(server.host)) > 0 && server.priority >= 0 && server.priority <= 65535
    ])
    error_message = "Each mx helper server must define a non-empty host and a priority between 0 and 65535."
  }

  validation {
    condition     = var.mx == null ? true : try(var.mx.ttl == null || var.mx.ttl == 1 || var.mx.ttl >= 60 && var.mx.ttl <= 86400, true)
    error_message = "The mx helper ttl must be between 60 and 86400, or 1 for automatic."
  }
}

variable "spf" {
  type = object({
    name     = optional(string, "@")
    includes = optional(list(string), [])
    ip4s     = optional(list(string), [])
    ip6s     = optional(list(string), [])
    a        = optional(bool, false)
    mx       = optional(bool, false)
    redirect = optional(string)
    all      = optional(string, "fail")
    ttl      = optional(number)
    comment  = optional(string)
  })
  default     = null
  description = <<-EOT
    Helper for an SPF TXT record.

    This helper is semantic: instead of passing raw SPF terms, provide inputs such as
    `includes`, `ip4s`, `ip6s`, `a`, `mx`, `redirect` and `all`.

    Example:

    ```hcl
    spf = {
      includes = ["_spf.google.com", "spf.mailgun.org"]
      ip4s     = ["192.0.2.10", "198.51.100.0/24"]
      all      = "softfail"
    }
    ```
  EOT

  validation {
    condition     = var.spf == null ? true : contains(["allow", "fail", "neutral", "softfail"], var.spf.all)
    error_message = "The spf helper all value must be one of: allow, fail, neutral, softfail."
  }

  validation {
    condition     = var.spf == null ? true : length(trimspace(try(var.spf.name, "@"))) > 0
    error_message = "The spf helper name must be non-empty. Use \"@\" for the zone apex."
  }

  validation {
    condition = var.spf == null ? true : alltrue([
      for include in try(var.spf.includes, []) : length(trimspace(include)) > 0
    ])
    error_message = "Each spf helper include must be non-empty and must not include surrounding whitespace."
  }

  validation {
    condition = var.spf == null ? true : alltrue([
      for ip in concat(try(var.spf.ip4s, []), try(var.spf.ip6s, [])) : length(trimspace(ip)) > 0
    ])
    error_message = "Each spf helper IP entry must be non-empty."
  }

  validation {
    condition     = var.spf == null ? true : try(var.spf.redirect == null || length(trimspace(var.spf.redirect)) > 0, true)
    error_message = "The spf helper redirect must be null or a non-empty domain name."
  }

  validation {
    condition     = var.spf == null ? true : try(var.spf.ttl == null || var.spf.ttl == 1 || var.spf.ttl >= 60 && var.spf.ttl <= 86400, true)
    error_message = "The spf helper ttl must be between 60 and 86400, or 1 for automatic."
  }
}

variable "dmarc" {
  type = object({
    policy           = string
    subdomain_policy = optional(string)
    percent          = optional(number, 100)
    spf_mode         = optional(string, "relaxed")
    dkim_mode        = optional(string, "relaxed")
    rua              = optional(list(string), [])
    ruf              = optional(list(string), [])
    fo               = optional(string)
    ttl              = optional(number)
    comment          = optional(string)
  })
  default     = null
  description = <<-EOT
    Helper for the DMARC TXT record published at `_dmarc`.

    Example:

    ```hcl
    dmarc = {
      policy    = "quarantine"
      rua       = ["mailto:dmarc@example.com"]
      spf_mode  = "relaxed"
      dkim_mode = "relaxed"
    }
    ```
  EOT

  validation {
    condition     = var.dmarc == null ? true : contains(["none", "quarantine", "reject"], var.dmarc.policy)
    error_message = "The dmarc helper policy must be one of: none, quarantine, reject."
  }

  validation {
    condition     = var.dmarc == null ? true : try(var.dmarc.subdomain_policy == null || contains(["none", "quarantine", "reject"], var.dmarc.subdomain_policy), true)
    error_message = "The dmarc helper subdomain_policy must be null or one of: none, quarantine, reject."
  }

  validation {
    condition     = var.dmarc == null ? true : contains(["relaxed", "strict"], var.dmarc.spf_mode) && contains(["relaxed", "strict"], var.dmarc.dkim_mode)
    error_message = "The dmarc helper spf_mode and dkim_mode must be either relaxed or strict."
  }

  validation {
    condition     = var.dmarc == null ? true : var.dmarc.percent >= 0 && var.dmarc.percent <= 100
    error_message = "The dmarc helper percent must be between 0 and 100."
  }

  validation {
    condition = var.dmarc == null ? true : alltrue([
      for address in concat(try(var.dmarc.rua, []), try(var.dmarc.ruf, [])) : length(trimspace(address)) > 0
    ])
    error_message = "Each dmarc helper rua and ruf entry must be non-empty."
  }

  validation {
    condition     = var.dmarc == null ? true : try(var.dmarc.fo == null || length(trimspace(var.dmarc.fo)) > 0, true)
    error_message = "The dmarc helper fo value must be null or non-empty."
  }

  validation {
    condition     = var.dmarc == null ? true : try(var.dmarc.ttl == null || var.dmarc.ttl == 1 || var.dmarc.ttl >= 60 && var.dmarc.ttl <= 86400, true)
    error_message = "The dmarc helper ttl must be between 60 and 86400, or 1 for automatic."
  }
}

variable "tlsrpt" {
  type = object({
    rua     = list(string)
    ttl     = optional(number)
    comment = optional(string)
  })
  default     = null
  description = <<-EOT
    Helper for the SMTP TLS Reporting TXT record published at `_smtp._tls`.

    Example:

    ```hcl
    tlsrpt = {
      rua = ["mailto:tlsrpt@example.com"]
    }
    ```
  EOT

  validation {
    condition     = var.tlsrpt == null ? true : length(var.tlsrpt.rua) > 0
    error_message = "The tlsrpt helper must define at least one rua destination."
  }

  validation {
    condition = var.tlsrpt == null ? true : alltrue([
      for address in var.tlsrpt.rua : length(trimspace(address)) > 0
    ])
    error_message = "Each tlsrpt helper rua entry must be non-empty."
  }

  validation {
    condition     = var.tlsrpt == null ? true : try(var.tlsrpt.ttl == null || var.tlsrpt.ttl == 1 || var.tlsrpt.ttl >= 60 && var.tlsrpt.ttl <= 86400, true)
    error_message = "The tlsrpt helper ttl must be between 60 and 86400, or 1 for automatic."
  }
}

variable "dkim" {
  type = map(object({
    type       = string
    public_key = optional(string)
    key_type   = optional(string, "rsa")
    target     = optional(string)
    ttl        = optional(number)
    comment    = optional(string)
  }))
  default     = null
  description = <<-EOT
    Helper for DKIM DNS records.

    The map key is the DKIM selector. Supported record types are `TXT` and `CNAME`.

    Example:

    ```hcl
    dkim = {
      selector1 = {
        type       = "TXT"
        public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A..."
      }

      google = {
        type   = "CNAME"
        target = "google._domainkey.provider.net"
      }
    }
    ```
  EOT

  validation {
    condition = var.dkim == null ? true : alltrue([
      for selector, cfg in var.dkim :
      length(trimspace(selector)) > 0 && contains(["TXT", "CNAME"], upper(cfg.type))
    ])
    error_message = "Each dkim helper entry must define a non-empty selector and a type of TXT or CNAME."
  }

  validation {
    condition = var.dkim == null ? true : alltrue([
      for selector, cfg in var.dkim :
      upper(cfg.type) == "TXT"
      ? try(length(trimspace(cfg.public_key)) > 0, false) && try(cfg.target == null, true)
      : try(length(trimspace(cfg.target)) > 0, false) && try(cfg.public_key == null, true)
    ])
    error_message = "For dkim helper entries: TXT requires public_key and must not define target; CNAME requires target and must not define public_key."
  }

  validation {
    condition = var.dkim == null ? true : alltrue([
      for selector, cfg in var.dkim :
      try(cfg.ttl == null || cfg.ttl == 1 || cfg.ttl >= 60 && cfg.ttl <= 86400, true)
    ])
    error_message = "Each dkim helper ttl must be between 60 and 86400, or 1 for automatic."
  }

  validation {
    condition = var.dkim == null ? true : alltrue([
      for selector, cfg in var.dkim :
      upper(cfg.type) == "TXT" ? length(trimspace(try(cfg.key_type, "rsa"))) > 0 : true
    ])
    error_message = "Each TXT dkim helper entry must define a non-empty key_type when provided."
  }
}

variable "comment" {
  type        = string
  default     = ""
  description = "Optional global comment added to all DNS records that do not define their own comment."
}

variable "rulesets" {
  type = list(object({
    key           = string
    name          = string
    description   = optional(string)
    kind          = string
    phase         = string
    account_level = optional(bool)

    rules = optional(list(object({
      ref         = string
      action      = string
      expression  = optional(string)
      description = optional(string)
      enabled     = optional(bool)

      action_parameters = optional(object({
        cache                      = optional(bool)
        origin_error_page_passthru = optional(bool)
        respect_strong_etags       = optional(bool)
        version                    = optional(string)

        response = optional(object({
          status_code  = optional(number)
          content      = optional(string)
          content_type = optional(string)
        }))

        from_value = optional(object({
          status_code           = optional(number)
          preserve_query_string = optional(bool)

          target_url = optional(object({
            value      = optional(string)
            expression = optional(string)
          }))
        }))

        edge_ttl = optional(object({
          mode    = string
          default = optional(number)

          status_code_ttl = optional(list(object({
            status_code = optional(number)
            status_code_range = optional(object({
              from = number
              to   = number
            }))
            value = number
          })))
        }))

        browser_ttl = optional(object({
          mode    = string
          default = optional(number)
        }))

        serve_stale = optional(object({
          disable_stale_while_updating = optional(bool)
        }))

        cache_key = optional(object({
          ignore_query_strings_order = optional(bool)
          cache_by_device_type       = optional(bool)
        }))

        uri = optional(object({
          path = optional(object({
            value      = optional(string)
            expression = optional(string)
          }))
        }))
      }))

      logging = optional(object({
        enabled = bool
      }))

      ratelimit = optional(object({
        characteristics            = list(string)
        period                     = number
        requests_per_period        = number
        mitigation_timeout         = number
        requests_to_origin         = optional(bool)
        score_per_period           = optional(number)
        score_response_header_name = optional(string)
        counting_expression        = optional(string)
      }))

      exposed_credential_check = optional(object({
        username_expression = string
        password_expression = string
      }))
    })))
  }))
  default     = []
  description = <<-EOT
    Cloudflare Ruleset Engine wrapper.

    Each item creates one `cloudflare_ruleset` resource.
    Supported scopes:
      * zone-level rulesets when `account_level = false` or omitted
      * account-level rulesets when `account_level = true`

    This wrapper accepts a simplified input shape and internally converts it
    to the Cloudflare provider v5 resource schema.
  EOT

  validation {
    condition = alltrue([
      for rs in var.rulesets :
      length(trimspace(rs.key)) > 0 &&
      length(trimspace(rs.name)) > 0 &&
      length(trimspace(rs.kind)) > 0 &&
      length(trimspace(rs.phase)) > 0
    ])
    error_message = "Each ruleset must define non-empty key, name, kind and phase."
  }

  validation {
    condition = length(var.rulesets) == length(distinct([
      for rs in var.rulesets : rs.key
    ]))
    error_message = "Each ruleset key must be unique."
  }

  validation {
    condition = alltrue(flatten([
      for rs in var.rulesets : [
        for rule in try(rs.rules, []) :
        length(trimspace(rule.ref)) > 0 &&
        length(trimspace(rule.action)) > 0
      ]
    ]))
    error_message = "Each rule must define non-empty ref and action."
  }
}
