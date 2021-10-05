resource "azurerm_network_interface_backend_address_pool_association" "network_interface_backend_address_pool_association" {
  count                   = var.nic_count
  network_interface_id    = var.nic_ids[count.index]
  ip_configuration_name   = var.ip_configuration_name
  backend_address_pool_id = var.backend_address_pool_id
}
