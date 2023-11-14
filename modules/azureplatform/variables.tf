variable "az_locale" {
  default = "australiaeast"
  type = string
  description = "Azure location"
}

variable "env" {
  default = "dev"
  type = string
  description = "environment"
}

variable "keyvault_deploy" {
  type = bool
  description = "if keyvault to be deployed or not"
}

variable "name" {
  description = "name of the team"
}

variable "akv_ip_rules" {
  type = list(string)
  default = ["0.0.0.0", "20.37.110.0/24"]
  description = "list of IPs to whitelist for access"
}

variable "appsnet" {
  description = "appsnet"
}

variable "resourcegroup" {
  description = "resource_group_name"
}

variable conns {
  description = "connections"
}

variable "privatednszone" {
  description = "private dns zone for kv"
}

variable "keyvault_parameters" {
  description = "keyvault parameters"
}

variable "common_tags" {
  description = "common tags"
}

variable "az_storage_accounts" {
  description = "storage accounts"
}