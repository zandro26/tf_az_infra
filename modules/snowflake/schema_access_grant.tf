#Object onwer role Grants
resource "snowflake_role_grants" "object_owner_role_grants" {
  for_each               = local.schema_owner_grants
  role_name              = each.key
  roles                  = each.value
  enable_multiple_grants = false
  depends_on = [
    snowflake_role.svc_roles,
    snowflake_role.object_ro,
    snowflake_role.object_owner,
    snowflake_role.object_rvo
  ]
}

#Object onwer role Grants
resource "snowflake_role_grants" "object_ro_role_grants" {
  for_each               = local.schema_ro_grants
  role_name              = each.key
  roles                  = each.value
  enable_multiple_grants = false
  depends_on = [
    snowflake_role.svc_roles,
    snowflake_role.object_ro,
    snowflake_role.object_owner,
    snowflake_role.object_rvo
  ]
}

#Object onwer role Grants
resource "snowflake_role_grants" "object_rvo_role_grants" {
  for_each               = local.schema_rvo_grants
  role_name              = each.key
  roles                  = each.value
  enable_multiple_grants = false
  depends_on = [
    snowflake_role.svc_roles,
    snowflake_role.object_ro,
    snowflake_role.object_owner,
    snowflake_role.object_rvo
  ]
}