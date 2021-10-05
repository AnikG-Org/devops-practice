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

module "iothub" {
  source                      = "../../"
  storage_account_name        = var.user_parameters.naming_service.storage.k01
  resource_group_name         = data.azurerm_resource_group.app_env_resource_group.name
  location                    = data.azurerm_resource_group.app_env_resource_group.location
  account_tier                = "Standard"
  account_replication_type    = "LRS"
  storage_container_name      = "sqldbtdlogs"
  container_access_type       = "private"
  iothub_name                 = "ngtestingiothub123"
  sku_name                    = "S1"
  sku_capacity                = "1"
  endpoint_type               = "AzureIotHub.StorageContainer"
  endpoint_name               = "myiot_endpoint"
  batch_frequency_in_seconds  = "300"
  max_chunk_size_in_bytes     = "314572800"
  endpoint_encoding           = "Avro"
  file_name_format            = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  route_name                  = "export"
  route_source                = "DeviceMessages"
  endpoint_names              = ["events"]
  route_enabled               = "true"
  condition                   = true
  fallback_enabled            = true
  fallback_source             = "DeviceMessages"
  ipfilter_name               = "ngrule"
  ipfilter_ip_mask            = "10.0.0.0/24"
  iptilter_action             = "Accept"
  tags                        = local.tags
  }
