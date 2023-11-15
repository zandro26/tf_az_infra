#creating unique storage accounts for each occurence of resource block in the config file
resource azurerm_storage_account sx_storage_account {
  for_each = {
    for k, v in local.az_storage_account : k => v
  }

  name                     = "${each.key}${var.env}"
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







