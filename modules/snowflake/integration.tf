#Azure Storage Integration
resource snowflake_storage_integration azure_storage_integration {
  for_each=var.azure_storage_integrations
  name    = "${each.key}_${var.env}"
  comment = "A storage integration for ${each.key} ${var.env}."
  type    = "EXTERNAL_STAGE"
  enabled = true
  storage_provider = "AZURE"
  azure_tenant_id = each.value.azure_tenant_id 
  storage_allowed_locations = each.value.locs
}

#Integration Usage Grant
resource snowflake_grant_privileges_to_role integration_usage_grants {
  for_each = toset(local.integration_grants)
  privileges       = ["USAGE"]
  role_name = split("|",each.key)[1]
  on_account_object {
    object_type = "INTEGRATION"
    object_name = split("|",each.key)[0]
  }
  with_grant_option = false
  depends_on = [snowflake_storage_integration.azure_storage_integration,
                snowflake_role.svc_roles]
}