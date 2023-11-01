

# Assign the "User Access Administrator" role to the service principal
resource "azurerm_role_assignment" "terraform-az-deployment-role" {
  for_each              = var.azure_domain
  principal_id          = var.az_client_config_object_id
  role_definition_name  = "User Access Administrator"
  scope                 = azurerm_storage_account.storage_account[each.key].id
    
    depends_on          = [
    azurerm_storage_account.storage_account
  ]
}


resource "azurerm_role_assignment" "storage_contributor" {
  for_each              = var.azure_domain
  scope                 = azurerm_storage_account.storage_account[each.key].id
  role_definition_name  = "Contributor"
  principal_id          = var.az_client_config_object_id
  
  depends_on            = [
    azurerm_storage_account.storage_account,
    azurerm_role_assignment.terraform-az-deployment-role
  ]
}

resource "azurerm_role_assignment" "storageaccountrole" {
  for_each             = var.azure_domain
  principal_id         = "0ca6ddbf-3007-43be-8a1c-94f744771cd1"  # Replace with the Object ID of the user or service principal to which you want to assign the role.
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.storage_account[each.key].id

      depends_on       = [
        azurerm_storage_account.storage_account
         ]
}
