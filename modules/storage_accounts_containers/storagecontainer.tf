# creating storage containers
# resource "azurerm_storage_container" "storage_container" {
#   for_each              = {for idx, val in local.storage_accts_containers_group: idx => val}
#   name                  = each.value[1].name
#   #container_access_type = each.value[1].access_type
#   storage_account_name  = azurerm_storage_account.storage_account[each.value[0]].name
#   container_access_type   = "blob"
#   depends_on = [
#       azurerm_storage_account.storage_account
#   ]
# }


resource "azurerm_storage_container" "storage_container" {
  for_each              = local.storage_containers_list
  #name                  = each.value[1].name
  name                  = split("|",each.key)[1]
  #container_access_type = each.value[1].access_type
  storage_account_name  = azurerm_storage_account.storage_account[split("|",each.key)[0]].name
  container_access_type   = "blob"
  depends_on = [
      azurerm_storage_account.storage_account
  ]
}



