<!-- BEGIN_TF_DOCS -->
## Documentation


### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 3.23 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | >= 3.23 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [cloudflare_record.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_zones.domain](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zones) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_overwrite"></a> [allow\_overwrite](#input\_allow\_overwrite) | n/a | `bool` | `false` | no |
| <a name="input_data"></a> [data](#input\_data) | n/a | <pre>list(object({<br>      algorithm      = optional(number)<br>      altitude       = optional(number)<br>      certificate    = optional(string)<br>      content        = optional(string)<br>      digest         = optional(string)<br>      digest_type    = optional(number)<br>      fingerprint    = optional(string)<br>      flags          = optional(string)<br>      key_tag        = optional(number)<br>      lat_degrees    = optional(number)<br>      lat_direction  = optional(string)<br>      lat_minutes    = optional(number)<br>      lat_seconds    = optional(number)<br>      long_degrees   = optional(number)<br>      long_direction = optional(string)<br>      long_minutes   = optional(number)<br>      long_seconds   = optional(number)<br>      matching_type  = optional(number)<br>      name           = optional(string)<br>      order          = optional(number)<br>      port           = optional(number)<br>      precision_horz = optional(number)<br>      precision_vert = optional(number)<br>      preference     = optional(number)<br>      priority       = optional(number)<br>      proto          = optional(string)<br>      protocol       = optional(number)<br>      public_key     = optional(string)<br>      regex          = optional(string)<br>      replacement    = optional(string)<br>      selector       = optional(number)<br>      service        = optional(string)<br>      size           = optional(number)<br>      tag            = optional(string)<br>      target         = optional(string)<br>      type           = optional(number)<br>      usage          = optional(number)<br>      value          = optional(string)<br>      weight         = optional(number)<br>  }))</pre> | `[]` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_priority"></a> [priority](#input\_priority) | n/a | `number` | `1` | no |
| <a name="input_proxied"></a> [proxied](#input\_proxied) | n/a | `bool` | `false` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | n/a | `number` | `1` | no |
| <a name="input_type"></a> [type](#input\_type) | n/a | `string` | n/a | yes |
| <a name="input_value"></a> [value](#input\_value) | n/a | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_record_created_on"></a> [record\_created\_on](#output\_record\_created\_on) | The RFC3339 timestamp of when record was created. |
| <a name="output_record_hostnames"></a> [record\_hostnames](#output\_record\_hostnames) | The FQDN of the record. |
| <a name="output_record_ids"></a> [record\_ids](#output\_record\_ids) | The record ID. |
| <a name="output_record_metadata"></a> [record\_metadata](#output\_record\_metadata) | A key-value map of string metadata Cloudflare associates with a record. |
| <a name="output_record_modified_on"></a> [record\_modified\_on](#output\_record\_modified\_on) | The RFC3339 timestamp of when record were last modified. |
| <a name="output_record_proxiable"></a> [record\_proxiable](#output\_record\_proxiable) | Show record is proxied. |

<!-- END_TF_DOCS -->
