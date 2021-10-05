locals {
  sql_server_name          = "u2zaevopsdsp001"
  sql_db_name_upper        = var.user_parameters.naming_service.sqldb.db01
  sql_db_name              = lower(local.sql_db_name_upper)
  vnet_resource_group_name = replace(var.system_parameters.VNET, "-VNT-", "-RGP-BASE-")
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

data "azurerm_storage_account" "storage_account" {
  name                = var.user_parameters.naming_service.storage.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_sql_server" "sqlserver" {
  name                = "u2zoofmhstsp003"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "sql_database" {
  source                           = "../../"
  resource_group_name              = data.azurerm_resource_group.app_env_resource_group.name
  server_name                      = data.azurerm_sql_server.sqlserver.name
  name                             = "ngdbase1"
  db_edition                       = "Basic"              #Should select according to elastic pool edition
  requested_service_objective_name = "ElasticPool" 
  max_size_bytes                   = "2147483648"         #34359738368 for general purpose elasticpool
  location                         = data.azurerm_resource_group.app_env_resource_group.location
  read_scale                       = false
  zone_redundant                   = false
  elastic_pool_name                = "sqlelasticpool01"
  threat_detection_policy = [
    {
      state                      = "Enabled"
      disabled_alerts            = null
      email_account_admins       = null
      email_addresses            = ["fake.email@pwc.com"]
      retention_days             = 14
      storage_account_access_key = data.azurerm_storage_account.storage_account.primary_access_key
      storage_endpoint           = data.azurerm_storage_account.storage_account.primary_blob_endpoint
      use_server_default         = "Disabled"

    }
  ]
  tags = local.tags
}
