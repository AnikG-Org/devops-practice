output "vm_id" {
  description = "The ID of newly created VM"
  value       = azurerm_windows_virtual_machine.windows_virtual_machine.id
}

output "vm_name" {
  description = "The name of newly created VM"
  value       = azurerm_windows_virtual_machine.windows_virtual_machine.name
}

output "nic_id" {
  description = "The ID of primary NIC created"
  value       = azurerm_network_interface.nic.id
}

output "nic_name" {
  description = "The Name of primary NIC created"
  value       = azurerm_network_interface.nic.name
}

output "backup_protected_vm_id" {
  description = "The ID of the Backup Protected Virtual Machine."
  value       = azurerm_backup_protected_vm.vm_backup.id
}