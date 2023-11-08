

#Assign the "User Access Administrator" role to the service principal to storage account
resource "azurerm_role_assignment" "terraform-az-deployment-role" {
  #for_each              = var.az_resource_block
  for_each = toset(local.storage_accts_list)
  principal_id          = data.azuread_group.iam_group1.id
  role_definition_name  = "User Access Administrator"
  scope                 = azurerm_storage_account.storage_account[each.value].id

    depends_on          = [
    azurerm_storage_account.storage_account
  ]
}

#Assign Storage Account IAM RBAC role to the service principal, should be the USERGROUP IDS
# resource "azurerm_role_assignment" "storage_account_rbac" {
#   for_each              = {for idx, val in local.rbac_storage_accts: idx => val}
#   scope                 = azurerm_storage_account.storage_account[each.value[0]].id
#   role_definition_name  = each.value[1]
#   principal_id          = data.azuread_group.iam_group2.id

#   depends_on            = [
#     azurerm_storage_account.storage_account,
#     azurerm_role_assignment.terraform-az-deployment-role
#   ]
# }

resource "azurerm_role_assignment" "storage_account_rbac" {
  for_each              = local.storage_account_rbac_definition
  scope                 = azurerm_storage_account.storage_account[split("|",each.key)[0]].id
  role_definition_name  = each.value.iam
  principal_id          = data.azuread_group.iam_group2.id

  depends_on            = [
    azurerm_storage_account.storage_account,
    azurerm_role_assignment.terraform-az-deployment-role
  ]
}


# #Assign Container IAM RBAC role to the service principal, should be the USERGROUP IDS
# resource "azurerm_role_assignment" "container_rbac" {
#   #for_each              = {for idx, val in local.rbac_storage_containers: idx => val}
#   for_each              = {for idx, val in local.container_names: idx => val}
#   scope                 = azurerm_storage_container.storage_container[each.key].id
#   #role_definition_name  = each.value[1]
#   role_definition_id    =  "Storage Blob Data Contributor"
#   #principal_id          = data.azurerm_client_config.current.id
#    principal_id          = data.azuread_group.iam_group2.id

#   depends_on            = [
#     azurerm_storage_account.storage_account,
#      azurerm_storage_container.storage_container,
#   ]
# }