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

variable az_storage_accounts {
  type    = map
  default = {}
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


# variable "containers_list" {
#   type = list
#   default = [{ name = "landing", access_type = "blob" }, {name = "raw", access_type = "blob" }]
#  }
 
#  variable "Storage_list" {
#   type = list
#   default = ["sec-grp1", "sec-grp2"]
#  }

#  variable "rbac_role" {
#   type = list
#   default = ["Storage Blob Data Contributor", "Storage Blob Data Reader"]
#  }