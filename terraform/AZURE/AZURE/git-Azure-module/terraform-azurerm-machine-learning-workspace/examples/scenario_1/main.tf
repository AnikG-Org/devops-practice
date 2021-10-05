locals {
  vnet_resource_group_name = replace(var.system_parameters.VNET, "N-VNT", "N-RGP-BASE")
  tags = {
    "ghs-los" : var.system_parameters.TAGS.ghs-los,
    "ghs-solution" : var.system_parameters.TAGS.ghs-solution,
    "ghs-appid" : var.system_parameters.TAGS.ghs-appid,
    "ghs-solutionexposure" : var.system_parameters.TAGS.ghs-solutionexposure,
    "ghs-serviceoffering" : var.system_parameters.TAGS.ghs-serviceoffering,
    "ghs-environment" : var.system_parameters.TAGS.ghs-environment,
    "ghs-owner" : var.system_parameters.TAGS.ghs-owner,
    "ghs-apptioid" : var.system_parameters.TAGS.ghs-apptioid,
    "ghs-envid" : var.system_parameters.TAGS.ghs-envid,
    "ghs-tariff" : var.system_parameters.TAGS.ghs-tariff,
    "ghs-srid" : var.system_parameters.TAGS.ghs-srid,
    "ghs-environmenttype" : var.system_parameters.TAGS.ghs-environmenttype,
    "ghs-deployedby" : var.system_parameters.TAGS.ghs-deployedby,
    "ghs-dataclassification" : var.system_parameters.TAGS.ghs-dataclassification
  }
}

data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_application_insights" "example" {
  name                = var.user_parameters.naming_service.app_insights.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_key_vault" "example" {
  name                = var.user_parameters.naming_service.key_vault.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_storage_account" "example" {
  name                = var.user_parameters.naming_service.storage.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "mlworkspace" {
  source                  = "../../"
  mlworkspace_name        = var.user_parameters.naming_service.ml_workspace.k01
  resource_group_name     = data.azurerm_resource_group.app_env_resource_group.name
  location                = data.azurerm_resource_group.app_env_resource_group.location
  application_insights_id = data.azurerm_application_insights.example.id
  key_vault_id            = data.azurerm_key_vault.example.id
  storage_account_id      = data.azurerm_storage_account.example.id
  tags                    = local.tags
  }
