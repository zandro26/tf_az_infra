locals {
  SB = {
    common_tags = {
      environment = "${var.env}"
      department  = "${var.context}"
      application = "${var.application}"
      source      = "terraform"

    }
    teams = {
      DATAHUB = {
        keyvault_deploy = true
        keyvault_parameters = {
          resource_tag = { owner = "snowflake user" }
          rbac = {
            "Key Vault Administrator" = ["sec-grp1", "sec-grp2"]
            "Key Vault Secrets User"  = ["sec-grp2"]
          }
        }

        az_storage_accounts = { ##Ensure to use Gen2 https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem
          # soft_delete_retention_days = 14 -- make it as default value for the module
          datahub1 = {
            iam = {
              "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
              "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
              "Storage Blob Data Owner"       = ["sec-grp1", "sec-grp2"]
            }
            containers = {
              landing = {
                iam = {
                  "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
                  #"Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
                  "Storage Blob Data Owner" = ["sec-grp1", "sec-grp2"]
                }
              }
              raw = {
                iam = {
                  "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
                  "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
                }

              }
            }
            allowed_ip_ranges = ["20.39.110.0/24", "20.37.110.0/24"]
            allowed_vnets     = ["sx-cap-vnet1", "sx-cap-vnet2"]
            resource_tag = {
            owner = "Data Admin" }
          }


          datahub2 = {
            iam = {
              #"Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
              "Storage Blob Data Reader" = ["sec-grp1", "sec-grp2"]
            }
            containers = {
              processed = {
                iam = {
                  "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
                }
              }
              trimmed = {
                iam = {
                  "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
                  "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
                }
              }
            }
            allowed_ip_ranges = ["20.37.110.0/24"]
            #allowed_ip_ranges = ["20.39.110.0/24", "20.37.110.0/24"]
            # allowed_ip_ranges = ["0.0.0.0", "20.37.110.0/24"]
            allowed_vnets = ["sx-cap-vnet1", "sx-cap-vnet2"]
            resource_tag = {
              owner = "Data Users"
            viewer = "Data Viewers" }
          }
        }
      }
    }

  }
}
