

#Assign the "User Access Administrator" role to the service principal
resource "azurerm_role_assignment" "terraform-az-deployment-role" {
  #for_each              = var.az_resource_block
  for_each = toset(local.storage_accts_list)
  principal_id          = var.az_client_config_object_id
  role_definition_name  = "User Access Administrator"
  scope                 = azurerm_storage_account.storage_account[each.value].id

    depends_on          = [
    azurerm_storage_account.storage_account
  ]
}

#Assign Container IAM RBAC role to the service principal, should be the USERGROUP IDS
resource "azurerm_role_assignment" "storage_account_rbac" {
  for_each              = {for idx, val in local.rbac_storage_accts: idx => val}
  scope                 = azurerm_storage_account.storage_account[each.value[0]].id
  role_definition_name  = each.value[1]
  principal_id          = var.az_client_config_object_id

  depends_on            = [
    azurerm_storage_account.storage_account,
    azurerm_role_assignment.terraform-az-deployment-role
  ]
}

#Assign the "User Access Administrator" role to the service principal
# resource "azurerm_role_assignment" "container_rbac" {
#   for_each              = {for idx, val in local.rbac_storage_containers: idx => val}
#   scope                 = azurerm_storage_container.storage_container[each.value[0]]
#   #scope                 =  try(azurerm_storage_container.storage_container[each.value[0]].id, null)
#   role_definition_name  = each.value[1]
#   principal_id          = var.az_client_config_object_id

#   depends_on            = [
#     azurerm_storage_account.storage_account,
#      azurerm_storage_container.storage_container,
#   ]
# }