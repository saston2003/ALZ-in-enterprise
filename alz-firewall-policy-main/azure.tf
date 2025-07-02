terraform {
  backend "azurerm" {
    resource_group_name  = "rg-alz-mgmt-state-uksouth-001"
    storage_account_name = "stoalzmgmuks001mgbm"
    container_name       = "mgmt-tfstate"
    key                  = "fwpolicy.tfstate"
    use_azuread_auth     = true
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    random = {
      source  = "hashicorp/random"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "f2332963-f81e-4c39-953c-c04510584ba2"
}
