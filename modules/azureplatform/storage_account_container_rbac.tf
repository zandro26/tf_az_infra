#Data look up for getting ad member for container
data "azuread_group" "storage_account_container_ad_member" {
    for_each = {
      for k, v in local.storage_account_container_roles : k => v
      if local.storage_account_container_roles != []
    }
   

    display_name = each.value.member
}

resource "azurerm_role_assignment" "container_rbac" {
    for_each = local.storage_account_container_roles != [] ? {
        for k, v in local.storage_account_container_roles : k => v
    } : {}

    scope = azurerm_storage_container.sx_container[each.value.container_key].resource_manager_id
    role_definition_name = each.value.role
    principal_id = data.azuread_group.storage_account_container_ad_member[each.key].id
}