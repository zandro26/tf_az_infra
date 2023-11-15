#data block to get the AD Member data lookup
data "azuread_group" "storage_account_ad_member" {
    for_each = {
      for k, v in local.storage_account_roles : k => v
      if local.storage_account_roles != []
    }

    display_name = each.value.member
}

#Role Assignment for storage account
resource "azurerm_role_assignment" "storage_account_rbac" {
    for_each = local.storage_account_roles != [] ? {
        for k, v in local.storage_account_roles : k => v
    } : {}

    scope = azurerm_storage_account.sx_storage_account[each.value.storage_account_key].id
    role_definition_name = each.value.role
    principal_id = data.azuread_group.storage_account_ad_member[each.key].id
}