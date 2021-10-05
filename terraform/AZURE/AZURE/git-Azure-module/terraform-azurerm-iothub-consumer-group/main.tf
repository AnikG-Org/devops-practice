resource "azurerm_iothub_consumer_group" "iothub_consumer_group" {
  name                   = var.name
  iothub_name            = var.iothub_name
  eventhub_endpoint_name = var.eventhub_endpoint_name
  resource_group_name    = var.resource_group_name
}

