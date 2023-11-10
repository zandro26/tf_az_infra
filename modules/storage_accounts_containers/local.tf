locals { 

container_roles = distinct(flatten([for sg, sv in var.az_resource_block.DATAHUB.az_storage_accounts : [for rn, rv in sv.containers : [for ak, av in rv : "${ak}"]]] ))

container_names = distinct(flatten([for sg, sv in var.az_resource_block.DATAHUB.az_storage_accounts : [for rn, rv in sv.containers : "${rn}"]] ))

allowed_ip_ranges_storage_accts = distinct(flatten([for sg, sv in var.az_resource_block.DATAHUB.az_storage_accounts : [for rn, rv in sv.allowed_ip_ranges : "${rv}" ]]))

allowed_vnets_storage_accts = distinct(flatten([for sg, sv in var.az_resource_block.DATAHUB.az_storage_accounts : [for rn, rv in sv.allowed_vnets : "${rv}" ]]))

storage_accts_list = distinct(flatten([for sg, sv in var.az_resource_block.DATAHUB.az_storage_accounts : "${sg}" ]))

rbac_storage_containers = setproduct(local.container_names, local.container_roles)

iam_group = distinct(flatten([[for name, val in var.az_resource_block.DATAHUB.az_storage_accounts: [for r in val.iam : "${r}" ]]]))

app_team_name = distinct(flatten([for sg, sv in var.block_name: "${sg}" ]))

storage_account_rbac_definition = {for val in flatten([for sn, sv in var.az_resource_block.DATAHUB.az_storage_accounts : [for iamk, iamv in sv.iam : {storage_account = "${sn}|${iamk}", iam = iamk, config = iamv}]]) : val.storage_account => val}

storage_containers_list = {for val in flatten([for sn, sv in var.az_resource_block.DATAHUB.az_storage_accounts : [for ck, cv in sv.containers : {storage_container = "${sn}|${ck}"}]]) : val.storage_container => val}

storage_account_and_resource_tags = {for sn, sv in var.az_resource_block.DATAHUB.az_storage_accounts : sn => sv.resource_tag}

storage_account_and_allowed_ips = {for sn, sv in var.az_resource_block.DATAHUB.az_storage_accounts : sn => sv.allowed_ip_ranges}
root_tags = "${var.az_resource_block.DATAHUB.common_tags}"

}


data "azuread_group" "iam_group1" {
  display_name = "${local.iam_group[0]}"
}


data "azuread_group" "iam_group2" {
  display_name = "${local.iam_group[1]}"
}

data azurerm_virtual_network "vnet1" {
#   for_each = var.block_name
name                = "sx-cap-vnet1"
resource_group_name = data.azurerm_resource_group.resourcegroup.name
   }

data azurerm_virtual_network "vnet2" {
 #  for_each = var.block_name
name                = "sx-cap-vnet2"
resource_group_name = data.azurerm_resource_group.resourcegroup.name
   }

data "azurerm_resource_group" "resourcegroup" {
  #for_each = var.block_name
  #name = lower("${var.platform}-${var.application}-${var.context}-rg-${var.zone_loc}-${var.env}")
  name = lower("sx-rg-${var.env}-${local.app_team_name[0]}")
}

 # subnet details from client team, should be with the same resource group
data azurerm_subnet "appsnet" {
  name                 = lower("prvapp-snet-${var.zone_loc}-${var.env}")
  virtual_network_name = data.azurerm_virtual_network.vnet1.name
  resource_group_name  = data.azurerm_resource_group.resourcegroup.name
}

# DNS zone information from client team, should be with the same resource group
data "azurerm_private_dns_zone" "privatednszone" {
  #name                = lower("${var.platform}${var.context}${var.zone_loc}${var.env}.com")
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


# client config i.e. terraform-azure-deployment SP
data "azurerm_client_config" "current" {}

