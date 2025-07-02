terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "DevBoxBackend-RG"
      storage_account_name = "devboxbackend"
      container_name       = "tfstate"
      key                  = "alz-in-enterprise.tfstate"
  }
#key does not mean the storage account key!! it means the name of the state file
}

provider "azurerm" {
  features {}
}
