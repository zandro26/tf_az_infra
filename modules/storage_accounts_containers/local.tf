locals { 

#storage_group = distinct(flatten([for rg, rv in var.az_resource_block.DATAHUB.az_storage_accounts : [for ck, cv in rv.containers.raw : [for lk, lv in rv.containers.landing : [for val in cv : "${rg}|${ck}"]]]] ))

storage_acct_roles = distinct(flatten([for rg, rv in var.az_resource_block.DATAHUB.az_storage_accounts : [for ck, cv in rv.iam : "${ck}"]] ))

containers_roles = distinct(flatten([for rg, rv in var.az_resource_block.DATAHUB.az_storage_accounts : [for ck, cv in rv.containers : [for ak, av in cv : "${ak}"]]] ))

containers_list = distinct(flatten([for rg, rv in var.az_resource_block.DATAHUB.az_storage_accounts : [for ck, cv in rv.containers : {name = "${ck}" }]]))

containers_names = distinct(flatten([for rg, rv in var.az_resource_block.DATAHUB.az_storage_accounts : [for ck, cv in rv.containers : "${ck}"]] ))

allowed_ip_ranges_storage_accts = distinct(flatten([for rg, rv in var.az_resource_block.DATAHUB.az_storage_accounts : [for ck, cv in rv.allowed_ip_ranges : "${cv}" ]]))

storage_accts_list = distinct(flatten([for rg, rv in var.az_resource_block.DATAHUB.az_storage_accounts : "${rg}" ]))

storage_accts_containers_group = setproduct(local.storage_accts_list, local.containers_list)

storage_accts_containers_allowed_ip = setproduct(local.storage_accts_list, local.allowed_ip_ranges_storage_accts)

rbac_storage_accts = setproduct(local.storage_accts_list, local.storage_acct_roles)

rbac_storage_containers = setproduct(local.containers_names, local.containers_roles)

}
