# terraform-azurerm-logic-app-trigger-recurrence

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_logic_app_workflow" "logicappwf" {
  name                = var.user_parameters.naming_service.logic_app.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "logic-app-trigger-recurrence" {
  source                 = "../../"
  name                   = "triggerrecurrence"
  logic_app_id           = data.azurerm_logic_app_workflow.logicappwf.id
  frequency              = "Hour"
  interval               = 1
  resource_group_name    = data.azurerm_resource_group.app_env_resource_group.name
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
| frequency | Specifies the Frequency at which this Trigger should be run. Possible values include Month, Week, Day, Hour, Minute and Second. | `string` | n/a | yes |
| interval | Specifies interval used for the Frequency, for example a value of 4 for interval and hour for frequency would run the Trigger every 4 hours | `number` | n/a | yes |
| logic\_app\_id | The ID of the Logic App Workflow. | `string` | n/a | yes |
| name | The name of the Logic App Workflow reccurance to be created | `string` | n/a | yes |
| resource\_group\_name | Name of the resource group to which table storage is to be deployed. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the recurrence trigger created. |
| name | Name of the recurrence trigger created. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
