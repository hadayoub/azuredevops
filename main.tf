provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "ressourcegroupe" {
  name     = var.resourcename
  location = var.location
  tags = var.tags
}


resource "azurerm_storage_account" "storagename" {
  name                     = var.storagename
  resource_group_name      = azurerm_resource_group.ressourcegroupe.name
  location                 = azurerm_resource_group.ressourcegroupe.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tags
}

resource "azurerm_storage_container" "storagecontainer" {
  count = 4
  name                  = "${var.storage_container_name}${count.index}"
  storage_account_name  = azurerm_storage_account.storagename.name
  container_access_type = "private"
}

resource "azurerm_dns_zone" "mydnszone" {
  count = length(var.mydnsname)
  name                = var.mydnsname[count.index]
  resource_group_name = azurerm_resource_group.ressourcegroupe.name
}

resource "azurerm_network_security_group" "mysg" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.ressourcegroupe.location
  resource_group_name = azurerm_resource_group.ressourcegroupe.name

  dynamic "security_rule"{
  iterator = rule
  for_each = var.security_rule
  content {
    name                       = rule.value.name
    priority                   = rule.value.priority
    direction                  = rule.value.direction
    access                     = rule.value.access
    protocol                   = rule.value.protocol
    source_port_range          = rule.value.source_port_range
    destination_port_range     = rule.value.destination_port_range
    source_address_prefix      = rule.value.source_address_prefix
    destination_address_prefix = rule.value.destination_address_prefix
  }
}
}



resource "azurerm_cosmosdb_account" "db" {
  count = var.enviornment == "prod" ? 2 : 1
  name                = "tf-cosmos-db"
  location            = azurerm_resource_group.ressourcegroupe.location
  resource_group_name = azurerm_resource_group.ressourcegroupe.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = true

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities { 
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = azurerm_resource_group.ressourcegroupe.location
    failover_priority = 0
  }
}