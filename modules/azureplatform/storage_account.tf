locals {
  az_storage_account = {
        for storage_account_key, storage_account in var.az_storage_accounts : storage_account_key => {
            resource_tag = storage_account.resource_tag
            allowed_ip_ranges = storage_account.allowed_ip_ranges
            iam = storage_account.iam
            storage_account_key = storage_account_key
        }
    }
}

#creating unique storage accounts for each occurence of resource block in the config file
resource azurerm_storage_account storage_account {
  for_each = {
    for k, v in local.az_storage_account : k => v
  }

  name                     = "${each.key}${var.env}"
  #name                     = lower("sa${trim(each.key, "datahub")}${var.env}${local.app_team_name[0]}") 
  location                 = var.az_locale
  resource_group_name      = var.resourcegroup
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = merge(var.common_tags, each.value.resource_tag)  
           
}

#flatten to get containers/iam
locals {
    containers = flatten([
        for storage_account_key, storage_containers in var.az_storage_accounts : [
            for container_key, container in storage_containers.containers : {
                storage_account_key = storage_account_key
                container_key = container_key
            }
        ]
    ])
}

# creating unique storage containers for each occurence of unique storage accounts
resource "azurerm_storage_container" "example" {
  for_each = {
    for container in local.containers : "${container.storage_account_key}-${container.container_key}" => container
  }

  name                  = each.value.container_key
  storage_account_name  = azurerm_storage_account.storage_account[each.value.storage_account_key].name
  container_access_type = "blob"
  depends_on = [
      azurerm_storage_account.storage_account
  ]
}







