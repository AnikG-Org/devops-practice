output "id" {
  description = "The nic id created in this module."
  value       = azurerm_network_interface.nic.id
}

output "name" {
  description = "Name of the nic that is created in this module."
  value       = azurerm_network_interface.nic.name
}

output "mac_address" {
  description = "The media access control (MAC) address of the network interface."
  value       = azurerm_network_interface.nic.mac_address
}

output "private_ip_address" {
  description = "The first private IP address of the network interface."
  value       = azurerm_network_interface.nic.private_ip_address
}

output "virtual_machine_id" {
  description = " Reference to a VM with which this NIC has been associated."
  value       = azurerm_network_interface.nic.virtual_machine_id
}

output "private_ip_addresses" {
  description = " The private IP addresses of the network interface."
  value       = azurerm_network_interface.nic.private_ip_addresses
}

