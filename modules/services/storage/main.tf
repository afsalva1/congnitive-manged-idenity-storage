resource "azurerm_storage_account" "main" {
  name                     = "${var.alphanum_prefix}storage"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny"
  }
}

resource "azurerm_private_endpoint" "blob" {
  name                = "${var.prefix}-pe-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.private_link_dns_zones["blob"]]
  }

  private_service_connection {
    name                           = "${var.prefix}-plconnection-blob"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
  }
}

resource "azurerm_private_endpoint" "queue" {
  name                = "${var.prefix}-pe-queue"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.private_link_dns_zones["queue"]]
  }

  private_service_connection {
    name                           = "${var.prefix}-plconnection-queue"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["queue"]
  }
}

resource "azurerm_private_endpoint" "table" {
  name                = "${var.prefix}-pe-table"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.private_link_dns_zones["table"]]
  }

  private_service_connection {
    name                           = "${var.prefix}-plconnection-table"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["table"]
  }
}

resource "azurerm_private_endpoint" "file" {
  name                = "${var.prefix}-pe-file"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.private_link_dns_zones["file"]]
  }

  private_service_connection {
    name                           = "${var.prefix}-plconnection-file"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["file"]
  }
}
