locals {
  #build=var.env=="SB"?local.SB:var.env=="DEV"?local.DEV:local.PROD
  build=local.SB
}

module "storage_accounts_containers" {
  source        ="./modules/storage_accounts_containers"
  env           = var.env
  platform      = var.platform
  application   = var.application
  context       = var.context
  az_resource_block  = local.build.teams
  zone_loc      = var.zone_loc
  privatednszone_id  = data.azurerm_private_dns_zone.privatednszone.id
  az_client_config_object_id = data.azurerm_client_config.current.object_id
 

}

module "key_vault" {
  source        ="./modules/key_vaults"
  env           = var.env
  conns         = var.conns
  platform      = var.platform
  application   = var.application
  context       = var.context
  az_resource_block  = local.build.teams
  zone_loc      = var.zone_loc
  privatednszone_id  = data.azurerm_private_dns_zone.privatednszone.id
  az_client_config_object_id = data.azurerm_client_config.current.object_id
  #az_app_subnet_id = data.azurerm_subnet.app_subnet.id
}
