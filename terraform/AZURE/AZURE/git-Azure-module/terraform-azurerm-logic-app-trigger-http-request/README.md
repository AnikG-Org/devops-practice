# terraform-azurerm-logic-app-trigger-http-request

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_logic_app_workflow" "httprequest" {
  name                = var.user_parameters.naming_service.logic_app.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "logic-app-trigger-http-request" {
  source              = "../../"
  name                = "actionhttprequest"
  logic_app_id        = data.azurerm_logic_app_workflow.httprequest.id
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  filename            = "var.json"
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
| local | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| filename | Specifies the Name of the local json file. | `string` | n/a | yes |
| logic\_app\_id | The name of the Logic App Workflow created. | `string` | n/a | yes |
| name | Specifies the name of the HTTP Action is to be created within the Logic App Workflow. | `string` | n/a | yes |
| resource\_group\_name | Name of the resource group in which HTTP Action is to be deployed. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Azure HTTP Request Trigger within the Logic App Workflow |
| name | The name of the Azure HTTP Request Trigger created |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
