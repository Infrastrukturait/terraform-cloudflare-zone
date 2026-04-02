<!-- BEGIN_TF_DOCS -->
## Documentation


### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 5.18.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [cloudflare_dns_record.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_ruleset.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/ruleset) | resource |
| [cloudflare_zone.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone) | resource |
| [cloudflare_zone_dnssec.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone_dnssec) | resource |
| [cloudflare_zone_setting.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone_setting) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Account ID to manage the zone resource in. You can get more information on how to find `account_id` at [this page](https://developers.cloudflare.com/fundamentals/get-started/basic-tasks/find-account-and-zone-ids/). | `string` | n/a | yes |
| <a name="input_comment"></a> [comment](#input\_comment) | Optional global comment added to all DNS records that do not define their own comment. | `string` | `""` | no |
| <a name="input_dkim"></a> [dkim](#input\_dkim) | Helper for DKIM DNS records.<br><br>The map key is the DKIM selector. Supported record types are `TXT` and `CNAME`.<br><br>Example:<pre>hcl<br>dkim = {<br>  selector1 = {<br>    type       = "TXT"<br>    public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A..."<br>  }<br><br>  google = {<br>    type   = "CNAME"<br>    target = "google._domainkey.provider.net"<br>  }<br>}</pre> | <pre>map(object({<br>    type       = string<br>    public_key = optional(string)<br>    key_type   = optional(string, "rsa")<br>    target     = optional(string)<br>    ttl        = optional(number)<br>    comment    = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_dmarc"></a> [dmarc](#input\_dmarc) | Helper for the DMARC TXT record published at `_dmarc`.<br><br>Example:<pre>hcl<br>dmarc = {<br>  policy    = "quarantine"<br>  rua       = ["mailto:dmarc@example.com"]<br>  spf_mode  = "relaxed"<br>  dkim_mode = "relaxed"<br>}</pre> | <pre>object({<br>    policy           = string<br>    subdomain_policy = optional(string)<br>    percent          = optional(number, 100)<br>    spf_mode         = optional(string, "relaxed")<br>    dkim_mode        = optional(string, "relaxed")<br>    rua              = optional(list(string), [])<br>    ruf              = optional(list(string), [])<br>    fo               = optional(string)<br>    ttl              = optional(number)<br>    comment          = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_enable_dnssec"></a> [enable\_dnssec](#input\_enable\_dnssec) | Enable or disable DNSSEC. | `bool` | `false` | no |
| <a name="input_mx"></a> [mx](#input\_mx) | Helper for MX records.<br><br>The helper creates one MX record for each combination of `names` and `servers`.<br>Example:<pre>hcl<br>mx = {<br>  names = ["@", "mail"]<br>  servers = [<br>    {<br>      host     = "mx1.provider.com"<br>      priority = 10<br>    },<br>    {<br>      host     = "mx2.provider.com"<br>      priority = 20<br>    }<br>  ]<br>}</pre> | <pre>object({<br>    names = optional(list(string), ["@"])<br>    servers = list(object({<br>      host     = string<br>      priority = number<br>    }))<br>    ttl     = optional(number)<br>    comment = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_paused"></a> [paused](#input\_paused) | Indicates if the zone is only using Cloudflare DNS services. A true value means the zone will not receive security or performance benefits. | `bool` | `false` | no |
| <a name="input_records"></a> [records](#input\_records) | Zone's raw DNS records.<br><br>Use this input for records that are not covered by dedicated helpers.<br>Possible values:<br>  * for the `type` argument: "A", "AAAA", "CAA", "CERT", "CNAME", "DNSKEY", "DS", "HTTPS", "LOC", "MX", "NAPTR", "NS", "PTR", "SMIMEA", "SPF", "SRV", "SSHFP", "SVCB", "TLSA", "TXT", "URI".<br>  * for the `priority` argument: between 0 and 65535.<br>  * possible values for the `ttl` argument: between 60 and 86400, or 1 for automatic.<br>  * `comment` is an optional Cloudflare DNS record comment. | <pre>list(object({<br>    record_name = string<br>    type        = string<br>    name        = optional(string)<br>    value       = optional(string)<br>    comment     = optional(string)<br>    data = optional(object({<br>      algorithm      = optional(number)<br>      altitude       = optional(number)<br>      certificate    = optional(string)<br>      content        = optional(string)<br>      digest         = optional(string)<br>      digest_type    = optional(number)<br>      fingerprint    = optional(string)<br>      flags          = optional(string)<br>      key_tag        = optional(number)<br>      lat_degrees    = optional(number)<br>      lat_direction  = optional(string)<br>      lat_minutes    = optional(number)<br>      lat_seconds    = optional(number)<br>      long_degrees   = optional(number)<br>      long_direction = optional(string)<br>      long_minutes   = optional(number)<br>      long_seconds   = optional(number)<br>      matching_type  = optional(number)<br>      name           = optional(string)<br>      order          = optional(number)<br>      port           = optional(number)<br>      precision_horz = optional(number)<br>      precision_vert = optional(number)<br>      preference     = optional(number)<br>      priority       = optional(number)<br>      proto          = optional(string)<br>      protocol       = optional(number)<br>      public_key     = optional(string)<br>      regex          = optional(string)<br>      replacement    = optional(string)<br>      selector       = optional(number)<br>      service        = optional(string)<br>      size           = optional(number)<br>      tag            = optional(string)<br>      target         = optional(string)<br>      type           = optional(number)<br>      usage          = optional(number)<br>      value          = optional(string)<br>      weight         = optional(number)<br>    }))<br>    priority = optional(number)<br>    ttl      = optional(number)<br>    proxied  = optional(bool)<br>  }))</pre> | `[]` | no |
| <a name="input_rulesets"></a> [rulesets](#input\_rulesets) | Cloudflare Ruleset Engine wrapper.<br><br>Each item creates one `cloudflare_ruleset` resource.<br>Supported scopes:<br>  * zone-level rulesets when `account_level = false` or omitted<br>  * account-level rulesets when `account_level = true`<br><br>This wrapper accepts a simplified input shape and internally converts it<br>to the Cloudflare provider v5 resource schema. | <pre>list(object({<br>    key           = string<br>    name          = string<br>    description   = optional(string)<br>    kind          = string<br>    phase         = string<br>    account_level = optional(bool)<br><br>    rules = optional(list(object({<br>      ref         = string<br>      action      = string<br>      expression  = optional(string)<br>      description = optional(string)<br>      enabled     = optional(bool)<br><br>      action_parameters = optional(object({<br>        cache                      = optional(bool)<br>        origin_error_page_passthru = optional(bool)<br>        respect_strong_etags       = optional(bool)<br>        version                    = optional(string)<br><br>        response = optional(object({<br>          status_code  = optional(number)<br>          content      = optional(string)<br>          content_type = optional(string)<br>        }))<br><br>        from_value = optional(object({<br>          status_code           = optional(number)<br>          preserve_query_string = optional(bool)<br><br>          target_url = optional(object({<br>            value      = optional(string)<br>            expression = optional(string)<br>          }))<br>        }))<br><br>        edge_ttl = optional(object({<br>          mode    = string<br>          default = optional(number)<br><br>          status_code_ttl = optional(list(object({<br>            status_code = optional(number)<br>            status_code_range = optional(object({<br>              from = number<br>              to   = number<br>            }))<br>            value = number<br>          })))<br>        }))<br><br>        browser_ttl = optional(object({<br>          mode    = string<br>          default = optional(number)<br>        }))<br><br>        serve_stale = optional(object({<br>          disable_stale_while_updating = optional(bool)<br>        }))<br><br>        cache_key = optional(object({<br>          ignore_query_strings_order = optional(bool)<br>          cache_by_device_type       = optional(bool)<br>        }))<br><br>        uri = optional(object({<br>          path = optional(object({<br>            value      = optional(string)<br>            expression = optional(string)<br>          }))<br>        }))<br>      }))<br><br>      logging = optional(object({<br>        enabled = bool<br>      }))<br><br>      ratelimit = optional(object({<br>        characteristics            = list(string)<br>        period                     = number<br>        requests_per_period        = number<br>        mitigation_timeout         = number<br>        requests_to_origin         = optional(bool)<br>        score_per_period           = optional(number)<br>        score_response_header_name = optional(string)<br>        counting_expression        = optional(string)<br>      }))<br><br>      exposed_credential_check = optional(object({<br>        username_expression = string<br>        password_expression = string<br>      }))<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_spf"></a> [spf](#input\_spf) | Helper for an SPF TXT record.<br><br>This helper is semantic: instead of passing raw SPF terms, provide inputs such as<br>`includes`, `ip4s`, `ip6s`, `a`, `mx`, `redirect` and `all`.<br><br>Example:<pre>hcl<br>spf = {<br>  includes = ["_spf.google.com", "spf.mailgun.org"]<br>  ip4s     = ["192.0.2.10", "198.51.100.0/24"]<br>  all      = "softfail"<br>}</pre> | <pre>object({<br>    name     = optional(string, "@")<br>    includes = optional(list(string), [])<br>    ip4s     = optional(list(string), [])<br>    ip6s     = optional(list(string), [])<br>    a        = optional(bool, false)<br>    mx       = optional(bool, false)<br>    redirect = optional(string)<br>    all      = optional(string, "fail")<br>    ttl      = optional(number)<br>    comment  = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_tlsrpt"></a> [tlsrpt](#input\_tlsrpt) | Helper for the SMTP TLS Reporting TXT record published at `_smtp._tls`.<br><br>Example:<pre>hcl<br>tlsrpt = {<br>  rua = ["mailto:tlsrpt@example.com"]<br>}</pre> | <pre>object({<br>    rua     = list(string)<br>    ttl     = optional(number)<br>    comment = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | A full zone implies that DNS is hosted with Cloudflare. A partial zone is typically a partner-hosted zone or a CNAME setup. Possible values: `full`, `partial`.<br>To learn more and choose the right configuration for you, see the documentation about [full](https://developers.cloudflare.com/dns/zone-setups/full-setup/) or [partial CNAME](https://developers.cloudflare.com/dns/zone-setups/partial-setup/) setups. | `string` | `"full"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The DNS zone name which will be added, e.g. example.com. | `string` | n/a | yes |
| <a name="input_zone_settings"></a> [zone\_settings](#input\_zone\_settings) | Zone settings applied with `cloudflare_zone_setting`.<br><br>Some settings use `value`, while others use `enabled`. | <pre>list(object({<br>    setting_id = string<br>    value      = optional(string)<br>    enabled    = optional(bool)<br>  }))</pre> | `[]` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_algorithm"></a> [algorithm](#output\_algorithm) | Zone DNSSEC algorithm. |
| <a name="output_digest"></a> [digest](#output\_digest) | Zone DNSSEC digest. |
| <a name="output_digest_algorithm"></a> [digest\_algorithm](#output\_digest\_algorithm) | Digest algorithm used for Zone DNSSEC. |
| <a name="output_digest_type"></a> [digest\_type](#output\_digest\_type) | Digest Type for the Zone DNSSEC. |
| <a name="output_dnssec_status"></a> [dnssec\_status](#output\_dnssec\_status) | The status of the Zone DNSSEC. |
| <a name="output_ds"></a> [ds](#output\_ds) | DS for the Zone DNSSEC. |
| <a name="output_flags"></a> [flags](#output\_flags) | Zone DNSSEC flags. |
| <a name="output_key_tag"></a> [key\_tag](#output\_key\_tag) | Key Tag for the Zone DNSSEC. |
| <a name="output_key_type"></a> [key\_type](#output\_key\_type) | Key type used for Zone DNSSEC. |
| <a name="output_meta"></a> [meta](#output\_meta) | Map of booleans, indicating some zone statuses or flags. |
| <a name="output_modified_on"></a> [modified\_on](#output\_modified\_on) | Zone DNSSEC updated time. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | Cloudflare-assigned name servers. This is only populated for zones that use Cloudflare DNS. |
| <a name="output_public_key"></a> [public\_key](#output\_public\_key) | Public Key for the Zone DNSSEC. |
| <a name="output_record_ids"></a> [record\_ids](#output\_record\_ids) | The record IDs keyed by the module's managed record key. |
| <a name="output_record_modified_on"></a> [record\_modified\_on](#output\_record\_modified\_on) | The RFC3339 timestamp of when the records were last modified. |
| <a name="output_record_names"></a> [record\_names](#output\_record\_names) | The managed DNS record names keyed by the module's managed record key. |
| <a name="output_record_proxiable"></a> [record\_proxiable](#output\_record\_proxiable) | Shows whether these records can be proxied. This must be true if setting proxied = true. |
| <a name="output_status"></a> [status](#output\_status) | Status of the zone. Valid values: active, pending, initializing, moved. |
| <a name="output_vanity_name_servers"></a> [vanity\_name\_servers](#output\_vanity\_name\_servers) | List of Vanity Nameservers, if set. |
| <a name="output_verification_key"></a> [verification\_key](#output\_verification\_key) | Contains the TXT record value to validate domain ownership. This is only populated for zones of type partial. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The zone ID. |

### Examples

```hcl
module "zone" {
  source = "../.."

  zone       = var.zone
  account_id = var.account_id

  comment = "Managed by Terraform"

  records = [
    {
      record_name = "bastion-example-a"
      name        = "bastion-example"
      value       = "1.1.1.1"
      type        = "A"
      ttl         = 1
    },
    {
      record_name = "api-example-a"
      name        = "api-example"
      value       = "1.1.1.1"
      type        = "A"
      ttl         = 1
    }
  ]

  mx = {
    names = ["@"]
    servers = [
      {
        host     = "mx1.mail.example.net"
        priority = 10
      },
      {
        host     = "mx2.mail.example.net"
        priority = 20
      }
    ]
    ttl = 3600
  }

  spf = {
    includes = ["_spf.google.com", "spf.mailgun.org"]
    ip4s     = ["192.0.2.10"]
    all      = "softfail"
    ttl      = 3600
  }

  dmarc = {
    policy    = "quarantine"
    rua       = ["mailto:dmarc@example.com"]
    spf_mode  = "relaxed"
    dkim_mode = "relaxed"
    percent   = 100
    ttl       = 3600
  }

  tlsrpt = {
    rua = ["mailto:tlsrpt@example.com"]
    ttl = 3600
  }

  dkim = {
    selector1 = {
      type       = "TXT"
      public_key = "REPLACE_WITH_YOUR_DKIM_PUBLIC_KEY"
      ttl        = 3600
    }

    google = {
      type   = "CNAME"
      target = "google._domainkey.mail.provider.example.net"
      ttl    = 3600
    }
  }

  zone_settings = [
    {
      setting_id = "always_use_https"
      enabled    = true
    }
  ]

  rulesets = [
    {
      key   = "zone-http-config"
      name  = "Zone HTTP configuration"
      kind  = "zone"
      phase = "http_request_dynamic_redirect"

      rules = [
        {
          ref         = "redirect-http-to-https"
          description = "Redirect all HTTP requests to HTTPS"
          action      = "redirect"
          expression  = "(http.request.scheme eq \"http\")"
          enabled     = true

          action_parameters = {
            from_value = {
              status_code           = 301
              preserve_query_string = true

              target_url = {
                expression = "concat(\"https://\", http.host, http.request.uri.path)"
              }
            }
          }
        }
      ]
    }
  ]
}
```

<!-- END_TF_DOCS -->