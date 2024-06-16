variable env {
  type    = string
}

variable "context" {
  type    = string
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


variable az_tenant_id {
  type    = string
}

variable azure_domain {
  type    = map
  default = {}
}

variable resource_group_name {
  type    = map
  default = {}
}


variable keyvault {
  type    = map
  default = {}
}


variable storage_accounts {
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

variable azurerm_private_endpoint {
  type    = map
  default = {}
}

variable "number_of_subnets" {
  type=number
  description="This defines the number of subnets"
  default =2
  validation {
    condition = var.number_of_subnets < 5
    error_message = "The number of subnets must be less than 5."
  }
}



variable "application_security_group_names" {
  description = "application security group names that the network will be created in."
  type        = list(string)
  default     = ["sec-grp1","sec-grp2"]
}

variable "block_name" {
  type  =  map
   default = {}
}