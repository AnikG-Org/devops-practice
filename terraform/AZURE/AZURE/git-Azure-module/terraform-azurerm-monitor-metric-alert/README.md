# terraform-azurerm-monitor-metric-alert

## Usage
``` terraform
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

```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14 |
| terraform | >= 0.14 |
| azurerm | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aggregation | The statistic that runs over the metric values. Possible values are Average, Minimum, Maximum and Total. | `string` | n/a | yes |
| description | Descrition of the monitor metric alert | `any` | n/a | yes |
| metric\_name | Metric name to be monitored | `string` | n/a | yes |
| metric\_namespace | Metric namespace to be monitored | `string` | n/a | yes |
| name | Specifies the name of the monitor metric alert to be created | `any` | n/a | yes |
| operator | The criteria operator. Possible values are Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan and LessThanOrEqual. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the metric alert. | `any` | n/a | yes |
| threshold | The criteria threshold value that activates the alert. | `string` | n/a | yes |
| action\_group\_id | Specifies the id of the monitoring action group through which alerts are notified | `string` | `""` | no |
| frequency | The evaluation frequency of this Metric Alert. Possible Values are 1M, 5M, 15M, 30M, 1H | `string` | `"1M"` | no |
| scopes | The resource ID at which the metric criteria should be applied. | `list(string)` | `[]` | no |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| window\_size | The period of time that is used to monitor alert activity.This value must be greater than frequency.Possible values are 1M, 5M, 15M, 30M, 1H, 6H, 12H, 24H | `string` | `"5M"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the metric alert |
| name | The name of the metric alert |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
