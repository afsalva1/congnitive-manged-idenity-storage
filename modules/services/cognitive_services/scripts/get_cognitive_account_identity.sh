#!/bin/bash
set -euo pipefail

cognitive_account_name="$1"
cognitive_account_resource_group="$2"

identityPrincipalId="$(az cognitiveservices account identity show --name $cognitive_account_name --resource-group $cognitive_account_resource_group --query principalId --output tsv || true)"

echo '{ "identityPrincipalId": "'$identityPrincipalId'" }'


