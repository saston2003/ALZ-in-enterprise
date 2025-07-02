resource "azurerm_firewall_policy" "fwp-south" {
  name                = "M-hub-uksouth-fwp"
  resource_group_name = var.uksouth_resource_group_name
  location            = var.uksouth_location
  sku                 = "Standard"

  tags = {
    environment = "production"
  }
}

resource "azurerm_firewall_policy" "fwp-west" {
  name                = "M-hub-ukwest-fwp"
  resource_group_name = var.ukwest_resource_group_name
  location            = var.ukwest_location
  sku                 = "Standard"

  tags = {
    environment = "production"
  }
}