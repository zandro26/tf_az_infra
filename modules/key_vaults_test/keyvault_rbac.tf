//built in roles

locals {
    kv_builtin = var.keyvault_deploy && can(var.keyvault_parameters.rbac) ? flatten([
        for role, members in var.keyvault_parameters.rbac : [
            for member in members : {
                role = role
                member = member
            }
        ]
    ]) : []
}


data "azuread_group" "kv_ad_member" {
    for_each = {
      for entry in local.kv_builtin : entry.member => entry
    }

    display_name = each.value.member
}

resource "azurerm_role_assignment" "kv_rbac" {
    for_each = var.keyvault_deploy ? {
        for entry in local.kv_builtin : entry.member => entry
    } : {}

    scope = azurerm_key_vault.keyvault[0].id
    role_definition_name = each.value.role
    principal_id = data.azuread_group.kv_ad_member[each.key].id
}