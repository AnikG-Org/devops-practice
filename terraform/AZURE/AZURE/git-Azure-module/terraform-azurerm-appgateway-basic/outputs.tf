output "id" {
  value = azurerm_application_gateway.app_gateway.id
}

output "backend_address_pool_id" {
  value = azurerm_application_gateway.app_gateway.backend_address_pool.0.id
}

output "application_gateways_all" {
  value = [
    {
      id : azurerm_application_gateway.app_gateway.id
      authentication_certificate : azurerm_application_gateway.app_gateway.authentication_certificate
      backend_address_pool : azurerm_application_gateway.app_gateway.backend_address_pool
      backend_http_settings : azurerm_application_gateway.app_gateway.backend_http_settings
      frontend_ip_configuration : azurerm_application_gateway.app_gateway.frontend_ip_configuration
      frontend_port : azurerm_application_gateway.app_gateway.frontend_port
      gateway_ip_configuration : azurerm_application_gateway.app_gateway.gateway_ip_configuration
      enable_http2 : azurerm_application_gateway.app_gateway.enable_http2
      http_listener : azurerm_application_gateway.app_gateway.http_listener
      probe : azurerm_application_gateway.app_gateway.probe
      request_routing_rule : azurerm_application_gateway.app_gateway.request_routing_rule
      ssl_certificate : azurerm_application_gateway.app_gateway.ssl_certificate
      url_path_map : azurerm_application_gateway.app_gateway.url_path_map
      custom_error_configuration : azurerm_application_gateway.app_gateway.custom_error_configuration
      redirect_configuration : azurerm_application_gateway.app_gateway.redirect_configuration
    }
  ]
}

