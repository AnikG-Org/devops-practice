###  Output variables  ###

output "name" {
  description = "Name of the storage queue created"
  value       = azurerm_storage_queue.storagequeue.name
}

output "id" {
  description = "ID of storage queue created"
  value       = azurerm_storage_queue.storagequeue.id
}

