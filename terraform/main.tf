provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "thinknyx" {
  location = "eastus"
  name = "thinknyx"
  tags = {
    Name = "Kul"
    Day = "5"
  }
}
