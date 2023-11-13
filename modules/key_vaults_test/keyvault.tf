resource azurerm_key_vault keyvault {
    count = var.keyvault_deploy ? 1 : 0
   
    name                       = lower("kv${var.name}${var.env}teams") //naming convention can be decided at the config level or here
    location                   = var.az_locale
    resource_group_name        = var.resourcegroup
    tenant_id                  = var.conns.az_tenant_id
    soft_delete_retention_days = 7
    purge_protection_enabled   = true
    sku_name                   = "standard"

    //do we need these?

    enable_rbac_authorization = true

    network_acls {
    bypass           = "AzureServices"
    default_action   = "Deny"
    ip_rules         = var.akv_ip_rules
    virtual_network_subnet_ids = [var.appsnet]
    }

}



resource "azurerm_private_endpoint" "keyvault_pe" {
    count = var.keyvault_deploy ? 1 : 0

    name = "keyvaultpe"
    location = var.az_locale
    resource_group_name = var.resourcegroup
    subnet_id = var.appsnet
    //tags

    private_dns_zone_group {
      name = "dnsgrp${var.env}${var.name}"
      private_dns_zone_ids = [var.privatednszone]
    }
    private_service_connection {
      name = "prvserviceconn-${azurerm_key_vault.keyvault[0].name}"
      is_manual_connection = false
      private_connection_resource_id = azurerm_key_vault.keyvault[0].id
      subresource_names = ["vault"]
    }
}