# creating storage account
resource azurerm_storage_account storage_account {
for_each = toset(local.storage_accts_list)
  name=lower("${var.platform}${each.value}storeacct${var.zone_loc}${var.env}")
  location                 = var.az_locale
  resource_group_name      = var.az_resource_group_name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

 tags = {
 environment = lower("${var.env}")
  }
}