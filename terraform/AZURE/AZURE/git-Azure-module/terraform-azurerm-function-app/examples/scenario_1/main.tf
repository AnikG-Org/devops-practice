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
  name = "PZI-GXUS-G-RGP-OOFMH-T007"

}

data "azurerm_virtual_network" "vnet" {
  name                = var.system_parameters.VNET
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = "PZI-GXUS-G-SNT-OOFMH-T015"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_storage_account" "storage_account" {
  name                = "pzigxsus2ploofmht008"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_app_service_plan" "app_plan" {
  name                = var.user_parameters.naming_service.app-service-planname.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}
module "primary_hc_app" {
  source                     = "../../"
  name                       = "appfuncname"
  location                   = data.azurerm_resource_group.app_env_resource_group.location
  resource_group_name        = data.azurerm_resource_group.app_env_resource_group.name
  app_service_plan_id        = data.azurerm_app_service_plan.app_plan.id
  app_service_plan_sku_tier  = "PremiumV2"
  storage_account_name       = data.azurerm_storage_account.storage_account.name
  storage_account_access_key = data.azurerm_storage_account.storage_account.primary_access_key
  app_settings               = {}
  tags                       = {}
  os_type                    = "linux"
  enable_builtin_logging     = false
  ip_restrictions            = [
      {
        priority  = 101
        name      = format("ALLOW_%s", data.azurerm_subnet.subnet.name)
        subnet_id = data.azurerm_subnet.subnet.id
      }
  ]
}
