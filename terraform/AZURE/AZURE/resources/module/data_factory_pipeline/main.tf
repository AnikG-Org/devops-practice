resource "azurerm_data_factory_pipeline" "pipeline" {
  name                = var.name
  resource_group_name = var.resource_group_name
  data_factory_name   = var.data_factory_name
}
