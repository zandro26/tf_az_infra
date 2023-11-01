locals { 
    resource_group_name      = var.az_resource_block.DATAHUB.resourcegroup.name
    location                 = var.az_resource_block.DATAHUB.resourcegroup.location

  
 keyvault_allowed_ip = flatten(
    [
      [for name, val in var.az_resource_block :
        [for r in val.keyvault.allowed_ip_ranges :
          "${name}_IP_LIMIT_${var.env}|${r}"
        ]
      ]
    ]
  )

  selected_user_group = "group1"
  user_group_id       = lookup(var.user_group_map, local.selected_user_group, null)


 }
# subnet details from client team, should be with the same resource group
data azurerm_subnet "appsnet" {
for_each = var.az_resource_block
   name= each.value.az_subnet.name
   virtual_network_name = each.value.virtualnetwork.name
   resource_group_name=local.resource_group_name
   }

# vnet details from client team, should be with the same resource group
data azurerm_virtual_network "vnet" {
for_each = var.az_resource_block
   name = each.value.virtualnetwork.name
   resource_group_name=local.resource_group_name
   }


# nsg details from client team, should be with the same resource group
data azurerm_network_security_group "appnsg" {
for_each = var.az_resource_block
   name= each.value.net_sec_grp.name
   resource_group_name=local.resource_group_name
   }


