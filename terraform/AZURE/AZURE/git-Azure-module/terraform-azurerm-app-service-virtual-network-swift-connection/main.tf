resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = var.app_service_id
  subnet_id      = var.subnet_id
}
