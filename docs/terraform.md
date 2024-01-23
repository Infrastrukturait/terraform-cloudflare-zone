<!-- BEGIN_TF_DOCS -->
## Documentation


### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 3.23 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [cloudflare_record.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_zone.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone) | resource |
| [cloudflare_zone_dnssec.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone_dnssec) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Account ID to manage the zone resource in. You can get more information on how to find `account_id` at [this page](https://developers.cloudflare.com/fundamentals/get-started/basic-tasks/find-account-and-zone-ids/). | `string` | `""` | no |
| <a name="input_enable_dnssec"></a> [enable\_dnssec](#input\_enable\_dnssec) | Enable or disable DNSSEC. | `bool` | `false` | no |
| <a name="input_jump_start"></a> [jump\_start](#input\_jump\_start) | Automatically attempt to fetch existing DNS records on creation. Ignored after zone is created. | `bool` | `false` | no |
| <a name="input_paused"></a> [paused](#input\_paused) | Indicates if the zone is only using Cloudflare DNS services. A true value means the zone will not receive security or performance benefits. | `bool` | `false` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The desired plan for the zone. Can be updated once the one is created. Changing this value will create/cancel associated subscriptions.<br>Possible values: `free`, `partners_free`, `pro`, `partners_pro`, `business`, `partners_business`, `enterprise`, `partners_enterprise`."<br>You can get more information about available plans at [this page](https://www.cloudflare.com/plans/). | `string` | `"free"` | no |
| <a name="input_records"></a> [records](#input\_records) | Zone's DNS records.<br>Possible values:<br>  * for the `type` argument: \"A\", \"AAAA\", \"CAA\", \"CERT\", \"CNAME\", \"DNSKEY\", \"DS\", \"HTTPS\", \"LOC\", \"MX\", \"NAPTR\", \"NS\", \"PTR\", \"SMIMEA\", \"SPF\", \"SRV\", \"SSHFP\", \"SVCB\", \"TLSA\", \"TXT\", \"URI\".<br>  *for the `priority` argument: between 0 and 65535.\nPossible values for the `ttl` argument: between 60 and 86400, or 1 for automatic." | <pre>list(object({<br>    record_name = string<br>    type        = string<br>    name        = optional(string)<br>    value       = optional(string)<br>    data = optional(object({<br>      algorithm      = optional(number)<br>      altitude       = optional(number)<br>      certificate    = optional(string)<br>      content        = optional(string)<br>      digest         = optional(string)<br>      digest_type    = optional(number)<br>      fingerprint    = optional(string)<br>      flags          = optional(string)<br>      key_tag        = optional(number)<br>      lat_degrees    = optional(number)<br>      lat_direction  = optional(string)<br>      lat_minutes    = optional(number)<br>      lat_seconds    = optional(number)<br>      long_degrees   = optional(number)<br>      long_direction = optional(string)<br>      long_minutes   = optional(number)<br>      long_seconds   = optional(number)<br>      matching_type  = optional(number)<br>      name           = optional(string)<br>      order          = optional(number)<br>      port           = optional(number)<br>      precision_horz = optional(number)<br>      precision_vert = optional(number)<br>      preference     = optional(number)<br>      priority       = optional(number)<br>      proto          = optional(string)<br>      protocol       = optional(number)<br>      public_key     = optional(string)<br>      regex          = optional(string)<br>      replacement    = optional(string)<br>      selector       = optional(number)<br>      service        = optional(string)<br>      size           = optional(number)<br>      tag            = optional(string)<br>      target         = optional(string)<br>      type           = optional(number)<br>      usage          = optional(number)<br>      value          = optional(string)<br>      weight         = optional(number)<br>    }))<br>    priority        = optional(number)<br>    ttl             = optional(number)<br>    proxied         = optional(bool)<br>    allow_overwrite = optional(bool)<br>  }))</pre> | `[]` | no |
| <a name="input_type"></a> [type](#input\_type) | A full zone implies that DNS is hosted with Cloudflare. A partial zone is typically a partner-hosted zone or a CNAME setup. Possible values: `full`, `partial`.<br>To learn more and choose the right configuration for you, see the documentation about [full](https://developers.cloudflare.com/dns/zone-setups/full-setup/) or [partial CNAME](https://developers.cloudflare.com/dns/zone-setups/partial-setup/) setups. | `string` | `"full"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The DNS zone name which will be added, e.g. example.com. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_algorithm"></a> [algorithm](#output\_algorithm) | Zone DNSSEC algorithm. |
| <a name="output_digest"></a> [digest](#output\_digest) | Zone DNSSEC digest. |
| <a name="output_digest_algorithm"></a> [digest\_algorithm](#output\_digest\_algorithm) | Digest algorithm use for Zone DNSSEC. |
| <a name="output_digest_type"></a> [digest\_type](#output\_digest\_type) | Digest Type for Zone DNSSEC. |
| <a name="output_dnssec_status"></a> [dnssec\_status](#output\_dnssec\_status) | The status of the Zone DNSSEC. |
| <a name="output_ds"></a> [ds](#output\_ds) | DS for the Zone DNSSEC. |
| <a name="output_flags"></a> [flags](#output\_flags) | Zone DNSSEC flags. |
| <a name="output_key_tag"></a> [key\_tag](#output\_key\_tag) | Key Tag for the Zone DNSSEC. |
| <a name="output_key_type"></a> [key\_type](#output\_key\_type) | Key type used for Zone DNSSEC. |
| <a name="output_meta"></a> [meta](#output\_meta) | Map of booleans, indicating some zone statuses or flags. |
| <a name="output_modified_on"></a> [modified\_on](#output\_modified\_on) | Zone DNSSEC updated time. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | Cloudflare-assigned name servers. This is only populated for zones that use Cloudflare DNS. |
| <a name="output_public_key"></a> [public\_key](#output\_public\_key) | Public Key for the Zone DNSSEC. |
| <a name="output_record_created_on"></a> [record\_created\_on](#output\_record\_created\_on) | The RFC3339 timestamp of when the records were created. |
| <a name="output_record_hostnames"></a> [record\_hostnames](#output\_record\_hostnames) | The FQDN of the records. |
| <a name="output_record_ids"></a> [record\_ids](#output\_record\_ids) | The record IDs. |
| <a name="output_record_metadata"></a> [record\_metadata](#output\_record\_metadata) | A key-value map of string metadata Cloudflare associates with the records. |
| <a name="output_record_modified_on"></a> [record\_modified\_on](#output\_record\_modified\_on) | The RFC3339 timestamp of when the records were last modified. |
| <a name="output_record_proxiable"></a> [record\_proxiable](#output\_record\_proxiable) | Shows whether these records can be proxied, must be true if setting proxied=true. |
| <a name="output_status"></a> [status](#output\_status) | Status of the zone. Valid values: active, pending, initializing, moved, deleted, deactivated. |
| <a name="output_vanity_name_servers"></a> [vanity\_name\_servers](#output\_vanity\_name\_servers) | List of Vanity Nameservers (if set). |
| <a name="output_verification_key"></a> [verification\_key](#output\_verification\_key) | Contains the TXT record value to validate domain ownership. This is only populated for zones of type partial. |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The zone ID. |

### Examples

```hcl
module "zone" {
  source = "../.."

  zone = var.zone

  records = [
    {
      name  = "bastion-example"
      value = "1.1.1.1"
      type  = "A"
      ttl   = 1
    },
    {
      name  = "api-example"
      value = "1.1.1.1"
      type  = "A"
      ttl   = 1
    }
  ]
}
```

<!-- END_TF_DOCS -->