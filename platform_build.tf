locals {
  #build=var.env=="SB"?local.SB:var.env=="DEV"?local.DEV:local.PROD
  build=local.SB
}
#   azprojects = [ for az_key, 
#   az_val in local.build.az_domains : az_key]
# }


# # Snowflake Build
# module snowflake {
#   source = "./modules/snowflake"
#   env = var.env
#   service_accounts_key = local.build.sf_service_accounts_key
#   service_accounts_pwd = local.build.sf_service_accounts_pwd
#   azure_storage_integrations = local.build.sf_azure_storage_integrations
#   databases_schemas = local.build.sf_databases_schemas
#   schema_default_is_transient        = local.build.schema_default_is_transient
#   schema_default_data_retention_days = local.build.schema_default_data_retention_days
#   compute_groups = local.build.sf_compute_groups
# }
# resource az_domains test {
#   for_each = local.build.az_domains
#   name = each.key
# }
module "azure" {
  source        ="./modules/azure"
  env           = var.env
  zone_loc      = var.zone_loc
  platform      = var.platform
  application   = var.application
  context       = var.context
  azure_domain  = local.build.datahub	
  az_tenant_id  = var.conns.az_tenant_id
  block_name  = local.build
  #az_subscription_id = var.conns.az_subscription_id

}