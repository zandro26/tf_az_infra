locals {
  SB = {

#  common_tags = {
#  tag1 = val
#  tag2 = val
#  }

    teams = {
      DATAHUB = {
        keyvaults = {
         vault1 ={ 
          rw                = ["sec-grp1", "sec-grp2"]
          ro                = ["sec-grp1", "sec-grp2"]
          allowed_ip_ranges = ["0.0.0.0", "20.37.110.0/24"]
          allowed_vnets     = ["sx-cap-vnet1", "sx-cap-vnet2"]
        # tag = val
         }

       vault2 ={ 
          rw                = ["sec-grp1", "sec-grp2"]
          allowed_ip_ranges = ["0.0.0.0", "20.37.110.0/24"]
          allowed_vnets     = ["sx-cap-vnet1", "sx-cap-vnet2"]
        # tag = val
         }
        }

        az_storage_accounts = { ##Ensure to use Gen2 https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem
          # soft_delete_retention_days = 14 -- make it as default value for the module
          datahub1 = {
            iam = {
              "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
              "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
              "Storage Blob Data Owner"      =  ["sec-grp1", "sec-grp2"]
            }
            containers = {
             landing = {
                "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
                #"Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
                "Storage Blob Data Owner"      =  ["sec-grp1", "sec-grp2"]
              }
              raw = {
                "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
                "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
              }
            }
            allowed_ip_ranges = ["20.39.110.0/24", "20.37.110.0/24"]
            allowed_vnets     = ["sx-cap-vnet1", "sx-cap-vnet2"]
            #        tag = {
            #   tag1= val
            # }
             }
        

        datahub2 = {
            iam = {
              #"Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
              "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
            }
            containers = {
             processed = {
                "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
              }
              trimmed = {
                "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
                "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
              }
            }
            allowed_ip_ranges = ["20.37.110.0/24"]
            #allowed_ip_ranges = ["20.39.110.0/24", "20.37.110.0/24"]
            # allowed_ip_ranges = ["0.0.0.0", "20.37.110.0/24"]
            allowed_vnets     = ["sx-cap-vnet1", "sx-cap-vnet2"]
          }
        }
      }
    }

  }
}
