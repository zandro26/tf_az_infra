terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "~>0.70.0"
    }
    snowsql = {
      source = "aidanmelen/snowsql"
      version = "~>1.3.3"
    }
    dbtcloud = {
      source  = "dbt-labs/dbtcloud"
      version = "~>0.2.6"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.71.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.34.0"
    }    
  }
  required_version = "~>1.5.6"   
}

provider "snowsql" {
  username = var.conns.sf_username
  account  = var.conns.sf_account
  region   = var.conns.sf_region
  private_key = var.sf_private_key
  private_key_passphrase = var.sf_private_key_passphrase 
  role = var.conns.sf_role
}

provider "snowsql" {
  alias = "with_wh"
  warehouse = "ADMIN_WH"
  username = var.conns.sf_username
  account  = var.conns.sf_account
  region   = var.conns.sf_region
  private_key = var.sf_private_key
  private_key_passphrase = var.sf_private_key_passphrase 
  role = var.conns.sf_role
}


provider "snowflake" {
  username = var.conns.sf_username
  account  = var.conns.sf_account
  region   = var.conns.sf_region
  private_key = var.sf_private_key
  private_key_passphrase = var.sf_private_key_passphrase 
  role = var.conns.sf_role
}

provider "dbtcloud" {
  account_id = var.conns.dbt_account_id
  token      = var.dbt_token
  host_url   = var.conns.dbt_host_url
}

provider "github" {
  owner=var.conns.github_owner
  app_auth {
    
    id              = var.conns.github_id
    installation_id = var.conns.github_installation_id
    pem_file        = var.github_pem_file
  }
}

provider "azurerm" {
  features {}
  client_id       = var.conns.az_client_id
  client_secret   = var.az_client_secret
  tenant_id       = var.conns.az_tenant_id
  subscription_id = var.conns.az_subscription_id
}