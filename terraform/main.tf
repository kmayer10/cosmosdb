provider "azurerm" {
    features {}
}

variable "location" {
  default = "eastus"
}
variable "name" {
  default = "thinknyx"
}
variable "throughput" {
  type        = number
  description = "Cosmos db database throughput"
  validation {
    condition     = var.throughput >= 400 && var.throughput <= 1000000
    error_message = "Cosmos db manual throughput should be equal to or greater than 400 and less than or equal to 1000000."
  }
  validation {
    condition     = var.throughput % 100 == 0
    error_message = "Cosmos db throughput should be in increments of 100."
  }
}

resource "azurerm_resource_group" "thinknyx" {
  location = var.location
  name = var.name
  tags = {
    Name = "Kul"
    Day = "5"
  }
}
resource "azurerm_cosmosdb_account" "GlobalDocumentDB" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = azurerm_resource_group.thinknyx.name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  enable_automatic_failover = false
  geo_location {
    location          = var.location
    failover_priority = 0
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
}

resource "azurerm_cosmosdb_sql_database" "thinknyx" {
  name                = var.name
  resource_group_name = azurerm_resource_group.thinknyx.name
  account_name        = azurerm_cosmosdb_account.example.name
  throughput          = var.throughput
}
