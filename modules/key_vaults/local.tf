locals { 

keyvault_rw = flatten([[for name, val in var.az_resource_block : [for r in val.keyvault.rw : "${r}" ]]])

keyvault_rw_groupname = flatten([[for name, val in var.az_resource_block : [for r in val.keyvault.rw : "${r}" ]]])

keyvault_ro = flatten([[for name, val in var.az_resource_block : [for r in val.keyvault.ro :  "ro|${r}" ]]])

 }

data "azuread_group" "ad_group1" {
 #for_each = toset(local.keyvault_rw_groupname)
  display_name     = "sec-grp1"
  #display_name = each.value
}


# data "azuread_group" "ad_group1_rw" {
#  for_each = toset(local.keyvault_rw)
#   display_name = "${each.value[0]}"
# }

data "azuread_group" "ad_group1_rw" {
  display_name = "${local.keyvault_rw[0]}"
}


data "azuread_group" "ad_group2_rw" {
  display_name = "${local.keyvault_rw[1]}"
}

data "azuread_group" "ad_group2" {
  display_name     = "sec-grp2"
}