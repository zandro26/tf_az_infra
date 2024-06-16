variable env {
  type    = string
}



variable service_accounts_key {
  type    = list
  default = []
}

variable service_accounts_pwd {
  type    = list
  default = []
}

variable azure_storage_integrations {
  type    = map
  default = {}
}

variable databases_schemas {
  type    = map
  default = {}
}

variable compute_groups {
  type    = map
  default = {}
}

variable wh_notify_triggers {
  type    = list
  default = [70, 90]
}

variable wh_suspend_trigger {
  type    = number
  default = 100
}

variable wh_suspend_immediate_trigger {
  type    = number
  default = 110
}

variable schema_default_is_transient {
  type    = bool
  default = false
}

variable schema_default_data_retention_days {
  type    = number
  default = 10
}

variable sys_onwer_role {
  type = string
  default = "SYS_OWNER"
}

variable schema_object_owernship{
  type = list
  default = [
    "ALERTS",
    "EVENT TABLES",
    "FILE FORMATS",
    "FUNCTIONS",
    "PROCEDURES",
    "SEQUENCES",
    "PIPES",
    "STAGES",
    "STREAMS",
    "TABLES",
    "EXTERNAL TABLES",
    "TASKS",
    "VIEWS",
    "MATERIALIZED VIEWS"
  ]
}


variable schema_ro_access{
  type = list
  default = [
    "TABLES|SELECT",
    "VIEWS|SELECT",
    "MATERIALIZED VIEWS|SELECT",
    "EXTERNAL TABLES|SELECT",
    "TASKS|MONITOR",
    "STREAMS|SELECT",
    "STAGES|USAGE,READ"
  ]
}

variable schema_rvo_access{
  type = list
  default = [
    "VIEWS|SELECT",
    "MATERIALIZED VIEWS|SELECT"
  ]
}