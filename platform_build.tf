locals {
  #build=var.env=="SB"?local.SB:var.env=="DEV"?local.DEV:local.PROD
  build=local.SB
}

module "storage_accounts_containers" {
  source        ="./modules/storage_accounts_containers"
  env           = var.env
  conns         = var.conns
  platform      = var.platform
  application   = var.application
  context       = var.context
  az_resource_block  = local.build.teams
  block_name  = local.build
  az_locale     = var.az_zone_locale
  zone_loc      = var.zone_loc
}

module "key_vault" {
  source        ="./modules/key_vaults"
  env           = var.env
  conns         = var.conns
  platform      = var.platform
  application   = var.application
  context       = var.context
  az_resource_block  = local.build.teams
  block_name  = local.build
  zone_loc      = var.zone_loc
  az_locale     = var.az_zone_locale
}
