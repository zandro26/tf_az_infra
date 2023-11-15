#creating unique storage accounts for each occurence of resource block in the config file
resource azurerm_storage_account sx_storage_account {
  for_each = {
    for k, v in local.az_storage_account : k => v
  }

  name                     = lower("${each.key}${var.env}")
  location                 = var.az_locale
  resource_group_name      = var.resourcegroup
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = merge(var.common_tags, each.value.resource_tag)  
           
}

# creating unique storage containers for each occurence of unique storage accounts
resource "azurerm_storage_container" "sx_container" {
  for_each = {
    for k, v in local.containers : "${v.container_key}" => v
  }

  name                  = each.value.container_key
  storage_account_name  = azurerm_storage_account.sx_storage_account[each.value.storage_account_key].name
  container_access_type = "blob"
  depends_on = [
      azurerm_storage_account.sx_storage_account
  ]
}


#creating private endpoints for each storage account
resource "azurerm_private_endpoint" "storaccount_priv_endpt" {
  for_each = {
    for k, v in local.az_storage_account : k => v
  }
  #for_each = local.az_storage_account

  name                       = "${azurerm_storage_account.sx_storage_account[each.key].name}privendpt"
  location                   = var.az_locale
  resource_group_name        = var.resourcegroup
  subnet_id                  = var.appsnet
  private_service_connection {
    name                           = "${azurerm_storage_account.sx_storage_account[each.key].name}privsvcconn"
    private_connection_resource_id = azurerm_storage_account.sx_storage_account[each.key].id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
    depends_on = [
        azurerm_storage_account.sx_storage_account,
    ]
    private_dns_zone_group {
    name                 = lower("dnsgrp${var.env}${var.name}")
    private_dns_zone_ids = [var.privatednszone]

  }
}

#creating private endpoints for each storage account
resource "azurerm_storage_account_network_rules" "storageaccount_network_rules" {
  for_each = {
    for k, v in local.az_storage_account : k => v
  }

  storage_account_id         = azurerm_storage_account.sx_storage_account[each.key].id
  default_action             = "Allow"
  ip_rules                   = each.value.allowed_ip_ranges
  #ip_rules                   = var.global_ip_ranges !=[] ? var.global_ip_ranges : each.value.allowed_ip_ranges
  virtual_network_subnet_ids = [var.appsnet]
  bypass                     = ["AzureServices"]

    depends_on = [
       azurerm_storage_account.sx_storage_account,
    ]
}






