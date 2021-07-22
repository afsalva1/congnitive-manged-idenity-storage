#!/bin/bash
set -euo pipefail

cognitive_account_name="$1"
cognitive_account_resource_group="$2"

loginAzureCLI = "$(az login --service-principal -u 4242bfb1-0024-4bdf-a684-56df78790c9a -p _94f-.6nC05uQK_P894PA-RRl22-QS79wM --tenant 4c4aede3-daf6-4c76-8ec8-879c2531a537)"
identityPrincipalId="$(az cognitiveservices account identity show --name $cognitive_account_name --resource-group $cognitive_account_resource_group --query principalId --output tsv || true)"

echo '{ "identityPrincipalId": "'$identityPrincipalId'" }'


