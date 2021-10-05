# terraform-azurerm-monitor-activity-log-alert

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

data "azurerm_monitor_action_group" "action_group" {
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  name                = "APP-INSIGHTS-ACTION-GRP"
}

module "monitor-activity-log-alert" {
  source                    = "../../"
  name                      = "monitor-activity-log-alert-name"
  resource_group_name       = data.azurerm_resource_group.app_env_resource_group.name
  monitor_action_group_name = data.azurerm_monitor_action_group.action_group.name
  description               = "monitor-activity-log-alert-description"  
  scopes                    = [data.azurerm_resource_group.app_env_resource_group.id]
  resource_id               = "/subscriptions/4942ac67-943a-4f66-95ca-0068c4455040/resourceGroups/PZI-GXUS-G-RGP-OOFMH-T007/providers/Microsoft.Compute/virtualMachines/testlinuxavzone"
  operation_name            = "Microsoft.Storage/storageAccounts/write"
  category                  = "Recommendation"
  level                     = "Informational"
  status                    = ""
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
| category | The category of the operation. Possible values are Administrative, Autoscale, Policy, Recommendation, Security and Service Health. | `string` | n/a | yes |
| description | A description for this monitor activity log alert. | `string` | n/a | yes |
| level | The severity level of the event. Possible values are Verbose, Informational, Warning, Error, and Critical. | `string` | n/a | yes |
| monitor\_action\_group\_name | The name of the monitor action group. | `string` | n/a | yes |
| name | The name of the monitor activity log alert. | `string` | n/a | yes |
| operation\_name | The Resource Manager Role-Based Access Control operation name. Supported operation should be of the form: <resourceProvider>/<resourceType>/<operation>. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group. | `string` | n/a | yes |
| scopes | The Scope at which the Activity Log should be applied, for example a the Resource ID of a Subscription or a Resource (such as a Storage Account). | `list(string)` | n/a | yes |
| status | The status of the event. For example, Started, Failed, or Succeeded. | `string` | n/a | yes |
| tags | A mapping of tags to assign to the monitor activy log alert. | `map(string)` | n/a | yes |
| enabled | Enable this Activity Log Alert. | `string` | `"true"` | no |
| resource\_id | The specific resource monitored by the activity log alert. It should be within one of the scopes. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the activity log alert. |
| name | The Name of the activity log alert. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
