resource "azurerm_application_gateway" "app_gateway" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.sku_capacity
  }

  gateway_ip_configuration {
    name      = "${var.name}-GATEWAY-IPCONFIG"
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = "${var.name}-FRONTEND-PORT"
    port = var.frontend_port_no
  }

  frontend_ip_configuration {
    name                          = "${var.name}-FRONTEND-IPCONFIG"
    subnet_id                     = var.subnet_id
   # public_ip_address_id          = var.public_ip_address_id
   # private_ip_address            = var.private_ip_address
    private_ip_address_allocation = var.private_ip_address_allocation
  }

  backend_address_pool {
    name = "${var.name}-BACKEND-ADDRESSPOOL"
  }

  backend_http_settings {
    name                  = "${var.name}-HTTP-SETTINGS"
    cookie_based_affinity = var.cookie_based_affinity
    path                  = var.path_prefix
    port                  = var.backend_http_port
    protocol              = var.backend_http_protocol
    request_timeout       = var.backend_request_timeout_in_seconds
  }

  http_listener {
    name                           = "${var.name}-HTTP-LISTENER"
    frontend_ip_configuration_name = "${var.name}-FRONTEND-IPCONFIG"
    frontend_port_name             = "${var.name}-FRONTEND-PORT"
    protocol                       = var.http_listener_protocol
  }

  request_routing_rule {
    name                       = "${var.name}-REQ-ROUTING-RULE"
    rule_type                  = var.routing_rule_type
    http_listener_name         = "${var.name}-HTTP-LISTENER"
    backend_address_pool_name  = "${var.name}-BACKEND-ADDRESSPOOL"
    backend_http_settings_name = "${var.name}-HTTP-SETTINGS"
    url_path_map_name          = "${var.name}-URL-PATH"
  }

  url_path_map {
    name                               = "${var.name}-URL-PATH"
    default_backend_http_settings_name = "${var.name}-HTTP-SETTINGS"
    default_backend_address_pool_name  = "${var.name}-BACKEND-ADDRESSPOOL"
    path_rule {
      name                       = "${var.name}-PATH-RULE"
      paths                      = var.url_path_rule
      backend_http_settings_name = "${var.name}-HTTP-SETTINGS"
      backend_address_pool_name  = "${var.name}-BACKEND-ADDRESSPOOL"
    }
  }

  probe {
    name                                      = "${var.name}-HEALTH-PROBE"
    protocol                                  = var.backend_http_protocol
    path                                      = "/"
    interval                                  = var.heathprobe_interval
    timeout                                   = var.heathprobe_timeout
    unhealthy_threshold                       = var.heathprobe_unhealthy_threshold
    pick_host_name_from_backend_http_settings = true

    match {
      body        = var.healthprobe_match_response_body
      status_code = var.healthprobe_match_statuscodes
    }
  }
}