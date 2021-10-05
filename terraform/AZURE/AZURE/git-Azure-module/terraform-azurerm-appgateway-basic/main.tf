resource "azurerm_application_gateway" "app_gateway" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku {
    name     = var.sku_name
    tier     = var.tier
    capacity = var.sku_capacity
  }

  gateway_ip_configuration {
    name      = format("%s-GATEWAY-IPCONFIG", var.name)
    subnet_id = var.subnet_id
  }

  dynamic "frontend_port" {
    for_each = [for f in var.frontend_ports : {
      name = f.name
      port = f.port
      }
    ]
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  frontend_ip_configuration {
    name                          = format("%s-FRONTEND-IPCONFIG", var.name)
    subnet_id                     = var.subnet_id
    private_ip_address            = var.private_ip_address
    private_ip_address_allocation = var.private_ip_address_allocation
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.value.name
      ip_addresses = backend_address_pool.value.ip_addresses
      fqdns        = backend_address_pool.value.fqdns
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    content {
      name     = ssl_certificate.value.ssl_name
      data     = filebase64(ssl_certificate.value.data)
      password = ssl_certificate.value.ssl_password
    }
  }

  dynamic "authentication_certificate" {
    for_each = var.auth_cert
    content {
      name = authentication_certificate.value.authentication_certificate_name
      data = base64encode(file(authentication_certificate.value.authentication_certificate_data))
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      port                                = backend_http_settings.value.backend_http_port
      protocol                            = backend_http_settings.value.backend_http_protocol
      request_timeout                     = backend_http_settings.value.backend_request_timeout_in_seconds
      host_name                           = backend_http_settings.value.host_name
      probe_name                          = backend_http_settings.value.probe_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address

      dynamic "authentication_certificate" {
        for_each = backend_http_settings.value.backend_http_protocol == "Http" ? [] : var.auth_cert
        content {
          name = authentication_certificate.value.authentication_certificate_name
        }
      }
    }
  }

  dynamic "http_listener" {
    for_each = [for l in var.listener : {
      name                           = l.name
      frontend_ip_configuration_name = l.frontend_ip_configuration_name
      frontend_port_name             = l.frontend_port_name
      protocol                       = l.protocol
      host_name                      = l.host_name
      ssl_certificate_name           = l.protocol == "Https" ? l.ssl_certificate_name : ""
      }
    ]
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      ssl_certificate_name           = http_listener.value.ssl_certificate_name
      host_name                      = http_listener.value.host_name
    }
  }

  dynamic "request_routing_rule" {
    for_each = [for r in var.routing_rule : {
      name                       = r.name
      rule_type                  = "Basic"
      http_listener_name         = r.http_listener_name
      backend_address_pool_name  = r.backend_address_pool_name
      backend_http_settings_name = r.backend_http_settings_name
      url_path_map_name          = r.url_path_map_name
      }
    ]
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
      url_path_map_name          = request_routing_rule.value.url_path_map_name
    }
  }

dynamic "url_path_map" {
    for_each = var.url_path_map
    content {
      name                               = url_path_map.value.name
      default_backend_http_settings_name = url_path_map.value.default_backend_http_settings_name
      default_backend_address_pool_name  = url_path_map.value.default_backend_address_pool_name
      default_redirect_configuration_name = url_path_map.value.default_redirect_configuration_name
      dynamic "path_rule" {
        for_each = url_path_map.value.path_rule
        content {
          name                        = path_rule.value.path_rule_name
          paths                       = path_rule.value.paths
          backend_address_pool_name   = path_rule.value.backend_address_pool_name
          backend_http_settings_name  = path_rule.value.backend_http_settings_name
        }
      }
    }
  }

  dynamic "probe" {
    for_each = var.probe
    content {
      name                                      = probe.value.name
      protocol                                  = probe.value.protocol
      path                                      = probe.value.path
      interval                                  = probe.value.interval
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      port                                      = probe.value.port
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings

      match {
        body        = probe.value.body
        status_code = probe.value.status_code
      }
    }
  }
}
