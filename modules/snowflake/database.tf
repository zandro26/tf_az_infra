# Set up Database
resource "snowflake_database" "db" {
  for_each = var.databases_schemas
  name = "${each.key}_${var.env}"
}

resource snowflake_grant_privileges_to_role db_usage_grant {
  for_each = toset(local.database_schema_roles)
  privileges       = ["USAGE"]
  role_name = split("|",each.key)[2]
  on_account_object {
    object_type = "DATABASE"
    object_name = split("|",each.key)[0]
  }
  with_grant_option = false
  depends_on=[
      snowflake_database.db,
      snowflake_role.object_ro,
      snowflake_role.object_owner,
      snowflake_role.object_rvo
  ]
}