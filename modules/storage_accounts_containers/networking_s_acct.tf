
# linking storage account to PE
resource "azurerm_private_endpoint" "storaccount_priv_endpt" {
for_each = toset(local.storage_accts_list)
  name                       = "prvendpt-${azurerm_storage_account.storage_account[each.key].name}"
  location                   = var.az_locale
  resource_group_name        = var.az_resource_group_name
  subnet_id                  = var.az_subnet_id
  private_service_connection {
    name                           = "prvserviceconn-${azurerm_storage_account.storage_account[each.key].name}"
    private_connection_resource_id = azurerm_storage_account.storage_account[each.key].id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
    depends_on = [
        azurerm_storage_account.storage_account,
        azurerm_storage_container.storage_container
    ]
    private_dns_zone_group {
    name                 = lower("${var.platform}-${var.context}-dns-grp-${var.zone_loc}-${var.env}")
    private_dns_zone_ids = [var.privatednszone_id]

  }
}

resource "azurerm_storage_account_network_rules" "storageaccount_network_rules" {
#for_each              = {for idx, val in local.storage_accts_containers_allowed_ip: idx => val}
for_each = toset(local.storage_accts_list)
  storage_account_id         = azurerm_storage_account.storage_account[each.key].id
  default_action             = "Allow"
  #ip_rules                   = [each.value.az_storage_accounts.datahub.allowed_ip_ranges[0],each.value.az_storage_accounts.datahub.allowed_ip_ranges[1]]
  #ip_rules                   = [each.value.az_storage_accounts.datahub.allowed_ip_ranges[1]]
  #ip_rules                   = [each.value[1]]
  ip_rules                   = "${local.allowed_ip_ranges_storage_accts}"
  virtual_network_subnet_ids = [var.az_subnet_id]
  #virtual_network_subnet_ids = ["${data.azurerm_virtual_network.vnet[each.key]}".id]
   bypass                     = ["AzureServices"]

    depends_on = [
       azurerm_storage_account.storage_account,
      azurerm_storage_container.storage_container
    ]
}

