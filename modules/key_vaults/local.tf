locals { 

app_team_name =  distinct(flatten([for sg, sv in var.block_name: "${sg}" ]))

root_tags = "${var.az_resource_block.DATAHUB.common_tags}"

keyvault_rw = flatten([[for name, val in var.az_resource_block : [for r in val.keyvault.rw : "${r}" ]]])

}


data "azuread_group" "ad_group1_rw" {
  display_name = "${local.keyvault_rw[0]}"
}


data "azuread_group" "ad_group2_rw" {
  display_name = "${local.keyvault_rw[1]}"
}


data "azurerm_resource_group" "resourcegroup" {
  name = lower("sx-rg-${var.env}-${local.app_team_name[0]}")
}

# DNS zone information from client team, should be with the same resource group
data "azurerm_private_dns_zone" "privatednszone" {
  name                = lower("${var.platform}${var.zone_loc}${var.env}${local.app_team_name[0]}.com")
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
  name                 = lower("prvapp-snet-${var.zone_loc}-${var.env}")
  virtual_network_name = data.azurerm_virtual_network.vnet1.name
  resource_group_name  = data.azurerm_resource_group.resourcegroup.name
}

# vnet details from client team, should be with the same resource group
data azurerm_virtual_network "vnet1" {
name                = "sx-cap-vnet1"
resource_group_name = data.azurerm_resource_group.resourcegroup.name
   }

data azurerm_virtual_network "vnet2" {
name                = "sx-cap-vnet2"
resource_group_name = data.azurerm_resource_group.resourcegroup.name
   }


# client config i.e. terraform-azure-deployment SP
data "azurerm_client_config" "current" {}

