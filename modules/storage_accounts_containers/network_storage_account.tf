
# linking storage account to PE
resource "azurerm_private_endpoint" "private_endpoint1" {
  for_each = var.azure_domain
  name                       = "prvendpt-${azurerm_storage_account.storage_account[each.key].name}"
  location                   = local.location
  resource_group_name        = local.resource_group_name
  subnet_id                  = data.azurerm_subnet.appsnet[each.key].id
  private_service_connection {
    name                           = each.value.private_service_con.name
    private_connection_resource_id = azurerm_storage_account.storage_account[each.key].id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
    depends_on = [
        azurerm_storage_account.storage_account,
        #azurerm_storage_container.storage_container
    ]
    private_dns_zone_group {
    name                 = lower("${var.platform}-${var.context}-dns-grp-${var.zone_loc}-${var.env}")
    private_dns_zone_ids = [var.privatednszone_id]

  }
}

resource "azurerm_storage_account_network_rules" "storageaccount_network_rules" {
  for_each = var.azure_domain
  storage_account_id         = azurerm_storage_account.storage_account[each.key].id
  default_action             = "Allow"
  #ip_rules                   = [each.value.az_storage_accounts.datahub.allowed_ip_ranges[0],each.value.az_storage_accounts.datahub.allowed_ip_ranges[1]]
  ip_rules                   = [each.value.az_storage_accounts.datahub.allowed_ip_ranges[1]]
  virtual_network_subnet_ids = [data.azurerm_subnet.appsnet[each.key].id]
  #virtual_network_subnet_ids = ["${data.azurerm_virtual_network.vnet[each.key]}".id]
   bypass                     = ["AzureServices"]

    depends_on = [
       azurerm_storage_account.storage_account,
        #azurerm_storage_container.storage_container
    ]
}

