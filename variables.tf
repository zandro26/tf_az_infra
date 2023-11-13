variable "env" {
  type = string
}

variable "context" {
  type = string
}

variable "conns" {
  type = map(any)
}

variable "application" {
  type = string
}

variable "zone_loc" {
  type = string
}

variable "platform" {
  type = string
}

variable "az_client_secret" {
  type      = string
  sensitive = true
}

variable "az_zone_locale" {
  type = string
}


//data lookups
data "azurerm_resource_group" "resourcegroup" {
  name = lower("sx-rg-${var.env}-teams")
}

# DNS zone information from client team, should be with the same resource group
data "azurerm_private_dns_zone" "privatednszone" {
  name                = lower("${var.platform}${var.zone_loc}${var.env}teams.com")
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
}

# DNS A record information from client team, should be with the same resource group
data "azurerm_private_dns_a_record" "privatednsar" {
  name                = "www"
  zone_name           = data.azurerm_private_dns_zone.privatednszone.name
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
  depends_on = [
    data.azurerm_private_dns_zone.privatednszone
  ]
}

# subnet details from client team, should be with the same resource group
data "azurerm_subnet" "appsnet" {
  name                 = lower("prvapp-snet-${var.zone_loc}-${var.env}")
  virtual_network_name = data.azurerm_virtual_network.vnet1.name
  resource_group_name  = data.azurerm_resource_group.resourcegroup.name
}

# vnet details from client team, should be with the same resource group
data "azurerm_virtual_network" "vnet1" {
  name                = "sx-cap-vnet1"
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
}

data "azurerm_virtual_network" "vnet2" {
  name                = "sx-cap-vnet2"
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
}

variable "env_dev" {
  // will add the type here once config file is finalised
  description = "map of the config file"
}
