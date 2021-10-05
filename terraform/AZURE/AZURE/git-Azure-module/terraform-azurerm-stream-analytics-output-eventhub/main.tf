resource "azurerm_stream_analytics_output_eventhub" "output_eventhub" {
  # Mandatory variables.
  name                      = var.name
  stream_analytics_job_name = var.stream_analytics_job_name
  resource_group_name       = var.resource_group_name
  eventhub_name             = var.eventhub_name
  servicebus_namespace      = var.servicebus_namespace
  shared_access_policy_key  = var.shared_access_policy_key
  shared_access_policy_name = var.shared_access_policy_name
  dynamic "serialization" {
    for_each = var.serialization
    content {
      encoding        = lookup(serialization.value, "encoding", null)
      field_delimiter = lookup(serialization.value, "field_delimiter", null)
      format          = lookup(serialization.value, "format", null)
      type            = serialization.value.type
    }
  }
}

