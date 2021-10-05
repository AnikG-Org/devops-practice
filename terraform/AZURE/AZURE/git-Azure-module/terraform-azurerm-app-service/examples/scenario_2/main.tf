
module "app_service" {
  source = "../../"
  # insert required variables here
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  location            = data.azurerm_resource_group.app_env_resource_group.location
  name                = var.user_parameters.naming_service.app_service.a01
  app_service_plan_id = data.azurerm_app_service_plan.app_plan.id

  #In order to work you need to setup CNAME record for given domain poining to app service URL, for instance: contoso.azurewebsites.net
  #https://azure.microsoft.com/en-us/updates/secure-your-custom-domains-at-no-cost-with-app-service-managed-certificates-preview/
  custom_managed_domains = ["www.contoso.com"]

  tags = local.tags
}

locals {
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

data "azurerm_app_service_plan" "app_plan" {
  name                = "search-app-service-plan"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

