

# creating keyvault
resource azurerm_key_vault keyvault {
    for_each = var.az_resource_block
    #name                       = each.value.keyvault.name
    #name                       = lower("${var.platform}${var.context}kv${var.zone_loc}${var.env}")
    name                       = lower("${var.platform}${each.key}kv${var.zone_loc}${var.env}")
    location                   = local.location
    resource_group_name        = local.resource_group_name
    #tenant_id                  = each.value.keyvault.az_tenant_id 
    tenant_id                  = var.conns.az_tenant_id
    soft_delete_retention_days = 7
    purge_protection_enabled   = false

    sku_name = "standard"


  access_policy {
    #tenant_id = each.value.keyvault.az_tenant_id 
    tenant_id = var.conns.az_tenant_id
    object_id = var.az_client_config_object_id
    secret_permissions = ["List"] #"list", "set", "delete"]
    key_permissions    = ["Get"] #, "create", "delete"]
    certificate_permissions = ["List"] #, "list", "delete"]
  }

#assigning service principal
# data "azuread_service_principals" "secgrpids" {
#   client_ids = ["sec-grp1", "sec-grp2"
#   ]
# }

# resource "azurerm_key_vault_access_policy" "example-principal" {
#   key_vault_id = azurerm_key_vault.example.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azuread_service_principal.example.object_id

#   key_permissions = [
#     "Get", "List", "Encrypt", "Decrypt"
#   ]
# }

  network_acls {
    bypass           = "AzureServices"
    default_action   = "Allow"
    ip_rules         = each.value.keyvault.allowed_ip_ranges
    virtual_network_subnet_ids = [data.azurerm_subnet.appsnet[each.key].id]
    #virtual_network_subnet_ids = [var.az_app_subnet_id]
  }
depends_on = [ 
  azurerm_key_vault.keyvault
   ]
   tags = {
 environment = lower("${var.env}")
  }
  }