#!/bin/bash

# A bash script to dump records from existing zone DNS to json
# just copy the generated json to the `records` variable
#
# as a parameter pass a domain
# script requires env variable called `CLOUDFLARE_API_TOKEN`
#
# Create environment variable with your token by using command:
# export CLOUDFLARE_API_TOKEN=1234567890abcdef1234567890abcdef
#
# or call script with:
# CLOUDFLARE_API_TOKEN=1234567890abcdef1234567890abcdef ./import_zone.sh "example.com"
#
# Author:
# Rafal Masiarek <rafal@masiarek.pl>
#

set -euo pipefail

if [ $# -eq 0 ]; then
  echo "No Cloudflare domain supplied"
  exit 1
fi

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  echo "Environment variable CLOUDFLARE_API_TOKEN does not exist or is empty"
  exit 1
fi

domain="$1"

zone_response="$(curl -sS -X GET "https://api.cloudflare.com/client/v4/zones?name=${domain}" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
  -H "Content-Type: application/json")"

zoneid="$(echo "${zone_response}" | jq -r '.result[0].id // empty')"

if [[ -z "${zoneid}" ]]; then
  echo "Could not find zone ID for domain: ${domain}"
  echo "${zone_response}" | jq .
  exit 1
fi

page=1
per_page=100
tmpfile="$(mktemp)"

echo "[]" > "${tmpfile}"

while true; do
  response="$(curl -sS -X GET "https://api.cloudflare.com/client/v4/zones/${zoneid}/dns_records?page=${page}&per_page=${per_page}" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    -H "Content-Type: application/json")"

  success="$(echo "${response}" | jq -r '.success')"

  if [[ "${success}" != "true" ]]; then
    echo "Cloudflare API returned an error on page ${page}"
    echo "${response}" | jq .
    rm -f "${tmpfile}"
    exit 1
  fi

  page_items="$(echo "${response}" | jq '
    [
      .result[]
      | .record_name = "\(.name)_\(.type)_\(.id)"
      | {
          record_name,
          type,
          name,
          value: .content,
          comment,
          data,
          priority,
          ttl,
          proxied
        }
      | with_entries(select(.value != null))
    ]
  ')"

  jq -s '.[0] + .[1]' "${tmpfile}" <(echo "${page_items}") > "${tmpfile}.new"
  mv "${tmpfile}.new" "${tmpfile}"

  total_pages="$(echo "${response}" | jq -r '.result_info.total_pages // 1')"

  if [[ "${page}" -ge "${total_pages}" ]]; then
    break
  fi

  page=$((page + 1))
done

cat "${tmpfile}" | jq .
rm -f "${tmpfile}"
