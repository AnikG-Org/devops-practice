# terraform-azurerm-iothub

## Usage
``` terraform
locals {
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

module "iothub" {
  source                      = "../../"
  storage_account_name        = var.user_parameters.naming_service.storage.k01
  resource_group_name         = data.azurerm_resource_group.app_env_resource_group.name
  location                    = data.azurerm_resource_group.app_env_resource_group.location
  account_tier                = "Standard"
  account_replication_type    = "LRS"
  storage_container_name      = "sqldbtdlogs"
  container_access_type       = "private"
  iothub_name                 = "ngtestingiothub123"
  sku_name                    = "S1"
  sku_capacity                = "1"
  endpoint_type               = "AzureIotHub.StorageContainer"
  endpoint_name               = "myiot_endpoint"
  batch_frequency_in_seconds  = "300"
  max_chunk_size_in_bytes     = "314572800"
  endpoint_encoding           = "Avro"
  file_name_format            = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  route_name                  = "export"
  route_source                = "DeviceMessages"
  endpoint_names              = ["events"]
  route_enabled               = "true"
  condition                   = true
  fallback_enabled            = true
  fallback_source             = "DeviceMessages"
  ipfilter_name               = "ngrule"
  ipfilter_ip_mask            = "10.0.0.0/24"
  iptilter_action             = "Accept"
  tags                        = local.tags
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
| account\_replication\_type | The storage account replication type, choose between LRS, GRS. | `string` | n/a | yes |
| account\_tier | The storage account tier, choose between Standard or Premium. | `string` | n/a | yes |
| container\_access\_type | The container access type. | `string` | n/a | yes |
| endpoint\_name | The name of the endpoint.The following names are reserved: events, operationsMonitoringEvents, fileNotifications and $default. | `string` | n/a | yes |
| endpoint\_names | The list of endpoints to which messages that satisfy the condition are routed. | `list(string)` | n/a | yes |
| endpoint\_type | The type of endpoint. Possible values are AzureIotHub.StorageContainer, AzureIotHub.ServiceBusQueue, AzureIotHub.ServiceBusTopic or AzureIotHub.EventHub. | `string` | n/a | yes |
| fallback\_enabled | Used to specify whether the fallback route is enabled. | `string` | n/a | yes |
| fallback\_source | The source that the routing rule is to be applied to. Possible values include: RoutingSourceInvalid, RoutingSourceDeviceMessages, RoutingSourceTwinChangeEvents, RoutingSourceDeviceLifecycleEvents, RoutingSourceDeviceJobLifecycleEvents. | `string` | n/a | yes |
| iothub\_name | The name of the iothub. | `string` | n/a | yes |
| ipfilter\_ip\_mask | The IP address range in CIDR notation for the rule. | `string` | n/a | yes |
| ipfilter\_name | The name of the filter. | `string` | n/a | yes |
| iptilter\_action | The desired action for requests captured by this rule,Possible values are Accept, Reject | `string` | n/a | yes |
| location | The location of the resource group. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group. | `string` | n/a | yes |
| route\_enabled | Used to specify whether a route is enabled. | `string` | n/a | yes |
| route\_name | The name of the route. | `string` | n/a | yes |
| route\_source | The source that the routing rule is to be applied to, such as DeviceMessages. Possible values include: RoutingSourceInvalid, RoutingSourceDeviceMessages, RoutingSourceTwinChangeEvents, RoutingSourceDeviceLifecycleEvents, RoutingSourceDeviceJobLifecycleEvents. | `string` | n/a | yes |
| sku\_capacity | The number of provisioned IoT Hub units. | `string` | n/a | yes |
| sku\_name | The name of the sku. SKU choices: B1, B2, B3, F1, S1, S2, and S3. | `string` | n/a | yes |
| storage\_account\_name | The name of the storage account. | `string` | n/a | yes |
| storage\_container\_name | The storage container name. | `string` | n/a | yes |
| tags | Tags to be used in the resource. | `map(string)` | n/a | yes |
| batch\_frequency\_in\_seconds | Time interval at which blobs are written to storage. Value range is between 60 and 720, default value is 300. This is mandatory for endpoint type AzureIotHub.StorageContainer. | `string` | `"300"` | no |
| condition | The condition that is evaluated to apply the routing rule. If no condition is provided, it evaluates to true by default. | `string` | `"true"` | no |
| endpoint\_encoding | Encoding that is used to serialize messages to blobs. Supported values are 'avro' and 'avrodeflate'. Default value is 'avro'. This attribute is mandatory for endpoint type AzureIotHub.StorageContainer. | `string` | `"Avro"` | no |
| file\_name\_format | File name format for the blob. Default format is {iothub}/{partition}/{YYYY}/{MM}/{DD}/{HH}/{mm}. All parameters are mandatory but can be reordered. This attribute is mandatory for endpoint type AzureIotHub.StorageContainer. | `string` | `"{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"` | no |
| max\_chunk\_size\_in\_bytes | Maximum number of bytes for each blob written to storage. Value should be between 10485760(10MB) and 524288000(500MB). Default value is 314572800(300MB) and is mandatory for endpoint type AzureIotHub.StorageContainer. | `string` | `"314572800"` | no |

## Outputs

| Name | Description |
|------|-------------|
| event\_hub\_events\_endpoint | The EventHub compatible endpoint for events data. |
| event\_hub\_events\_path | The EventHub compatible path for events data. |
| event\_hub\_operations\_endpoint | The EventHub compatible endpoint for operational data. |
| event\_hub\_operations\_path | The EventHub compatible path for operational data. |
| hostname | The hostname of the IotHub Resource. |
| id | The ID of the IoTHub. |
| shared\_access\_policy | The shared access policies defined within the resource deployment. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
