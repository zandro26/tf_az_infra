# data "azurerm_client_config" "current" {
# }

# resource "azurerm_role_assignment" "akv_sp" {
#   scope                = var.azurerm_key_vault.name.id
#   role_definition_name = "Key Vault Secrets Officer"
#   principal_id         = data.azurerm_client_config.current.object_id
# }