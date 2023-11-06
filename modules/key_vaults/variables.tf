variable env {
  type    = string
}

variable context {
  type    = string
}
variable platform {
  type    = string
}

variable application {
  type    = string
}

variable zone_loc {
  type    = string
}


variable az_resource_block {
  type    = map
  default = {}
}

variable az_resource_group_name {
  type    = string
}

variable az_subnet_id {
    type = string
}

variable privatednszone_id {
  type    = string
}

variable az_client_config_object_id {
  type    = string
}

variable az_locale {
  type    = string
}

variable "conns" {
  type    = map
}

variable "keyvault_rbac" {
  type = list
  default = [{ rbac_name = "rw", groupname = "sec-grp1" },  {rbac_name = "rw", groupname = "sec-grp2" }, {rbac_name = "ro", groupname = "sec-grp1" }, {rbac_name = "ro", groupname = "sec-grp2" }]
 }

variable keyvault_rw_secret_permissions {
  type = list
  default = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Backup",
    "Restore",
  ]
}

variable keyvault_rw_key_permissions {
  type = list
  default = [
    "Get",
    "List",
    "Create",
    "Delete",
    "Update",
    "Import",
    "Backup",
    "Restore",
  ]
}

variable keyvault_rw_cert_permissions {
  type = list
  default = [
    "Get",
    "List",
    "Delete",
    "Backup",
    "Restore",
  ]
}

variable keyvault_ro_secret_permissions {
  type = list
  default = [
    "Get",
    "List",
  ]
}

variable keyvault_ro_key_permissions {
  type = list
  default = [
    "Get",
    "List",
  ]
}

variable keyvault_ro_cert_permissions {
  type = list
  default = [
    "Get",
    "List",
  ]
}



