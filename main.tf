resource "azurerm_resource_group" "storage_RG" {
  name     = "Afsal-storage-RG-FiveOrFive"
  location = "eastus"
}

resource "azurerm_storage_account" "afsal_stg_account" {
  name                     = "afsalstotfivetoone"
  resource_group_name      = azurerm_resource_group.storage_RG.name
  location                 = azurerm_resource_group.storage_RG.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

#   network_rules {
#     default_action = "Deny"
#   }
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "afsalstoragecontainer"
  storage_account_name  = azurerm_storage_account.afsal_stg_account.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "storage_blob" {
  name                   = "testfile.txt"
  storage_account_name   = azurerm_storage_account.afsal_stg_account.name
  storage_container_name = azurerm_storage_container.storage_container.name
  type                   = "Block"
}

resource "azurerm_storage_account_network_rules" "netrules" {
  resource_group_name  = azurerm_resource_group.storage_RG.name
  storage_account_name = azurerm_storage_account.afsal_stg_account.name

  default_action = "Deny"
  bypass = [
    "Metrics",
    "Logging",
    "AzureServices"
  ]

  depends_on = [
    azurerm_storage_container.storage_container,
  ]
}

resource "azurerm_private_endpoint" "priavte_blob" {
  name                = "afsal-private-storage"
  location            = azurerm_resource_group.storage_RG.location
  resource_group_name = azurerm_resource_group.storage_RG.name
  subnet_id           = "/subscriptions/e060f39e-3e99-4511-9b8a-54a14dd431da/resourceGroups/Afsal-VirtualNetwork/providers/Microsoft.Network/virtualNetworks/afsal-virtualnetwork/subnets/afsal-vnet"

#   private_dns_zone_group {
#     name                 = "private-dns-zone-group"
#     private_dns_zone_ids = [var.private_link_dns_zones["blob"]]
#   }

  private_service_connection {
    name                           = "afsal-private-storage-plconnection-blob"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.afsal_stg_account.id
    subresource_names              = ["blob"]
  }
}

module "cognitive_service" {
  source                     = "./modules/services/cognitive_services"
  depends_on = [
    azurerm_resource_group.storage_RG
  ]
  resource_group_name        = azurerm_resource_group.storage_RG.name
  location                   = azurerm_resource_group.storage_RG.location
  prefix                     = local.prefix
  kind                       = "FormRecognizer"
  custom_subdomain           = "afsalcogntivecogsvctesfiveorfive"
  allowed_fqdns              = [azurerm_storage_account.afsal_stg_account.primary_blob_host]
  private_endpoint_subnet_id = "/subscriptions/e060f39e-3e99-4511-9b8a-54a14dd431da/resourceGroups/Afsal-VirtualNetwork/providers/Microsoft.Network/virtualNetworks/afsal-virtualnetwork/subnets/afsal-vnet"
#   private_link_dns_zones     = data.terraform_remote_state.main.outputs.private_link_dns_zone_ids
}

resource "azurerm_role_assignment" "cogsvc_storage_reader" {
  scope                = azurerm_storage_account.afsal_stg_account.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = module.cognitive_service.cognitive_account_identity_principal_id
}
