locals {
  SB = {

    # az_rg_naming_convention = "sx-rg-[env]-[domain]"
    # az_sa_naming_convention = "xsffgsa-[env]-[domain]"
    # az_kv_naming_convention = "kv[env][domain]"
    # az_pe_naming_convention = "pe[env][domain]"
 

    teams = {
      DATAHUB = {
        # resourcegroup ={
        #   name = lower("${var.platform}-${var.application}-${var.context}-rg-${var.zone_loc}-${var.env}")
        #   location = "Australia East"
        # }
        keyvault = {
          rw                = ["sec-grp1", "sec-grp2"]
          ro                = ["sec-grp1", "sec-grp2"]
          allowed_ip_ranges = ["0.0.0.0", "20.37.110.0/24"]
          allowed_vnets     = [lower("${var.platform}-${var.application}-${var.context}-vnet-${var.zone_loc}-${var.env}")]
        }
        az_storage_accounts = { ##Ensure to use Gen2 https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_data_lake_gen2_filesystem
          # soft_delete_retention_days = 14 -- make it as default value for the module
          datahub = {
            iam = {
              "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
            }
            containers = {
             landing = {
                "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
                "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
              }
              raw = {
                "Storage Blob Data Contributor" = ["sec-grp1", "sec-grp2"]
                "Storage Blob Data Reader"      = ["sec-grp1", "sec-grp2"]
              }
            }
            allowed_ip_ranges = ["0.0.0.0", "20.37.110.0/24"]
            allowed_vnets     = [lower("${var.platform}-${var.application}-${var.context}-vnet-${var.zone_loc}-${var.env}")]
          }
        }

        virtualnetwork        = {
            name              = lower("${var.platform}-${var.application}-${var.context}-vnet-${var.zone_loc}-${var.env}")
             }
         az_subnet            = {
             name             = lower("${var.platform}-${var.application}-${var.context}-prvapp-snet-${var.zone_loc}-${var.env}")
             }
          net_sec_grp         = {
              name            = lower("${var.platform}-${var.application}-${var.context}-prvapp-snet-nsg-${var.zone_loc}-${var.env}")
              }
          private_endpoint    = {
             name             = lower("${var.platform}-${var.context}-prvendpt-${var.zone_loc}-${var.env}")
              }
          private_service_con = {
             name             = lower("${var.platform}-${var.context}-prvendpt-srv-conn-${var.zone_loc}-${var.env}")
              }
      }
    }

  }
}

# # subnet details from client team, should be with the same resource group
# data azurerm_subnet "app_subnet" {
# #for_each = var.az_resource_block
#    name= lower("${var.platform}-${var.application}-${var.context}-prvapp-snet-${var.zone_loc}-${var.env}")
#    #virtual_network_name = lower("${var.platform}-${var.application}-${var.context}-vnet-${var.zone_loc}-${var.env}")
#    virtual_network_name = local.SB.teams.DATAHUB.virtualnetwork.name
#    #resource_group_name = lower("${var.platform}-${var.application}-${var.context}-rg-${var.zone_loc}-${var.env}")
#    resource_group_name = local.SB.teams.DATAHUB.resourcegroup.name
# }

# Resource group details
data "azurerm_resource_group" "resourcegroup" {
  name = lower("${var.platform}-${var.application}-${var.context}-rg-${var.zone_loc}-${var.env}")
}
# DNS zone information from client team, should be with the same resource group
data "azurerm_private_dns_zone" "privatednszone" {
  name                = lower("${var.platform}${var.context}${var.zone_loc}${var.env}.com")
  #name                = "zschealthsocietyaesb.com"
  #resource_group_name = lower("${var.platform}-${var.application}-${var.context}-rg-${var.zone_loc}-${var.env}")
  #resource_group_name = local.SB.teams.DATAHUB.resourcegroup.name
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
}

# DNS A record information from client team, should be with the same resource group
data "azurerm_private_dns_a_record" "privatednsar" {
  name                = "www"
  zone_name           = data.azurerm_private_dns_zone.privatednszone.name
  #resource_group_name = lower("${var.platform}-${var.application}-${var.context}-rg-${var.zone_loc}-${var.env}")
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
  depends_on = [ 
    data.azurerm_private_dns_zone.privatednszone
   ]
}

# client config i.e. terraform-azure-deployment SP
data "azurerm_client_config" "current" {}

