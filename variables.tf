variable "env" {
  type    = string
}

variable "context" {
  type    = string
}

variable "conns" {
  type    = map
}

variable "application" {
  type    = string
}

variable "zone_loc" {
  type    = string
}

variable "platform" {
  type    = string
}

variable "az_client_secret" {
  type    = string
  sensitive = true
}

variable "az_zone_locale" {
  type    = string
}


# variable "containers_list" {
#   type = list
#   default = [{ name = "landing", access_type = "blob" }, {name = "raw", access_type = "blob" }]
#  }

#  variable "Storage_list" {
#   type = list
#   default = ["datahub1", "datahub2"]
#  }

#  variable "rbac_roles" {
#    type = list
#   default = ["Storage Blob Data Contributor", "Storage Blob Data Reader"]
#  }
