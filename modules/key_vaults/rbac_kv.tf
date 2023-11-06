resource "azurerm_key_vault_access_policy" "keyvault_access" {
  for_each     = var.az_resource_block
  key_vault_id = azurerm_key_vault.keyvault[each.key].id
  tenant_id    = var.conns.az_tenant_id
  object_id    = var.az_client_config_object_id

  secret_permissions      = ["List"] #"list", "set", "delete"]
  key_permissions         = ["Get"] #, "create", "delete"]
  certificate_permissions = ["List"] #, "list", "delete"]

  depends_on = [
    azurerm_key_vault.keyvault
  ]

}

# data "azuread_service_principal" "sec-grp" {
#   display_name = "sec-grp1"
# }

#assigning service principal
resource "azurerm_key_vault_access_policy" "rw" {
  for_each     = var.az_resource_block
  key_vault_id = azurerm_key_vault.keyvault[each.key].id
  tenant_id    = var.conns.az_tenant_id
  #object_id    = data.azuread_group.ad_group1.id
  object_id    = data.azuread_group.ad_group1.display_name.id
  #secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Restore"]
  secret_permissions      = var.keyvault_rw_secret_permissions
  #key_permissions         = ["Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore"]
  key_permissions         = var.keyvault_rw_key_permissions
  #certificate_permissions = ["Get", "List", "Set", "Delete", "Backup", "Restore"]
  
  depends_on = [
    azurerm_key_vault.keyvault
  ]

}

resource "azurerm_key_vault_access_policy" "ro" {
  for_each     = var.az_resource_block
  key_vault_id = azurerm_key_vault.keyvault[each.key].id
  tenant_id    = var.conns.az_tenant_id
  object_id    = data.azuread_group.ad_group2.id

  # secret_permissions      = ["Get", "List"]
  # key_permissions         = ["Get", "List"]
  secret_permissions      = var.keyvault_ro_secret_permissions
  key_permissions         = var.keyvault_ro_key_permissions
  #certificate_permissions = ["Get", "List"]

  depends_on = [
    azurerm_key_vault.keyvault
  ]

}

resource "azurerm_role_assignment" "example_user" {
  for_each     = var.az_resource_block
  principal_id   = var.az_client_config_object_id
  role_definition_name = "Reader"
  scope         = azurerm_key_vault.keyvault[each.key].id
}

resource "azurerm_role_assignment" "example_group" {
  for_each     = var.az_resource_block
  principal_id   = data.azuread_group.ad_group1.display_name.id
  role_definition_name = "Contributor"
  scope         = azurerm_key_vault.keyvault[each.key].id

    depends_on = [
    azurerm_key_vault.keyvault
  ]

}

resource "azurerm_role_assignment" "example_service_principal" {
  for_each     = var.az_resource_block
  principal_id   = data.azuread_group.ad_group2.id
  role_definition_name = "Key Vault Contributor"
  scope         = azurerm_key_vault.keyvault[each.key].id

    depends_on = [
    azurerm_key_vault.keyvault
  ]

}