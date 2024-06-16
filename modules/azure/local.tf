locals { 
    resource_group_name      = azurerm_resource_group.sxappgrp.name
    location                 = azurerm_resource_group.sxappgrp.location
    virtual_network={
        name=lower("${var.platform}-${var.application}-${var.context}-vnet-${var.zone_loc}-${var.env}")
        address_space="10.0.0.0/16"
     }
team_name =  distinct(flatten([for sg, sv in var.block_name: "${sg}" ]))
}


# data "azurerm_resource_group" "resourcegroup" {
#   #for_each = var.block_name
#   #name = lower("${var.platform}-${var.application}-${var.context}-rg-${var.zone_loc}-${var.env}")
#   name = lower("sx-rg-${var.env}-${local.team_name[0]}")
# }