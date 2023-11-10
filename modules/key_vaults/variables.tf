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



variable az_locale {
  type    = string
}

variable "conns" {
  type    = map
}

variable "block_name" {
  type  =  map
   default = {}
}

variable "az_rg_naming_convention" {
  type = string
  default = "sx-rg"
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



