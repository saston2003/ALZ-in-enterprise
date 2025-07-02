resource "azurerm_firewall_policy" "fwp-south" {
  name                = "fwp-south"
  resource_group_name = var.uksouth_resource_group_name
  location            = var.uksouth_location
  sku                 = "Standard"

  tags = {
    environment = "production"
  }
}

resource "azurerm_firewall_policy" "fwp-west" {
  name                = "fwp-west"
  resource_group_name = var.uksouth_resource_group_name
  location            = var.uksouth_location
  sku                 = "Standard"

  tags = {
    environment = "production"
  }
}