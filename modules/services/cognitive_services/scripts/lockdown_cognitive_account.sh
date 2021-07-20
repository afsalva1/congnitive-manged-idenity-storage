#!/bin/bash
set -euo pipefail

body='{
  "identity": {
    "type": "SystemAssigned"
  },
  "properties": {
    "disableLocalAuth": true,
    "publicNetworkAccess": "Disabled",
    "restrictOutboundNetworkAccess": true,
    "allowedFqdnList": '$json_allow_list'
  }
}'
url="https://management.azure.com$cognitive_account_id?api-version=2021-04-30"
token="$(az account get-access-token --query accessToken --output tsv)"

# Patch the Cognitive Services Account w/ properties currently not available in TF
echo Updating Cognitive Services Account...
response="$(curl -i -s -H 'Content-Type: application/json' -H "Authorization: Bearer $token" -X PATCH -d "$body" "$url")"
status_code="$(echo "$response" | head -n 1 | cut -d$' ' -f2)"

if [[ "$status_code" != 200 && "$status_code" != 202 ]]
then
  echo Failed to update Cognitive Services Account
  echo "$response"
  exit 1
fi

location="$(echo "$response" | grep -i '^location:' | sed 's/location: //i; s/\r//' || true)"

# Poll for completion of async operation
while [[ -n "$location" ]]
do
  http_code="$(curl -s -o /dev/null -w "%{http_code}" \
    -H 'Content-Type: application/json' -H "Authorization: Bearer $token" "$location")"

  [[ "$http_code" != 200 ]] || break

  echo Still updating Cognitive Services Account...
  sleep 10
done

echo Successfully updated Cognitive Services Account