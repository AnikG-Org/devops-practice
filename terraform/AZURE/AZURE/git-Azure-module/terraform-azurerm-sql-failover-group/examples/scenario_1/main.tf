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

data "azurerm_sql_server" "primary" {
  name                = "u2zoofmhsdsp006"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_sql_server" "secondary" {
  name                = "nezoofmhsdsp002"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_sql_database" "db1" {
  name                = "u2zoofmhsddb002"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  server_name         = data.azurerm_sql_server.primary.name
}


module "sql_failover_group" {
  source                              = "../../"
  name                                = "ngcfailovergrouptest01"
  resource_group_name                 = data.azurerm_resource_group.app_env_resource_group.name
  primary_server_name                 = data.azurerm_sql_server.primary.name
  databases                           = [data.azurerm_sql_database.db1.id]
  secondary_server_id                 = data.azurerm_sql_server.secondary.id
  read_write_endpoint_failover_policy = [{
    read_write_mode                   = "Automatic"
    grace_minutes                     = 60
  }]
  tags = local.tags
}
