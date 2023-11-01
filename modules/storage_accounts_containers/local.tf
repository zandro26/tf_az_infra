locals { 

    containers = flatten(
        [for rg, rv in var.az_resource_block : 
         [
          for ck, cv in rv.az_storage_accounts.datahub.containers : 
         "${ck}|${rg}"
         ]
        ]
 )

 #landing = distinct(flatten([for rg, rv in var.az_resource_block : [for ck, cv in rv.az_storage_accounts.datahub.containers.landing : [for lk, lv in rv.az_storage_accounts.datahub.containers.landing : "${ck}|${rg}"  ]]] ))


#  sample(rm_grants) = distinct(flatten(
#     [
#       [for name, val in var.az_resource_block :
#         [for r in val.keyvault.allowed_ip_ranges :
#           "${name}_IP_LIMIT_${var.env}|${r}"
#         ]
#       ],
#       [for name, val in var.az_resource_block :
#         [for r in val.keyvault.rw :
#           "${name}_GRP_LIMIT_${var.env}|${r}"
#         ]
#       ]
#     ]
#   ))

  
 keyvault_allowed_ip = flatten(
    [
      [for name, val in var.az_resource_block :
        [for r in val.keyvault.allowed_ip_ranges :
          "${name}_IP_LIMIT_${var.env}|${r}"
        ]
      ]
    ]
  )
 }


# subnet details from client team, should be with the same resource group
data azurerm_subnet "appsnet" {
for_each = var.az_resource_block
   name= each.value.az_subnet.name
   virtual_network_name = each.value.virtualnetwork.name
   resource_group_name=var.az_resource_group_name
   }

# vnet details from client team, should be with the same resource group
data azurerm_virtual_network "vnet" {
for_each = var.az_resource_block
   name = each.value.virtualnetwork.name
   resource_group_name=var.az_resource_group_name
   }


# nsg details from client team, should be with the same resource group
data azurerm_network_security_group "appnsg" {
for_each = var.az_resource_block
   name= each.value.net_sec_grp.name
   resource_group_name=var.az_resource_group_name
   }

