## Output variables
output "id" {
  value = azurerm_application_gateway.app_gateway.id
}

output "backend_address_pool_id" {
  value = azurerm_application_gateway.app_gateway.backend_address_pool.0.id
}

output "public_ip" {
  value = [{
    domain_name_label : try(azurerm_public_ip.pulbic_ip[*].domain_name_label, null)
    idle_timeout_in_minutes : try(azurerm_public_ip.pulbic_ip[*].idle_timeout_in_minutes, null)
    fqdn : try(azurerm_public_ip.pulbic_ip[*].fqdn, null)
    ip_address : try(azurerm_public_ip.pulbic_ip[*].ip_address, null)
    ip_version : try(azurerm_public_ip.pulbic_ip[*].ip_version, null)
    sku : try(azurerm_public_ip.pulbic_ip[*].sku, null)
    ip_tags : try(azurerm_public_ip.pulbic_ip[*].ip_tags, null)
    tags : try(azurerm_public_ip.pulbic_ip[*].tags, null)
    }
  ]

}

