terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  backend "azurerm" {
      resource_group_name  = "my-complete-project"
      storage_account_name =  "saveterraformfilesttf"
      container_name       = "stterraform"
      key                  = "stterraform"
  }

}

provider "azurerm" {
  features {}
}

resource "azurerm_storage_account" "tffile_storage_account" {
  name                     = "ahgvhgwefdsdaa"
  resource_group_name      = azurerm_resource_group.resource_group_name.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_container_registry" "conatiner_registry_images" {
  name                = var.conatiner_registry_crudoperation
  resource_group_name      =  var.resource_group_name
  location                 = var.location
  sku                 = "Premium"
  admin_enabled       = true
  georeplications {
    location                = "East Asia"
    zone_redundancy_enabled = true
    tags                    = {}
  }
  georeplications {
    location                = "North Europe"
    zone_redundancy_enabled = true
    tags                    = {}
  }
}

/*
resource "azurerm_resource_group" "resource_group_name" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "tffile_storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.resource_group_name.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tffileconatiner" {
  name                  = var.conatiner_storage_account_name
  storage_account_name  = azurerm_storage_account.tffile_storage_account.name
  container_access_type = "private"
}
*/