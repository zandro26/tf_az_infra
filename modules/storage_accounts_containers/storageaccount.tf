# creating storage account
resource azurerm_storage_account storage_account {
    for_each = var.az_resource_block
    #name                     = each.value.az_storage_accounts.name
    #name                     = lower("${var.platform}${var.context}s${var.zone_loc}${var.env}")
    name                     = lower("${var.platform}${each.key}sa${var.zone_loc}${var.env}")
    location                 = local.location
    resource_group_name      = local.resource_group_name
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"

 tags = {
 environment = lower("${var.env}")
  }
}



