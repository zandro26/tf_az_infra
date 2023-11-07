locals { 

#storage_group = distinct(flatten([for rg, rv in var.az_resource_block.DATAHUB.az_storage_accounts : [for ck, cv in rv.containers.raw : [for lk, lv in rv.containers.landing : [for val in cv : "${rg}|${ck}"]]]] ))

storage_acct_roles = distinct(flatten([for sg, sv in var.az_resource_block.DATAHUB.az_storage_accounts : [for rn, rv in sv.iam : "${rn}"]] ))

container_roles = distinct(flatten([for sg, sv in var.az_resource_block.DATAHUB.az_storage_accounts : [for rn, rv in sv.containers : [for ak, av in rv : "${ak}"]]] ))

container_list = distinct(flatten([for sg, sv in var.az_resource_block.DATAHUB.az_storage_accounts : [for rn, rv in sv.containers : {name = "${rn}" }]]))

container_names = distinct(flatten([for sg, sv in var.az_resource_block.DATAHUB.az_storage_accounts : [for rn, rv in sv.containers : "${rn}"]] ))

allowed_ip_ranges_storage_accts = distinct(flatten([for sg, sv in var.az_resource_block.DATAHUB.az_storage_accounts : [for rn, rv in sv.allowed_ip_ranges : "${rv}" ]]))

storage_accts_list = distinct(flatten([for sg, sv in var.az_resource_block.DATAHUB.az_storage_accounts : "${sg}" ]))

storage_accts_containers_group = setproduct(local.storage_accts_list, local.container_list)

storage_accts_containers_allowed_ip = setproduct(local.storage_accts_list, local.allowed_ip_ranges_storage_accts)

rbac_storage_accts = setproduct(local.storage_accts_list, local.storage_acct_roles)

rbac_storage_containers = setproduct(local.container_names, local.container_roles)

iam_group = distinct(flatten([[for name, val in var.az_resource_block.DATAHUB.az_storage_accounts: [for r in val.iam : "${r}" ]]]))
}


data "azuread_group" "iam_group1" {
  display_name = "${local.iam_group[0]}"
}


data "azuread_group" "iam_group2" {
  display_name = "${local.iam_group[1]}"
}