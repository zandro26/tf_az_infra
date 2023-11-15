locals {
    #loop for storage account
    az_storage_account = {
        for storage_account_key, storage_account in var.az_storage_accounts : storage_account_key => {
            resource_tag = storage_account.resource_tag
            allowed_ip_ranges = storage_account.allowed_ip_ranges
            iam = storage_account.iam
            storage_account_key = storage_account_key
            containers = storage_account.containers
            
        }
    }

    #loop for container //need to check if we can use above loop for containers
    containers = flatten([
        for storage_account_key, storage_containers in var.az_storage_accounts : [
            for container_key, container in storage_containers.containers : {
                storage_account_key = storage_account_key
                container_key = container_key
                iam           = container.iam
            }
        ]
    ])

    #flatten for storage account iam to get role/member
    storage_account_roles = can(local.az_storage_account) ? flatten([
        for storage_account in local.az_storage_account : [
        for role, members in storage_account.iam : [
            for member in members : {
            storage_account_key = storage_account.storage_account_key
            role                = role
            member              = member
            }
        ]
        ]
    ]) : []

    #flatten for container rbac 
    storage_account_container_roles = can(local.containers) ? flatten([
        for container in local.containers : [
        for role, members in container.iam : [
            for member in members : {
            storage_account_key = container.storage_account_key
            container_key       = container.container_key
            role                = role
            member              = member
            }
        ]
        ]
    ]) : []

    #flatten for keyvault members
    kv_roles = var.keyvault_deploy && can(var.keyvault_parameters.rbac) ? flatten([
        for role, members in var.keyvault_parameters.rbac : [
            for member in members : {
                role = role
                member = member
            }
        ]
    ]) : []

    akv_iprules = [
        "0.0.0.0", 
        "20.37.110.0/24"
    ]
}