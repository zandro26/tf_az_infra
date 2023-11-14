# locals {
#   storage_account_container_roles = can(local.containers) ? flatten([
#     for container in local.containers : [
#       for role, members in container.iam : [
#         for member in members : {
#           storage_account_key = container.storage_account_key
#           container_key       = container.container_key
#           role                = role
#           member              = member
#         }
#       ]
#     ]
#   ]) : []
# }

# data "azuread_group" "storage_account_container_ad_member" {
#     for_each = {
#       for k, v in local.storage_account_container_roles : k => v
#       if local.storage_account_container_roles != []
#     }
   

#     display_name = each.value.member
# }

# resource "azurerm_role_assignment" "container_rbac" {
#     for_each = local.storage_account_container_roles != [] ? {
#         for k, v in local.storage_account_container_roles : k => v
#     } : {}

#     scope = azurerm_storage_container.example[each.value.container_key].id
#     role_definition_name = each.value.role
#     principal_id = data.azuread_group.storage_account_ad_member[each.key].id
# }