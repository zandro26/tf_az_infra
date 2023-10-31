
# linking keyvault to PE
resource "azurerm_private_endpoint" "private_endpoint2" {
  for_each = var.azure_domain
  name                       = "prvendpt-${azurerm_key_vault.keyvault[each.key].name}"
  #name                       = "prvendpt-${each.value.keyvault.name}"
  location                   = local.location
  resource_group_name        = local.resource_group_name
  subnet_id                  = data.azurerm_subnet.appsnet[each.key].id
  private_service_connection {
    name                           = each.value.private_service_con.name
    private_connection_resource_id = azurerm_key_vault.keyvault[each.key].id
    #private_connection_resource_id = each.value.keyvault.name.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
    depends_on = [
       azurerm_key_vault.keyvault
    ]
    private_dns_zone_group {
    name                 = lower("${var.platform}-${var.context}-dns-grp-${var.zone_loc}-${var.env}")
    #private_dns_zone_ids = [data.azurerm_private_dns_zone.privatednszone.id]
    private_dns_zone_ids = [var.privatednszone_id]
  }
}

