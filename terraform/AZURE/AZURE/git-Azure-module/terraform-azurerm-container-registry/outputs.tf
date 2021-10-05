locals {
  acr_id = {
    for value in azurerm_container_registry.container_registry.*.id :
    "id" => value
  }
  acr_login_server = {
    for value in azurerm_container_registry.container_registry.*.login_server :
    "login_server" => value
  }
}

output "id" {
  description = "The ID of newly created Azure Container Registry" 
  value       = length(local.acr_id) == 1 ? local.acr_id.id : null
}

output "login_server" {
  description = "The server URL to push to the Container Registry"
  value       = length(local.acr_login_server) == 1 ? local.acr_login_server.login_server : null
}

