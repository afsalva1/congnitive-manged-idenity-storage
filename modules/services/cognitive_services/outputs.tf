output "cognitive_account_id" {
  value = azurerm_cognitive_account.main.id

  depends_on = [
    azurerm_private_endpoint.cogsvc
  ]
}

output "cognitive_account_identity_principal_id" {
  value = data.external.cogsvc_identity.result["identityPrincipalId"]
}
