
data "azurerm_virtual_network" "vnet" {
  name                = var.system_parameters.VNET
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = element(data.azurerm_virtual_network.vnet.subnets, 0)
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_app_service_plan" "app_plan" {
  name                = "search-app-service-plan"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}


module "app_service" {
  source = "../../"
  # insert required variables here
  resource_group_name = var.__ghs.environment_resource_groups
  location            = var.__ghs.environment_hosting_region
  name                = var.user_parameters.naming_service.app_service.a01
  app_service_plan_id = data.azurerm_app_service_plan.app_plan.id
  app_settings = {
    "ENVIRONMENT" = "DEV"
  }
  scm_type                = "VSTSRM"
  client_affinity_enabled = true
  default_documents       = ["Default.htm", "Default.html"]
  cors = [{
    allowed_origins : ["uk.pwc.com"]
    support_credentials : false
  }]
  ip_restrictions  =  [
      {
        priority  = 101
        name      = "ACL_RULE_NAME"
        ip_address = "13.234.188.64/32"
      },
      {
        priority  = 102
        name      = "ALLOW_AZURE_FRONTDOOR"
        service_tag= "AzureFrontDoor.Backend"
      },
      {
        priority  = 103
        name      = "SUBNET_NAME"
        subnet_id = data.azurerm_subnet.subnet.id
      },
    ]
  linux_fx_version = "app_image_name"
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
  vnet_resource_group_name = replace(var.system_parameters.VNET, "-VNT-", "-RGP-BASE-")
}
