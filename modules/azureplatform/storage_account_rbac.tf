locals {
  storage_account_roles = can(local.az_storage_account) ? flatten([
    for storage_account in local.az_storage_account : [
      for role, members in storage_account.iam : [
        for member in members : {
          storage_account_key = storage_account.storage_account_key
          role                = role
          member              = member
        }
      ]
    ]
  ]) : []
}

data "azuread_group" "storage_account_ad_member" {
    for_each = {
      for k, v in local.storage_account_roles : k => v
      if local.storage_account_roles != []
    }

    display_name = each.value.member
}

resource "azurerm_role_assignment" "storage_account_rbac" {
    for_each = local.storage_account_roles != [] ? {
        for k, v in local.storage_account_roles : k => v
    } : {}

    scope = azurerm_storage_account.storage_account[each.value.storage_account_key].id
    role_definition_name = each.value.role
    principal_id = data.azuread_group.storage_account_ad_member[each.key].id
}