module "keyvault-byok" {
  source              = "../../"
  location            = var.__ghs.environment_hosting_region
  name                = var.user_parameters.naming_service.key_vault.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  tags = {
    "ghs-los" : var.system_parameters.TAGS["ghs-los"],
    "ghs-solution" : var.system_parameters.TAGS["ghs-solution"],
    "ghs-appid" : var.system_parameters.TAGS["ghs-appid"],
    "ghs-environment" : var.system_parameters.TAGS["ghs-environment"],
    "ghs-owner" : var.system_parameters.TAGS["ghs-owner"],
    "ghs-tariff" : var.system_parameters.TAGS["ghs-tariff"],
    "ghs-srid" : var.system_parameters.TAGS["ghs-srid"],
    "ghs-environmenttype" : var.system_parameters.TAGS["ghs-environmenttype"],
    "ghs-deployedby" : var.system_parameters.TAGS["ghs-deployedby"],
    "ghs-dataclassification" : var.system_parameters.TAGS["ghs-dataclassification"],
    "ghs-envid" : var.system_parameters.TAGS["ghs-envid"],
    "ghs-apptioid" : var.system_parameters.TAGS["ghs-apptioid"]
  }
}

data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}