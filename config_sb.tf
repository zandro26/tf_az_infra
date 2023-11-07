locals {
  SB = {

    # az_rg_naming_convention = "sx-rg-[env]-[domain]"
    # az_sa_naming_convention = "xsffgsa-[env]-[domain]"
    # az_kv_naming_convention = "kv[env][domain]"
    # az_pe_naming_convention = "pe[env][domain]"
 

    teams = {
      DATAHUB = {
        keyvault = {
          rw                = ["sec-grp1", "sec-grp2"]
          ro                = ["sec-grp1", "sec-grp2"]
          allowed_ip_ranges = ["0.0.0.0", "20.37.110.0/24"]
          allowed_vnets     = [lower("${var.platform}-${var.application}-${var.context}-vnet-${var.zone_loc}-${var.env}"), "vnet2"]
        }

        keyvault1 = {
          rw                = ["sec-grp1", "sec-grp2"]
          ro                = ["sec-grp1", "sec-grp2"]
          allowed_ip_ranges = ["0.0.0.0", "20.37.110.0/24"]
          allowed_vnets     = [lower("${var.platform}-${var.application}-${var.context}-vnet-${var.zone_loc}-${var.env}"), "vnet2"]
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
            #allowed_ip_ranges = ["20.37.110.0/24"]
            #allowed_ip_ranges = ["0.0.0.0", "20.37.110.0/24"]
            allowed_ip_ranges = ["20.39.110.0/24", "20.37.110.0/24"]
            allowed_vnets     = [lower("${var.platform}-${var.application}-${var.context}-vnet-${var.zone_loc}-${var.env}")]
          }
        

        # datahub2 = {
        #     iam = {
        #       #"Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
        #       "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
        #     }
        #     containers = {
        #      landing = {
        #         "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
        #       }
        #       raw = {
        #        # "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
        #         "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
        #       }
        #     }
        #     allowed_ip_ranges = ["20.37.110.0/24"]
        #     #allowed_ip_ranges = ["20.39.110.0/24", "20.37.110.0/24"]
        #     # allowed_ip_ranges = ["0.0.0.0", "20.37.110.0/24"]
        #     allowed_vnets     = [lower("${var.platform}-${var.application}-${var.context}-vnet-${var.zone_loc}-${var.env}")]
        #   }
        }
      }
    }

  }
}

# Resource group details
data "azurerm_resource_group" "resourcegroup" {
  name = lower("${var.platform}-${var.application}-${var.context}-rg-${var.zone_loc}-${var.env}")
}

# DNS zone information from client team, should be with the same resource group
data "azurerm_private_dns_zone" "privatednszone" {
  name                = lower("${var.platform}${var.context}${var.zone_loc}${var.env}.com")
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
}

# DNS A record information from client team, should be with the same resource group
data "azurerm_private_dns_a_record" "privatednsar" {
  name                = "www"
  zone_name           = data.azurerm_private_dns_zone.privatednszone.name
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
  depends_on          = [ 
    data.azurerm_private_dns_zone.privatednszone
   ]
}

# subnet details from client team, should be with the same resource group
data azurerm_subnet "appsnet" {
  name                 = lower("${var.platform}-${var.application}-${var.context}-prvapp-snet-${var.zone_loc}-${var.env}")
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.resourcegroup.name
}

# vnet details from client team, should be with the same resource group
data azurerm_virtual_network "vnet" {
name                = lower("${var.platform}-${var.application}-${var.context}-vnet-${var.zone_loc}-${var.env}")
resource_group_name = data.azurerm_resource_group.resourcegroup.name
   }

# client config i.e. terraform-azure-deployment SP
data "azurerm_client_config" "current" {}

