locals {
  #build=var.env=="SB"?local.SB:var.env=="DEV"?local.DEV:local.PROD
  build=local.SB
}

module "azure" {
  source        ="./modules/azure"
  env           = var.env
  platform      = var.platform
  application   = var.application
  context       = var.context
  azure_domain  = local.build.az_domains
  az_tenant_id  = var.conns.az_tenant_id
  zone_loc      = var.zone_loc

  #allowed_vnets = var.allowed_vnets
  #az_subscription_id = var.conns.az_subscription_id

}
