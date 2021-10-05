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

data "azurerm_application_insights" "appinsights" {
  name                = var.user_parameters.naming_service.app_insights.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_monitor_action_group" "action_group" {
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  name                = "APP-INSIGHTS-ACTION-GRP"
}

module "monitor-metric-alert" {
  source              = "../../"
  name                = "High CPU Usage Alert"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  scopes              = [data.azurerm_application_insights.appinsights.id]
  description         = "Alert when CPU exceeds 80% threshold"
  frequency           = "30M"
  window_size         = "1H"
  action_group_id     = data.azurerm_monitor_action_group.action_group.id
  metric_namespace    = "Microsoft.Insights/Components"
  metric_name         = "performanceCounters/processCpuPercentage"
  aggregation         = "Average"
  operator            = "GreaterThan"
  threshold           = "50"
  tags = local.tags
}
