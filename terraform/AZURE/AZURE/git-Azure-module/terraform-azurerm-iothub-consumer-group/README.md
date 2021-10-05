# terraform-azurerm-iothub-consumer-group

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_iothub" "iothub" {
    name                    = "ngtestingiothub123"
    resource_group_name     = data.azurerm_resource_group.app_env_resource_group.name
}

module "iothub-consumer-group" {
  source                 = "../../"
  name                   = "ngtestingiothub123-consumer-group"
  iothub_name            = data.azurerm_iothub.iothub.name
  eventhub_endpoint_name = "events"
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
| eventhub\_endpoint\_name | The name of the Event Hub-compatible endpoint in the IoT hub. Changing this forces a new resource to be created. | `string` | n/a | yes |
| iothub\_name | The name of the IoT Hub. Changing this forces a new resource to be created. | `string` | n/a | yes |
| name | The name of this Consumer Group. Changing this forces a new resource to be created. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group that contains the IoT hub. Changing this forces a new resource to be created. | `string` | n/a | yes |
| ip\_filter | One or more serialization details.Example serialization inputs include type, encoding, format, and field\_delimiter. Please see the example usage block for more details. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the IoTHub Consumer Group. |
| name | Name of the IOT consumer group created. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
