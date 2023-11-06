

# creating keyvault
resource azurerm_key_vault keyvault {
    for_each = var.az_resource_block
    name                       = lower("${var.platform}${each.key}keyvault${var.zone_loc}${var.env}")
    location                   = var.az_locale
    resource_group_name        = var.az_resource_group_name
    tenant_id                  = var.conns.az_tenant_id
    soft_delete_retention_days = 7
    purge_protection_enabled   = false
    sku_name                   = "standard"
   
    enable_rbac_authorization = true

  network_acls {
    bypass           = "AzureServices"
    default_action   = "Allow"
    ip_rules         = each.value.keyvault.allowed_ip_ranges
    #virtual_network_subnet_ids = [data.azurerm_subnet.appsnet[each.key].id]
    virtual_network_subnet_ids = [var.az_subnet_id]
  }
depends_on = [ 
  azurerm_key_vault.keyvault
   ]
   tags = {
 environment = lower("${var.env}")
  }
  }