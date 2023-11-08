

# creating keyvault
  resource azurerm_key_vault keyvault {
    for_each                   = toset(local.keyvaults_list)
    name                       = lower("kv${each.key}${var.env}${local.app_team_name[0]}")
    location                   = var.az_locale
    resource_group_name        = data.azurerm_resource_group.resourcegroup.name
    tenant_id                  = var.conns.az_tenant_id
    soft_delete_retention_days = 7
    purge_protection_enabled   = false
    sku_name                   = "standard"
   
    enable_rbac_authorization = true

  network_acls {
    bypass           = "AzureServices"
    default_action   = "Allow"
    ip_rules         = local.allowed_ip_ranges_kv
    virtual_network_subnet_ids = [data.azurerm_subnet.appsnet.id]  
   }

   tags = {
 environment = lower("${var.env}")
  }
  }