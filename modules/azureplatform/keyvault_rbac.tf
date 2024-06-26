
#Get AD member for KV
data "azuread_group" "kv_ad_member" {
    for_each = {
      for k, v in local.kv_roles : k => v
      if var.keyvault_deploy && local.kv_roles != []
    }

    display_name = each.value.member
}

resource "azurerm_role_assignment" "kv_rbac" {
    for_each = var.keyvault_deploy ? {
        for k, v in local.kv_roles : k => v
        if var.keyvault_deploy && local.kv_roles != []
    } : {}

    scope = azurerm_key_vault.keyvault[0].id
    role_definition_name = each.value.role
    principal_id = data.azuread_group.kv_ad_member[each.key].id
}