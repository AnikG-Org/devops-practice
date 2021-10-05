# terraform-azurerm-notification-hub

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_notification_hub_namespace" "hub_namespace" {
  name                = "ngchubeusoofmh001"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "notification-hub" {
  source                 = "../../"
  name                   = var.user_parameters.naming_service.notification_hub.k01
  location               = var.__ghs.environment_hosting_region
  resource_group_name    = data.azurerm_resource_group.app_env_resource_group.name
  namespace_name         = data.azurerm_notification_hub_namespace.hub_namespace.name
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
| location | The Azure Region in which this Notification Hub Namespace exists. | `string` | n/a | yes |
| name | The name to use for this Notification Hub. | `string` | n/a | yes |
| namespace\_name | The name of the Notification Hub Namespace in which to create this Notification Hub. | `string` | n/a | yes |
| resource\_group\_name | The name of the Resource Group in which the Notification Hub Namespace exists. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Stream Analytics Stream Input EventHub. |
| name | The Name of the Stream Analytics Stream Input EventHub. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
