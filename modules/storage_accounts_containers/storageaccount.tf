# creating unique storage accounts for each occurence of resource block in the config file
resource azurerm_storage_account storage_account {
  for_each = local.storage_account_and_resource_tags
  #name                     = lower("sa${each.key}${var.env}${local.app_team_name[0]}")
  name                     = lower("sa${trim(each.key, "datahub")}${var.env}${local.app_team_name[0]}") 
  location                 = var.az_locale
  resource_group_name      = data.azurerm_resource_group.resourcegroup.name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

 tags = merge(local.root_tags ,each.value)            
}