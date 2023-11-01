# creating storage containers
resource "azurerm_storage_container" "storage_container" {
  #count                   = length(local.container_names)
  for_each = toset(local.containers)
  name                    = split("|",each.key)[0]
  #storage_account_name    = split("|", each.key)[1]
  storage_account_name    = azurerm_storage_account.storage_account[split("|", each.key)[1]].name 
  container_access_type   = "blob"
#   metadata = {
#     "ContainerType" = local.container_names[count.index]
#   }

    depends_on = [
        azurerm_storage_account.storage_account
         ]
}




