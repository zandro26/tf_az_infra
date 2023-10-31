terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.71.0"
    }

      azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.15.0"
    }
   
   
  }
  required_version = "~>1.5.6"   
}




provider "azurerm" {
  features {}
  client_id       = var.conns.az_client_id
  client_secret   = var.az_client_secret
  tenant_id       = var.conns.az_tenant_id
  subscription_id = var.conns.az_subscription_id
}

provider "azuread" {
  #features {}
  client_id       = var.conns.az_client_id
  client_secret   = var.az_client_secret
  tenant_id       = var.conns.az_tenant_id
}