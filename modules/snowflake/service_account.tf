# Service Accounts and Roles
resource snowflake_role svc_roles {
  for_each = toset(flatten([var.service_accounts_key,var.service_accounts_pwd]))
  name    = "SVC_${each.key}_${var.env}"
  comment = "Service account role for ${each.key}."
}

resource snowflake_user svc_users_key {
  for_each = toset(var.service_accounts_key)
  name         = "SVC_${each.key}_${var.env}"
  login_name   = "SVC_${each.key}_${var.env}"
  comment      = "Service user for ${each.key}."
  disabled     = false
  default_role   = "SVC_${var.env}_${each.key}"
  # rsa_public_key   = ""
  depends_on=[snowflake_role.svc_roles]
}

resource snowflake_user svc_users_pwd {
  for_each = toset(var.service_accounts_pwd)
  name         = "SVC_${each.key}_${var.env}"
  login_name   = "SVC_${each.key}_${var.env}"
  comment      = "Service user for ${each.key}."
  disabled     = false
  default_role   = "SVC_${each.key}_${var.env}"
  # password   = ""
  depends_on=[snowflake_role.svc_roles]
}

resource snowflake_role_grants svc_role_grants {
  for_each = toset(flatten([var.service_accounts_key,var.service_accounts_pwd]))
  role_name = "SVC_${each.key}_${var.env}"
  users = [
    "SVC_${each.key}_${var.env}"
  ]
  enable_multiple_grants = false
  depends_on = [snowflake_user.svc_users_key,snowflake_user.svc_users_pwd]
}