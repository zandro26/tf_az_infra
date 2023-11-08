
# # linking keyvault to PE
# resource "azurerm_private_endpoint" "keyvault_priv_endpt" {
#  #for_each = var.az_resource_block
#   for_each                   = toset(local.keyvaults_list)
#   name                       = "prvendpt-${azurerm_key_vault.keyvault[each.key].name}"
#   #name                       = "prvendpt-${each.value.keyvault.name}"
#   location                   = var.az_locale
#   #resource_group_name        = var.az_resource_group_name
#   resource_group_name        = data.azurerm_resource_group.resourcegroup.name
#   #subnet_id                  = var.az_subnet_id
#   subnet_id                  = data.azurerm_subnet.appsnet.id
#   #subnet_id                  = var.az_app_subnet_id
#   private_service_connection {
#     #name                           = each.value.private_service_con.name
#     name                           = "prvserviceconn-${azurerm_key_vault.keyvault[each.key].name}"
#     private_connection_resource_id = azurerm_key_vault.keyvault[each.key].id
#     #private_connection_resource_id = each.value.keyvault.name.id
#     subresource_names              = ["vault"]
#     is_manual_connection           = false
#   }
#     depends_on = [
#        azurerm_key_vault.keyvault
#     ]
#     private_dns_zone_group {
#     name                 = lower("dnsgrp${var.env}${local.app_team_name[0]}")
#     private_dns_zone_ids = [data.azurerm_private_dns_zone.privatednszone.id]
#     #private_dns_zone_ids = [var.privatednszone_id]
#   }
# }

