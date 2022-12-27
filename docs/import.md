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
