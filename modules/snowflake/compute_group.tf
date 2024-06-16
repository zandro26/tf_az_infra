# Create group resource monitors
resource snowflake_resource_monitor group_monitor {
    for_each = var.compute_groups
    name         = "${each.key}_LIMIT_${var.env}"
    credit_quota = each.value.credit_quota
    notify_triggers            = var.wh_notify_triggers
    suspend_trigger           = var.wh_suspend_trigger
    suspend_immediate_trigger = var.wh_suspend_immediate_trigger
    notify_users = each.value.notify_users
}

# Create group warehouses
resource snowflake_warehouse group_warehouse {
  for_each = local.warehouses
  name = "${each.key}_${var.env}"
  warehouse_size = upper(each.value.config.size)
  auto_suspend  = each.value.config.auto_suspend
  max_cluster_count = each.value.config.max_cluster_count
  scaling_policy = upper(each.value.config.scaling_policy)
  resource_monitor = "${each.value.group}_LIMIT_${var.env}"
  statement_timeout_in_seconds = each.value.config.statement_timeout_in_seconds
  depends_on = [snowflake_resource_monitor.group_monitor]
}


#Group Warehouse Grant
resource snowflake_grant_privileges_to_role group_warehouse_grant {
  for_each = toset(local.warehouse_grants)
  privileges       = ["USAGE","MONITOR","OPERATE"]
  role_name = split("|",each.key)[1]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = split("|",each.key)[0]
  }
  with_grant_option = false
  depends_on = [snowflake_warehouse.group_warehouse,snowflake_role.svc_roles]
}


#Group Monitor Grant
resource snowflake_grant_privileges_to_role group_monitor_grant {
  for_each = toset(local.rm_grants)
  privileges       = ["MONITOR"]
  role_name = split("|",each.key)[1]
  on_account_object {
    object_type = "RESOURCE MONITOR"
    object_name = split("|",each.key)[0]
  }
  with_grant_option = false
  depends_on = [snowflake_warehouse.group_warehouse,snowflake_role.svc_roles]
}