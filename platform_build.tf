locals {
  #build=var.env=="SB"?local.SB:var.env=="DEV"?local.DEV:local.PROD
  build=local.SB
}

module "storage_account" {
  source        ="./modules/storage_accounts"
  env           = var.env
  platform      = var.platform
  application   = var.application
  context       = var.context
  azure_domain  = local.build.az_domains
  az_tenant_id  = var.conns.az_tenant_id
  zone_loc      = var.zone_loc
  privatednszone_id  = data.azurerm_private_dns_zone.privatednszone.id

 

}

module "key_vault" {
  source        ="./modules/key_vaults"
  env           = var.env
  platform      = var.platform
  application   = var.application
  context       = var.context
  azure_domain  = local.build.az_domains
  az_tenant_id  = var.conns.az_tenant_id
  zone_loc      = var.zone_loc
  privatednszone_id  = data.azurerm_private_dns_zone.privatednszone.id
}
