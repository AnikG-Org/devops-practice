output "id" {
  description = "ID of the virtual machine which is created"
  value       = azurerm_linux_virtual_machine.linux_virtual_machine.id
}

output "name" {
  description = "Name of the virtual machine which is created"
  value       = azurerm_linux_virtual_machine.linux_virtual_machine.name
}

output "private_ip_addresses" {
  description = "All Private IP Addresses allocated to VM"
  value       = azurerm_linux_virtual_machine.linux_virtual_machine.private_ip_addresses
}

output "nic_id" {
  description = "ID of the NIC associated with the VM which is created"
  value       = length(local.nic_id) == 1 ? local.nic_id.id : null
}

locals {
  nic_id = {
    for value in azurerm_network_interface.nic.*.id :
    "id" => value
  }
}

output "backup_protected_vm_id" {
  description = "The ID of the Backup Protected Virtual Machine."
  value = azurerm_backup_protected_vm.vm_backup.id
}
