###  Output variables  ###

output "id" {
  description = "ID of load balancer that is created"
  value       = azurerm_lb.lb.id
}

output "backend_address_pool_id" {
  description = "ID of load balancer's backend address pool"
  value       = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}

output "backend_address_pool_association_id" {
  description = "ID of backend address pool association resource"
  value       = azurerm_network_interface_backend_address_pool_association.attach_lb_nic.*.id
}

output "private_ip_address" {
  description = "First private ip address assigned to load balancer in frontend_ip_configuration"
  value       = azurerm_lb.lb.private_ip_address
}

output "private_ip_addresses" {
  description = "List of private ip addresses assigned to load balancer in frontend_ip_configuration"
  value       = azurerm_lb.lb.private_ip_addresses
}