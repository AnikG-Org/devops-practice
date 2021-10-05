terraform {
  required_version = "~> 0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2"
    }
  }
}
provider "azurerm" {
    version = "~> 2"
    features {}
}
