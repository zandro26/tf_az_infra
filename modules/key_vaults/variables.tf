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

variable resource_group_name {
  type    = map
  default = {}
}

variable datahub {
  type    = map
  default = {}
}

variable keyvault {
  type    = map
  default = {}
}


variable azurerm_storage_account {
  #type    = map
    type = map(object({
    name = string
    # Other attributes
  }))
  default = {}
}


variable az_storage_accounts {
  type    = map
  default = {}
}

variable containers {
  type    = map
  default = {}
}

variable container_access_type {
  type    = map
  default = {}
}

variable azurerm_virtual_network {
  type    = map
  default = {}
}

variable azurerm_subnet {
  type    = map
  default = {}
}

variable azurerm_network_security_group {
  type    = map
  default = {}
}

variable azurerm_private_endpoint {
  type    = map
  default = {}
}

variable azurerm_storage_container {
  type    = map
  default = {}
}

variable az_subnet {
  type    = map
  default = {}
}

variable net_sec_grp {
  type    = map
  default = {}
}

variable privatednszone_id {
  type    = string
}

variable az_client_config_object_id {
  type    = string
}

# variable az_app_subnet_id {
#   type    = string
# }

variable "user_group_map" {
  type    = map(string)
  default = {
    "group1" = "sec-grp1",
    "group2" = "sec-grp2",
  }
}

variable "conns" {
  type    = map
}
