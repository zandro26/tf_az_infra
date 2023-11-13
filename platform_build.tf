# locals {
#   #build=var.env=="SB"?local.SB:var.env=="DEV"?local.DEV:local.PROD
#   build = local.SB
# }

# module "storage_accounts_containers" {
#   //for each
#   source            = "./modules/storage_accounts_containers"
#   env               = var.env
#   conns             = var.conns
#   platform          = var.platform
#   application       = var.application
#   context           = var.context
#   az_resource_block = local.build.teams
#   block_name        = local.build
#   az_locale         = var.az_zone_locale
#   zone_loc          = var.zone_loc
# }

# module "key_vault" {
#   source            = "./modules/key_vaults"
#   env               = var.env
#   conns             = var.conns
#   platform          = var.platform
#   application       = var.application
#   context           = var.context
#   az_resource_block = local.build.teams
#   block_name        = local.build
#   zone_loc          = var.zone_loc
#   az_locale         = var.az_zone_locale
# }

locals {
  environments = {
    sb  = var.env_dev
    # test = var.env_test
  }
}
//loop here not inside the module
module "keyvault" {
  source   = "./modules/key_vaults_test"
  for_each = local.environments[var.env]

  az_locale           = var.az_zone_locale
  env                 = var.env
  keyvault_deploy     = each.value.keyvault_deploy
  name                = each.key
  appsnet             = data.azurerm_subnet.appsnet.id
  resourcegroup       = data.azurerm_resource_group.resourcegroup.name
  conns               = var.conns
  privatednszone      = data.azurerm_private_dns_zone.privatednszone.id
  keyvault_parameters = try(each.value.keyvault_parameters, null)
}
