locals {
  DEV = {

    sf_service_accounts_key = [
      "DATAHUB_DEVOPS",
      "DATAHUB_DATABRICKS",
      "DATAHUB_DBT"
    ]

    sf_service_accounts_pwd = [
      "DATAHUB_ADF"
    ]

    sf_azure_storage_integrations = {
      ADL_INT = {
        azure_tenant_id = var.conns.az_tenant_id
        locs            = ["azure://tenzingmaxadls.blob.core.windows.net/landing/"]
        usage_grants = {
          roles            = ["DATAHUB_ENGINEER"]
          service_accounts = ["DATAHUB_ADF"]
        }
      }
    }

    sf_databases_schemas = {
      DATAHUB = {
        RAW = {
          rw           = ["DATAHUB_ADMIN"]
          ro           = ["DATAHUB_ENGINEER"]
          rvo          = ["DATAHUB_ANALYST"]
          rw_svc_acct  = ["DATAHUB_DEVOPS"]
          ro_svc_acct  = ["DATAHUB_DBT"]
          rvo_svc_acct = ["DATAHUB_DATABRICKS"]
        }
        REFINED = {
          rw           = []
          ro           = []
          rvo          = []
          rw_svc_acct  = []
          ro_svc_acct  = []
          rvo_svc_acct = []
        }
      }
    }

    schema_default_is_transient        = false
    schema_default_data_retention_days = 10

    sf_compute_groups = {
      DATAHUB = {
        warehouses = {
          WH = {
            size                         = "x-small"
            auto_suspend                 = 10
            max_cluster_count            = 1
            statement_timeout_in_seconds = 1200
            scaling_policy               = "STANDARD"
          }
        }
        group_members    = ["DATAHUB_ADMIN", "DATAHUB_ENGINEER", "DATAHUB_ANALYST"]
        service_accounts = ["DATAHUB_DEVOPS", "DATAHUB_DBT", "DATAHUB_DATABRICKS"]
        credit_quota     = 200
        notify_users     = []
      }
      PLTF = {
        warehouses = {
          WH = {
            size                         = "x-small"
            auto_suspend                 = 10
            max_cluster_count            = 1
            statement_timeout_in_seconds = 1200
            scaling_policy               = "STANDARD"
          }
        }
        group_members    = ["DATAHUB_ADMIN", "DATAHUB_ENGINEER", "DATAHUB_ANALYST"]
        service_accounts = ["DATAHUB_DEVOPS", "DATAHUB_DBT", "DATAHUB_DATABRICKS"]
        credit_quota     = 200
        notify_users     = []
      }
    }

  }
}
