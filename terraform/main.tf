terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.43.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "my-complete-project"
      storage_account_name =  "saveterraformfilesttf"
      container_name       = "stterraform"
      key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
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

resource "azurerm_log_analytics_workspace" "crudwkspace" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "crudappenv" {
  name                       = var.envname
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.crudwkspace.id
}

resource "azurerm_container_app" "crudcontainerapp" {
  name                         = "crudapp-v1"
  container_app_environment_id = azurerm_container_app_environment.crudappenv.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  ingress{
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 8000
    transport                  = "auto"
    traffic_weight{
      latest_revision = true
      percentage      = 100
      }
  }
  template {
    container {
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.5
      memory = "1Gi"
      name              = "crudapp-v1"
    }
      min_replicas = 1
      max_replicas = 10
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