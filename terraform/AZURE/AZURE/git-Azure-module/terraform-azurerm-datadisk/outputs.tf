###  Output variables  ###

output "id" {
  description = "The resource id for the datadisk being deployed"
  value       = azurerm_managed_disk.datadisk.*.id
}

output "name" {
  description = "The name for the datadisk being deployed"
  value       = azurerm_managed_disk.datadisk.*.name
}

