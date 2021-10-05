output "id" {
  description = "ID of the Association between the Network Interface and the Load Balancers Backend Address Pool created."
  value       = azurerm_network_interface_backend_address_pool_association.network_interface_backend_address_pool_association.*.id
}
