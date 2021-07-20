resource "azurerm_cognitive_account" "main" {
  name                  = "afsaL-cogntive-cogsvc-test-qwertyuiopfive"
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = var.kind
  sku_name              = "S0"
  custom_subdomain_name = var.custom_subdomain

  network_acls {
    default_action = "Deny"
  }
}

resource "azurerm_private_endpoint" "cogsvc" {
  name                = "${var.prefix}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  # private_dns_zone_group {
  #   name                 = "private-dns-zone-group"
  #   private_dns_zone_ids = [var.private_link_dns_zones["cognitive_services"]]
  # }

  private_service_connection {
    name                           = "${var.prefix}-plconnection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cognitive_account.main.id
    subresource_names              = ["account"]
  }
}

// WORKAROUND: There are a few properties missing from azurerm_cognitive_account:
//   identity
//   disable_local_auth
//   public_network_access
//   restrict_outbound_network_access
//   allowed_fqdn_list
//
// Until these are added, we can set them via script after the Cognitive Services account
// has been created.
  

resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "chmod 777 ${path.module}/scripts"
  }
}

resource "null_resource" "cogsvc_lockdown" {
  triggers = {
    account_name   = azurerm_cognitive_account.main.name
    resource_group = azurerm_cognitive_account.main.resource_group_name
    version        = 1
  }
  depends_on     = [null_resource.example1]

  provisioner "local-exec" {
    command     = "${path.module}/scripts/lockdown_cognitive_account.sh"
    environment = {
      cognitive_account_id = azurerm_cognitive_account.main.id
      cognitive_account_name = azurerm_cognitive_account.main.name
      cognitive_account_resource_group = azurerm_cognitive_account.main.resource_group_name
      json_allow_list = jsonencode(var.allowed_fqdns)
    }
  }
}

data "external" "cogsvc_identity" {
  program = [
    "${path.module}/scripts/get_cognitive_account_identity.sh",
    null_resource.cogsvc_lockdown.triggers["account_name"],
    null_resource.cogsvc_lockdown.triggers["resource_group"]
  ]
}
