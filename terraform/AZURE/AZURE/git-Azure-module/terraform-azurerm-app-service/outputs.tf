output "id" {
  description = "The ID of the App Service."
  value       = azurerm_app_service.app_svc.id
}

output "custom_domain_verification_id" {
  description = "An identifier used by App Service to perform domain ownership verification via DNS TXT record."
  value       = azurerm_app_service.app_svc.custom_domain_verification_id
}

output "default_site_hostname" {
  description = "The default hostname associated with the App Service."
  value       = azurerm_app_service.app_svc.default_site_hostname
}

output "outbound_ip_addresses" {
  description = "List of Outbound IP Address"
  value       = azurerm_app_service.app_svc.outbound_ip_addresses
}

output "possible_outbound_ip_addresses" {
  description = "List of Possible Outbound IP Address"
  value       = azurerm_app_service.app_svc.possible_outbound_ip_addresses
}

output "identity" {
  description = "Contains the Managed Service Identity information for this App Service."
  value       = azurerm_app_service.app_svc.identity
}

output "site_credential" {
  description = "Contains the site-level credentials used to publish to this App Service."
  value       = azurerm_app_service.app_svc.site_credential
}

output "azurerm_app_service_certificate_ids" {
  description = "The App Service certificate ids."
  value = {
    for app_service_certificate in azurerm_app_service_certificate.app_service_certificate :
    app_service_certificate.name => app_service_certificate.id...
  }
}

output "azurerm_app_service_certificate_thumbprint" {
  description = "The thumbprint for the certificate."
  value = {
    for app_service_certificate in azurerm_app_service_certificate.app_service_certificate :
    app_service_certificate.thumbprint => app_service_certificate.id...
  }
}

output "azurerm_app_service_certificate_issue_date" {
  description = "The App Service certificate issue date."
  value = {
    for app_service_certificate in azurerm_app_service_certificate.app_service_certificate :
    app_service_certificate.name => app_service_certificate.issue_date...
  }
}

output "azurerm_app_service_certificate_expiration_date" {
  description = "The App Service certificate expiration date."
  value = {
    for app_service_certificate in azurerm_app_service_certificate.app_service_certificate :
    app_service_certificate.name => app_service_certificate.expiration_date...
  }
}

output "azurerm_app_service_custom_hostname_binding_id" {
  description = "The ID of the App Service Custom Hostname Binding"
  value = {
    for custom_hostname_binding in azurerm_app_service_custom_hostname_binding.custom_hostname_binding :
    custom_hostname_binding.hostname => custom_hostname_binding.id...
  }
}

output "azurerm_app_service_custom_hostname_binding_virtual_ip" {
  description = "The virtual IP address assigned to the hostname if IP based SSL is enabled"
  value = {
    for custom_hostname_binding in azurerm_app_service_custom_hostname_binding.custom_hostname_binding :
    custom_hostname_binding.hostname => custom_hostname_binding.virtual_ip...
  }
}