resource "azurerm_resource_group" "sxappgrp" {
  #name     =  lower("${var.platform}-${var.application}-${var.context}-rg-${var.zone_loc}-${var.env}")
  name     = lower("sx-rgrp-${var.env}-${local.team_name[0]}")
  location = "Australia East"

 tags = {
 environment = lower("${var.env}")
  }
}


resource "azurerm_virtual_network" "appnetwork1" {
  for_each = var.azure_domain
  name                = "sx-cap-vnet1"
  location            = local.location
  resource_group_name = local.resource_group_name
  #address_space       = [local.virtual_network.address_space]  
  address_space       = [each.value.az_storage_accounts.datahub.allowed_ip_ranges[0],each.value.az_storage_accounts.datahub.allowed_ip_ranges[1]]
   depends_on = [
     azurerm_resource_group.sxappgrp
   ]

 tags = {
 environment = lower("${var.env}")
  }
  }
resource "azurerm_virtual_network" "appnetwork2" {
  for_each = var.azure_domain
  name                = "sx-cap-vnet2"
  location            = local.location
  resource_group_name = local.resource_group_name
  #address_space       = [local.virtual_network.address_space]  
  address_space       = [each.value.az_storage_accounts.datahub.allowed_ip_ranges[0],each.value.az_storage_accounts.datahub.allowed_ip_ranges[1]]
   depends_on = [
     azurerm_resource_group.sxappgrp
   ]

 tags = {
 environment = lower("${var.env}")
  }
  }


  resource "azurerm_subnet" "subnets" {
  for_each = var.azure_domain
  name                 = lower("prvapp-snet-${var.zone_loc}-${var.env}")
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.appnetwork1[each.key].name
  address_prefixes     = ["10.0.1.0/24"]
  #address_prefixes     = [each.value.az_storage_accounts.datahub.allowed_ip_ranges[0],each.value.az_storage_accounts.datahub.allowed_ip_ranges[1]]
  service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault" ]
 
  depends_on = [
    azurerm_virtual_network.appnetwork1
  ]
}

resource "azurerm_network_security_group" "appnsg" {
  name                = lower("prvapp-snet-nsg-${var.zone_loc}-${var.env}")
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [
    azurerm_resource_group.sxappgrp
  ]
}

resource "azurerm_subnet_network_security_group_association" "appnsglink" {
  #count=var.number_of_subnets
  for_each = var.azure_domain
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.appnsg.id
  depends_on = [
    azurerm_virtual_network.appnetwork1,
    azurerm_subnet.subnets,
    azurerm_network_security_group.appnsg
  ]

}
 
# resource "azurerm_application_security_group" "secgrpnames" {
#   count = length(var.application_security_group_names)
#   name = var.application_security_group_names[count.index]
#   location = local.location
#   resource_group_name = local.resource_group_name

# }

# output "subnet_id" {
#   value = azurerm_subnet.subnets.id
# }


resource "azurerm_private_dns_zone" "privatednszone" {
  name                = lower("${var.platform}${var.zone_loc}${var.env}${local.team_name[0]}.com")
  resource_group_name = local.resource_group_name
}

resource "azurerm_private_dns_a_record" "privatednsar" {
  for_each = var.azure_domain
  name                = "www"
  zone_name           = azurerm_private_dns_zone.privatednszone.name
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = ["10.0.1.1"]
}
