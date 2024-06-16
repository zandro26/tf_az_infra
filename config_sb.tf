locals {
  SB = {

    # sf_service_accounts_key = [
    #   "DATAHUB_DEVOPS",
    #   "DATAHUB_DATABRICKS",
    #   "DATAHUB_DBT"
    # ]

    # sf_service_accounts_pwd = [
    #   "DATAHUB_ADF"
    # ]

    # sf_azure_storage_integrations = {
    #   ADL_INT = {
    #     azure_tenant_id = var.conns.az_tenant_id
    #     locs            = ["azure://tenzingmaxadls.blob.core.windows.net/landing/"]
    #     usage_grants = {
    #       roles            = ["DATAHUB_ENGINEER"]
    #       service_accounts = ["DATAHUB_ADF"]
    #     }
    #   }  
    # }

    # sf_databases_schemas = {
    #   DATAHUB = {
    #     RAW = {
    #       rw           = ["DATAHUB_ADMIN"]
    #       ro           = ["DATAHUB_ENGINEER"]
    #       rvo          = ["DATAHUB_ANALYST"]
    #       rw_svc_acct  = ["DATAHUB_DEVOPS"]
    #       ro_svc_acct  = ["DATAHUB_DBT"]
    #       rvo_svc_acct = ["DATAHUB_DATABRICKS"]
    #     }
    #     REFINED = {
    #       rw           = []
    #       ro           = []
    #       rvo          = []
    #       rw_svc_acct  = []
    #       ro_svc_acct  = []
    #       rvo_svc_acct = []
    #     }
    #   }
    # }

    # schema_default_is_transient        = false
    # schema_default_data_retention_days = 10

    # sf_compute_groups = {
    #   DATAHUB = {
    #     warehouses = {
    #       WH = {
    #         size                         = "x-small"
    #         auto_suspend                 = 10
    #         max_cluster_count            = 1
    #         statement_timeout_in_seconds = 1200
    #         scaling_policy               = "STANDARD"
    #       }       
    #     }
    #     group_members    = ["DATAHUB_ADMIN", "DATAHUB_ENGINEER", "DATAHUB_ANALYST"]
    #     service_accounts = ["DATAHUB_DEVOPS", "DATAHUB_DBT", "DATAHUB_DATABRICKS"]
    #     credit_quota     = 200
    #     notify_users     = []
    #   }
    #   PLTF = {
    #     warehouses = {
    #       WH = {
    #         size                         = "x-small"
    #         auto_suspend                 = 10
    #         max_cluster_count            = 1
    #         statement_timeout_in_seconds = 1200
    #         scaling_policy               = "STANDARD"
    #       }
    #     }
    #     group_members    = ["DATAHUB_ADMIN", "DATAHUB_ENGINEER", "DATAHUB_ANALYST"]
    #     service_accounts = ["DATAHUB_DEVOPS", "DATAHUB_DBT", "DATAHUB_DATABRICKS"]
    #     credit_quota     = 200
    #     notify_users     = []
    #   }
    # }

    # dbt_projects = {
    #   DATAHUB = {
    #     # repo_url="git@ssh.dev.azure.com:v3/vodafonenz/DX%20Data/z_dbt_ado_test"
    #     repo_url              = "https://vodafonenz@dev.azure.com/vodafonenz/DX%20Data/_git/z_dbt_ado_test"
    #     sf_account            = "vodafonenz-nonprod"
    #     sf_database           = "DEV_DATAHUB"
    #     sf_warehouse          = "DEV_DATAHUB_WH"
    #     sf_session_keep_alive = "true"
    #     sf_allow_sso          = "true"
    #     sf_role               = "TEST_ROLE"
    #     token_permissions = {
    #       admin = ["DATAHUB"]
    #     }
    #     job_admin  = ["secgrp-azr-datahub-prod-admin"]
    #     job_viewer = ["secgrp-azr-datahub-prod-data-engineer"]
    #     environments = {
    #       Development = {
    #         env_type      = "development"
    #         branch        = ""
    #         dbt_version   = "1.1.0-latest"
    #         supports_docs = "false"
    #         threads       = ""
    #         auth_type     = ""
    #         sf_user       = ""
    #         sf_schema     = ""
    #         sf_target     = ""
    #       }
    #       Default = {
    #         env_type      = "deployment"
    #         branch        = "dev"
    #         dbt_version   = "1.1.0-latest"
    #         supports_docs = "false"
    #         threads       = "4"
    #         auth_type     = "keypair"
    #         sf_user       = "SVC_DEV_DATAHUB_DBT"
    #         sf_schema     = "A1_RAW"
    #         sf_target     = "DEV_DATAHUB"
    #       }
    #     }
    #   }
    # }


    # az_rg_naming_convention = "sx-rg-[env]-[domain]"
    # az_sa_naming_convention = "xsffgsa-[env]-[domain]"
    # az_kv_naming_convention = "kv[env][domain]"
    # az_pe_naming_convention = "pe[env][domain]"
 

    datahub = {
      DATAHUB = {
        resourcegroup ={
          name = "z-infrastructure-schealthsociety-rgroup-ae-sb"
          location = "Australia East"
        }
        keyvault = {
          name                        = lower("kv-${var.env}-sx")
          # location                    = "Australia East"
          # resource_group_name         = "sx-sb-rgroup-test"
          az_tenant_id                = var.conns.az_tenant_id
          soft_delete_retention_days  = 7
          purge_protection_enabled    = false
          sku_name                    = "standard"
          rw                = ["sec-grp1", "sec-grp2"]
          ro                = ["sec-grp1", "sec-grp2"]
          allowed_ip_ranges = ["10.0.0.0/16", "20.37.0.0/16"]
          allowed_vnets     = ["vnet1", "vent2"]
        }
        az_storage_accounts = { ##Ensure to use Gen2 https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem
          # soft_delete_retention_days = 14 -- make it as default value for the module
           name                     = lower("azsa${var.env}sx")
          #  resource_group_name      = "sx-sb-rgroup-test"
          #  location                 = "Australia East"
           account_tier             = "Standard"
           account_replication_type = "GRS"
          datahub = {
            iam = {
              "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
            }
            containers = {
              name = lower("sbdc${var.env}sx")
              container_access_type = "blob"
              landing = {
                "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
                "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
              }
              raw = {
                "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
                "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
              }
            }
            allowed_ip_ranges = ["10.0.0.0/16", "20.37.0.0/16"]
            allowed_vnets     = ["vnet1", "vent2"]
          }
        }
         virtualnetwork = {
          name                        = "z-infrastructure-schealthsociety-vnet-ae-dv"
          address_space               =  ["10.0.0.0/16"]
        }
         az_subnet = {
          name                        = "z-infrastructure-schealthsociety-prvapp-snet-ae-dv"
          address_prefixes            =  ["10.0.1.0/24"]
        }
        
         public_ip = {
          name                        = lower("public-ip${var.env}sx")
          sku                         = "Standard"
          allocation_method          = "Static"
        }
         az_lb = {
          name                        = lower("azlb${var.env}sx")
          sku                         = "Standard"
         }
          fe_ip_con = {
           name                        = lower("fe_ip_con${var.env}sx")
         }
            privatelink = {
              name                        = lower("privatelink${var.env}sx")
                          }
          nat_ip = {
            name                        = lower("natip${var.env}sx")
            address_prefixes            =  ["10.0.1.0/24"]
              }
          private_endpoint = {
            name                        = lower("pe${var.env}sx")
            address_prefixes            =  ["10.0.1.0/24"]
              }
          private_service_con = {
            name                        = lower("pservicecon${var.env}sx")
  
              }
      }
    }

  }
}
