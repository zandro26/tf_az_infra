# creating storage containers
resource "azurerm_storage_container" "storage_container" {
  for_each              = {for idx, val in local.storage_accts_containers_group: idx => val}
  name                  = each.value[1].name
  #container_access_type = each.value[1].access_type
  storage_account_name  = azurerm_storage_account.storage_account[each.value[0]].name
  container_access_type   = "blob"
  depends_on = [
      azurerm_storage_account.storage_account
  ]
}




