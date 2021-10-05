terraform {
  required_version = "~> 0.12"
  required_providers {
    azurerm = "~> 2"
  }
}


provider "azurerm" {
    version = "~> 2"
    features {}
}
