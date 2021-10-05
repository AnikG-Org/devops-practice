resource "azurerm_stream_analytics_job" "streamanalytics" {
  name                                     = var.name
  resource_group_name                      = var.resource_group_name
  location                                 = var.location
  compatibility_level                      = var.compatibility_level
  streaming_units                          = var.streaming_units
  tags                                     = var.tags
  transformation_query                     = var.transformation_query
}