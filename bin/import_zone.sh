#!/bin/bash

# A bash script to dump records from exists zone DNS to json
# just copy the generated json to the `records` variable
#
# as a paremeter get a domain
# script require env variable called `CLOUDFLARE_API_TOKEN`
# To see more information about TOKEN see:
# https://developers.cloudflare.com/fundamentals/api/get-started/create-token/
#
# Create environment variable with your token by using command:
# $ export CLOUDFLARE_API_TOKEN=1234567890abcdef1234567890abcdef
#
# or call script with
# $ CLOUDFLARE_API_TOKEN=1234567890abcdef1234567890abcdef; ./import_zone.sh "acme.sh"
#
#
# Author:
# Rafal Masiarek <rafal@masiarek.pl>
#

# at first parameter you need add domain
if [ $# -eq 0 ]
  then
    echo "No arguments with CF domain supplied"
    exit 1
fi

# check `CLOUDFLARE_API_TOKEN` is specified
if [[ -z "${CLOUDFLARE_API_TOKEN}" ]]; then
    echo "Environment variable `CLOUDFLARE_API_TOKEN` does exist!"
    exit 1
fi

# get the zone id for the requested zone
zoneid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$1" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" | jq \
  -r '{"result"}[] | .[0] | .id')


curl -s -L -X GET "https://api.cloudflare.com/client/v4/zones/${zoneid}/dns_records" \
     -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
     -H "Content-Type:application/json" | jq \
     '[.result[] | .["record_name"] = "\(.name)_\(.type)_\(.id)" | del(.id, .zone_id, .zone_name, .proxiable, .ttl, .locked, .meta, .created_on, .modified_on, .comment, .tags)]'
