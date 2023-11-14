env_dev = {
    datahub = {
        keyvault_deploy = true
        keyvault_parameters = {
          rbac = {
            "Key Vault Administrator" = ["sec-grp1", "sec-grp2"]
            "Key Vault Secrets User"  = ["sec-grp2"]
          }
        }

        storage_account_deploy = true
        storage_accounts = {
          sa1 = {
            account_parameters = {
              rbac = {

              }
              containers = {
                context1 = {
                  rbac = {

                  }
                }
              }
            }
          }
          sa2 = {
            account_parameters = {
              rbac = {

              }
              containers = {
                context1 = {
                  rbac = {

                  }
                }
              }
            }
          }
        }
    }          
}