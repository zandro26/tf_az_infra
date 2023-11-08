# creating storage account
resource azurerm_storage_account storage_account {
  for_each                 = toset(local.storage_accts_list)
  name                     = lower("sa${each.key}${var.env}${local.app_team_name[0]}")
  location                 = var.az_locale
  resource_group_name      = data.azurerm_resource_group.resourcegroup.name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

 tags = {
 environment = lower("${var.env}")
  }
}