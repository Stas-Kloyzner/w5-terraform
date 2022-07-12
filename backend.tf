terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"

  backend "azurerm" {
    resource_group_name = "storage"
    storage_account_name = "w5tfstate"
    container_name = "tfstate"
  }
}
