# Create team schemas
resource "snowflake_schema" "team_schema" {
  for_each            = local.schemas
  database            = split("|", each.key)[0]
  name                = split("|", each.key)[1]
  is_transient        = var.schema_default_is_transient
  is_managed          = true
  data_retention_days = var.schema_default_data_retention_days
  depends_on          = [snowflake_database.db]
}

#Object owner
resource "snowflake_role" "object_owner" {
  for_each = local.schemas
  name     = "Z_${replace(each.key, "|", "_")}_OWNER"
  comment  = "A sudo role to own schema objects"
  depends_on = [
    snowflake_database.db,
    snowflake_schema.team_schema
  ]
}

#Object read-only role
resource "snowflake_role" "object_ro" {
  for_each   = local.schemas
  name       = "Z_${replace(each.key, "|", "_")}_RO"
  comment    = "A sudo role to read schema objects"
  depends_on = [
    snowflake_database.db,
    snowflake_schema.team_schema
  ]
}

#Object read-view-only role
resource "snowflake_role" "object_rvo" {
  for_each   = local.schemas
  name       = "Z_${replace(each.key, "|", "_")}_RVO"
  comment    = "A sudo role to read schema views"
  depends_on = [
    snowflake_database.db,
    snowflake_schema.team_schema
  ]
}

resource "snowflake_role_grants" admin_object_owner_grant {
  for_each  = local.schemas
  role_name = "Z_${replace(each.key, "|", "_")}_OWNER"
  roles = [
    var.sys_onwer_role
  ]
  depends_on = [
    snowflake_role.object_owner
  ]
}


resource "snowflake_grant_privileges_to_role" "schema_usage_grant" {
  for_each   = toset(local.database_schema_roles)
  privileges = ["USAGE"]
  role_name  = split("|", each.key)[2]
  on_schema {
    schema_name = "${split("|", each.key)[0]}.${split("|", each.key)[1]}"
  }
  with_grant_option = false
  depends_on = [
    snowflake_database.db,
    snowflake_role.object_ro,
    snowflake_role.object_owner,
    snowflake_role.object_rvo
  ]
}

resource "snowflake_grant_privileges_to_role" "schema_future_ownership_grant" {
  for_each   = toset(local.schema_future_ownership_grant)
  privileges = ["OWNERSHIP"]
  role_name  = "Z_${split("|", each.key)[0]}_${split("|", each.key)[1]}_OWNER"
  on_schema_object {
    future {
      object_type_plural = split("|", each.key)[2]
      in_schema          = "${split("|", each.key)[0]}.${split("|", each.key)[1]}"
    }
  }
  with_grant_option = false
  depends_on = [
    snowflake_schema.team_schema,
    snowflake_role.object_owner,
    snowflake_role_grants.admin_object_owner_grant
  ]
}


resource "snowflake_grant_privileges_to_role" "schema_future_ro_grant" {
  for_each   = toset(local.schema_ro_access)
  privileges = split(",", split("|", each.key)[3])
  role_name  = "Z_${split("|", each.key)[0]}_${split("|", each.key)[1]}_RO"
  on_schema_object {
    future {
      object_type_plural = split("|", each.key)[2]
      in_schema          = "${split("|", each.key)[0]}.${split("|", each.key)[1]}"
    }
  }
  with_grant_option = false
  depends_on = [
    snowflake_schema.team_schema,
    snowflake_role.object_ro
  ]
}


resource "snowflake_grant_privileges_to_role" "schema_future_rvo_grant" {
  for_each   = toset(local.schema_rvo_access)
  privileges = split(",", split("|", each.key)[3])
  role_name  = "Z_${split("|", each.key)[0]}_${split("|", each.key)[1]}_RVO"
  on_schema_object {
    future {
      object_type_plural = split("|", each.key)[2]
      in_schema          = "${split("|", each.key)[0]}.${split("|", each.key)[1]}"
    }
  }
  with_grant_option = false
  depends_on = [
    snowflake_schema.team_schema,
    snowflake_role.object_rvo
  ]
}


resource "snowflake_grant_privileges_to_role" "schema_owner_all_grant" {
  for_each  = local.schemas
  role_name = "Z_${split("|", each.key)[0]}_${split("|", each.key)[1]}_OWNER"
  on_schema {
    schema_name = "${split("|", each.key)[0]}.${split("|", each.key)[1]}"
  }
  all_privileges    = true
  with_grant_option = false
  depends_on = [
    snowflake_database.db,
    snowflake_schema.team_schema,
    snowflake_role.object_owner
  ]
}

#Task Admin Grant
resource "snowflake_role_grants" "task_admin_grants" {
  for_each               = local.schemas
  role_name              = "TASKADMIN"
  roles                  = local.schema_owners
  enable_multiple_grants = false
  depends_on = [
    snowflake_role.object_owner
  ]
}