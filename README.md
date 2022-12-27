
# terraform-cloudflare-zone

[![WeSupportUkraine](https://raw.githubusercontent.com/Infrastrukturait/WeSupportUkraine/main/banner.svg)](https://github.com/Infrastrukturait/WeSupportUkraine)
## About
Terraform module to provision a CloudFlare zone with DNS record managment
## License

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

```text
GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```
## Authors
- Rafał Masiarek | [website](https://masiarek.pl) | [email](mailto:rafal@masiarek.pl) | [github](https://github.com/rafalmasiarek)
## Submodules

Submodules included to root module that can be called independent:

- [single-record](https://github.com/Infrastrukturait/terraform-cloudflare-zone/tree/main/modules/single-record) - Root module creates an object with a full zone and object with all records, this small sub-module is to facilitate the creation of a single record to an existing zone.

## Notes

* The `name` and the `data.name` argument values default to `@` (root). This is actually the default behavior, but only for the value of the `data.name` argument when you are not using the module.
* The `data` argument is fully supported. The `value` argument takes precedence over the `data` argument to avoid errors if two arguments are accidentally given at the same time, since only one of them can be given at the same time.
* The `ttl` argument value defaults to `1` (automatic). This is actually the default behavior.
* The `ttl` argument value is forced to `1` (automatic), regardless of explicitly set value, if you set the `proxied` argument value to `true`.
* The `proxied` argument value defaults to `false`. This is actually the default behavior. You must explicitly set this argument value to `true` for the records that you want to proxy through Cloudflare.
* The `proxied` argument value is forced to `false` for unsupported record types, regardless of explicitly set value.
* The `proxied` argument value is forced to `false` for wildcard records for non-enterprise plans, regardless of explicitly set value, because non-enterprise customers can create but not proxy wildcard records.
* To create only each record without create whole zone, you can just use simple submodule [single-record](https://github.com/Infrastrukturait/terraform-cloudflare-zone/tree/main/modules/single-record).

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
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 3.30.0 |

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

### Importing existing zone to IaaC

if the domain exists and already has records, don't worry about importing it into terraform using this module.

In the first step you need to create a [zone](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone) to tfstate:
```
terraform import cloudflare_zone.example <zone_id>
```
according to [official documentation](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone#import).

When we have our zone in tfstate, we have 2 steps to done.

1) As first, we can run our helper bash script to generate json.
A bash script dump records from exists zone DNS to json, just copy the generated json to the `records` variable.
Script require `CLOUDFLARE_API_TOKEN` as a environment variable and domain name as a parameter.

For Example:
```
CLOUDFLARE_API_TOKEN=1234567890abcdef1234567890abcdef; bin/import_zone.sh "acme.sh"
```

2) The second step is more complex because you need to import existing records into your `tfstate`.
To make it as simple as possible, you can use a our hook:
```
#!/bin/bash

DOMAIN="$1"

zoneid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$DOMAIN" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" | jq \
  -r '{"result"}[] | .[0] | .id')


records=$(curl -s -L -X GET "https://api.cloudflare.com/client/v4/zones/${zoneid}/dns_records" \
     -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
     -H "Content-Type:application/json" | jq  -r '.result[] | "\(.name)_\(.type)_\(.id)|\(.id)"')


for i in $records
do
  s=$(echo $i | awk -F'|' '{print $1}')
  t=$(echo $i | awk -F'|' '{print $2}')
  terraform import cloudflare_record.this[\"${s}\"] ${zoneid}/${t}
done
```
This script is fully compatible with our `bin/import_zone.sh` script and creates the same style object's names in `tfstate`.
As previously, hook require `CLOUDFLARE_API_TOKEN` as a environment variable and domain name as a parameter.

To more information about importing [cloudflare_record](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record)
please visit to [official documentation](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record#import).


<!-- references -->

[repo_link]: https://github.com/Infrastrukturait/terraform-cloudflare-zone
