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
