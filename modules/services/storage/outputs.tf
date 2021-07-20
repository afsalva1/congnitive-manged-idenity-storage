output "storage_account_id" {
  value = azurerm_storage_account.main.id

  depends_on = [
    azurerm_private_endpoint.blob, 
    azurerm_private_endpoint.table, 
    azurerm_private_endpoint.queue, 
    azurerm_private_endpoint.file
  ]
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name

  depends_on = [
    azurerm_private_endpoint.blob, 
    azurerm_private_endpoint.table, 
    azurerm_private_endpoint.queue, 
    azurerm_private_endpoint.file
  ]
}

output "primary_access_key" {
  value = azurerm_storage_account.main.primary_access_key
  sensitive = true

  depends_on = [
    azurerm_private_endpoint.blob, 
    azurerm_private_endpoint.table, 
    azurerm_private_endpoint.queue, 
    azurerm_private_endpoint.file
  ]
}

output "secondary_access_key" {
  value = azurerm_storage_account.main.secondary_access_key
  sensitive = true

  depends_on = [
    azurerm_private_endpoint.blob, 
    azurerm_private_endpoint.table, 
    azurerm_private_endpoint.queue, 
    azurerm_private_endpoint.file
  ]
}

output "primary_blob_host" {
  value = azurerm_storage_account.main.primary_blob_host
}
