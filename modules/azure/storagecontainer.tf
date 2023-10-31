
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

# resource "azurerm_role_assignment" "container_role" {
#   for_each = toset(local.containers)
#   principal_id   = data.azurerm_client_config.current.object_id  # Replace with the Object ID of the user or service principal to which you want to assign the role.
#   role_definition_name = "Storage Blob Data Contributor"
#   scope         = azurerm_storage_container.storage_container[each.key].id

#       depends_on = [
#         azurerm_storage_container.storage_container
#          ]
# }

# resource "azurerm_role_assignment" "container_role1" {
#   for_each = toset(local.containers)
#   scope                = azurerm_storage_container.storage_container[each.key].id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = data.azurerm_client_config.current.object_id

#     depends_on = [
#         azurerm_storage_container.storage_container
#          ]

# }

# resource "azurerm_role_assignment" "container_role2" {
#   for_each = toset(local.containers)
#   scope                = azurerm_storage_container.storage_container[each.key].id
#   role_definition_name = "Storage Blob Data Reader"
#   principal_id         = data.azurerm_client_config.current.object_id

#       depends_on = [
#         azurerm_storage_container.storage_container
#          ]
# }


