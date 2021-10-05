# terraform-azurerm-logic-app-action-http

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_logic_app_workflow" "logicappworkflow" {
  name                = var.user_parameters.naming_service.logic_app.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "logic-app-action-http" {
  source                 = "../../"
  name                   = "actionhttp"
  logic_app_id           = data.azurerm_logic_app_workflow.logicappworkflow.id
  resource_group_name    = data.azurerm_resource_group.app_env_resource_group.name
  method                 = "GET"
  uri                    = "http://logicapp.com/some-actions"
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
| logic\_app\_id | The ID of the Logic App Workflow. | `string` | n/a | yes |
| method | Specifies the HTTP Method which should be used for this HTTP Action. Possible values include DELETE, GET, PATCH, POST and PUT. | `string` | n/a | yes |
| name | The name of the Logic App action-http to be created. | `string` | n/a | yes |
| resource\_group\_name | Name of the resource group to which logic app action http is to be deployed. | `string` | n/a | yes |
| uri | Specifies the URI which will be called when this HTTP Action is triggered. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the recurrence trigger created. |
| name | Name of the recurrence trigger created. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
