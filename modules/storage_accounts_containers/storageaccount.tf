# creating storage account
resource azurerm_storage_account storage_account {
    for_each = var.azure_domain
    name                     = each.value.az_storage_accounts.name
    location                 = local.location
    resource_group_name      = local.resource_group_name
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"

 tags = {
 environment = lower("${var.env}")
  }
}



