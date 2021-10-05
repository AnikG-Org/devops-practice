# terraform-azurerm-stream-analytics-output-eventhub

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_eventhub_namespace" "eventhub_namespace" {
   name                = "ngeventns"
   resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_eventhub" "eventhub" {
  name                = "ngtesteventhub"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  namespace_name      = data.azurerm_eventhub_namespace.eventhub_namespace.name
}

data "azurerm_stream_analytics_job" "stream_analytics_job" {
  name                = var.user_parameters.naming_service.stream_analytics_job.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "stream_analytics_output_eventhub" {
    source                       = "../../"
    name                         = "eventhub-stream-outputeventhub"
    stream_analytics_job_name    = data.azurerm_stream_analytics_job.stream_analytics_job.name
    resource_group_name          = data.azurerm_resource_group.app_env_resource_group.name
    eventhub_name                = data.azurerm_eventhub.eventhub.name
    servicebus_namespace         = "servicebustesting12345"
    shared_access_policy_key     = data.azurerm_eventhub_namespace.eventhub_namespace.default_primary_key
    shared_access_policy_name    = "RootManageSharedAccessKey"
    serialization  = [{
        type                        = "Avro"
    }]
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
| eventhub\_name | The name of the Event Hub. | `string` | n/a | yes |
| name | The name of the Stream output EventHub. | `string` | n/a | yes |
| resource\_group\_name | The name of the Resource Group where the Stream Analytics Job exists. | `string` | n/a | yes |
| servicebus\_namespace | The namespace that is associated with the desired Event Hub, Service Bus Queue, Service Bus Topic, etc. | `string` | n/a | yes |
| shared\_access\_policy\_key | The shared access policy key for the specified shared access policy. | `string` | n/a | yes |
| shared\_access\_policy\_name | The shared access policy name for the Event Hub, Service Bus Queue, Service Bus Topic, etc. | `string` | n/a | yes |
| stream\_analytics\_job\_name | The name of the Stream Analytics Job. | `string` | n/a | yes |
| serialization | One or more serialization details.Example serialization inputs include type, encoding, format, and field\_delimiter. Please see the example usage block for more details. | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Stream Analytics Stream output EventHub. |
| name | The Name of the Stream Analytics Stream output EventHub. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
