locals {
  defaults_app_gateway = {
    probe : {
      unhealthy_threshold : 3
      interval : 5
      timeout : 10
    }

    backend_http_settings : {
      cookie_based_affinity : "Disabled"

    }

    ssl_policy = [{
      disabled_protocols : ["TLSv1_0", "TLSv1_1"]
      policy_type : "Custom"
      cipher_suites : ["TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384", "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384", "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256", "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"]
      min_protocol_version : "TLSv1_2"
    }]

  }


  nsg_rules = [
    {
      name : "APP_GW"
      priority : var.nsg.priority_inbound_prefix
      direction : "Inbound"
      protocol : "*"
      source_port_range : "*"
      destination_port_range : "65200-65535"
      source_address_prefix : "GatewayManager"
      destination_address_prefix : "*"
    },
    {
      name : "APP_GW"
      priority : var.nsg.priority_inbound_prefix
      direction : "Inbound"
      protocol : "*"
      source_port_range : "*"
      destination_port_range : "*"
      source_address_prefix : "AzureLoadBalancer"
      destination_address_prefix : "*"

    },
    {
      name : "APP_GW"
      priority : var.nsg.priority_inbound_prefix
      direction : "Inbound"
      protocol : "*"
      source_port_range : "*"
      destination_port_range : "*"
      source_address_prefix : "VirtualNetwork"
      destination_address_prefix : "*"

    },
    {
      name : "APP_GW"
      priority : var.nsg.priority_outbound_prefix
      direction : "Outbound"
      protocol : "*"
      source_port_range : "*"
      destination_port_range : "*"
      source_address_prefix : "*"
      destination_address_prefix : "*"

    }
  ]

}

resource "azurerm_application_gateway" "app_gateway" {
  depends_on          = [azurerm_network_security_rule.appgateway]
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.sku.capacity
  }

  gateway_ip_configuration {
    name      = format("%s-GATEWAY-IPCONFIG", upper(var.name))
    subnet_id = var.subnet_id
  }

  dynamic "frontend_port" {
    for_each = toset(var.frontend_port)
    content {
      name = format("%s-%d-INTERNAL-FRONTEND-PORT", upper(var.name), frontend_port.value)
      port = frontend_port.value
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listener
    content {
      name                           = format("%s-INTERNAL-LISTENER", upper(http_listener.value.name))
      frontend_ip_configuration_name = format("%s-INTERNAL-FRONTEND-IPCONFIG", upper(http_listener.value.frontend_ip_configuration_name))
      frontend_port_name             = format("%s-%d-INTERNAL-FRONTEND-PORT", upper(var.name), http_listener.value.port)
      host_name                      = http_listener.value.host_name
      host_names                     = http_listener.value.host_names
      protocol                       = http_listener.value.protocol
      require_sni                    = http_listener.value.require_sni
      ssl_certificate_name           = http_listener.value.ssl_certificate_name
      firewall_policy_id             = null
      dynamic "custom_error_configuration" {
        for_each = http_listener.value.custom_error_configuration
        content {

          status_code           = custom_error_configuration.value.status_code
          custom_error_page_url = custom_error_configuration.value.custom_error_page_url
        }
      }
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration
    content {
      name                          = format("%s-INTERNAL-FRONTEND-IPCONFIG", upper(frontend_ip_configuration.value.name))
      subnet_id                     = try(frontend_ip_configuration.value.subnet_id, null)
      private_ip_address            = try(frontend_ip_configuration.value.private_ip_address, null)
      private_ip_address_allocation = try(frontend_ip_configuration.value.private_ip_address_allocation, null)
      public_ip_address_id          = null
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.sku.name == "Standard_v2" ? [1] : []
    content {
      name                          = "EXTERNAL-FRONTEND-IPCONFIG"
      subnet_id                     = null
      private_ip_address            = null
      private_ip_address_allocation = null
      public_ip_address_id          = var.sku.name == "Standard_v2" ? azurerm_public_ip.pulbic_ip[0].id : null
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool
    content {
      name         = format("%s-BACKEND-ADDRESSPOOL", upper(backend_address_pool.value.name))
      ip_addresses = backend_address_pool.value.ip_addresses
      fqdns        = backend_address_pool.value.fqdns
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificate
    content {
      name                = ssl_certificate.value.name
      data                = filebase64(ssl_certificate.value.file_name)
      password            = ssl_certificate.value.password
      key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
    }
  }


  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                                = format("%s-BACKEND-HTTP-SETTINGS", upper(backend_http_settings.value.name))
      cookie_based_affinity               = coalesce(backend_http_settings.value.cookie_based_affinity, local.defaults_app_gateway.backend_http_settings.cookie_based_affinity)
      affinity_cookie_name                = backend_http_settings.value.affinity_cookie_name
      path                                = backend_http_settings.value.path
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      host_name                           = backend_http_settings.value.host_name
      probe_name                          = try(format("%s-PROBE", uppper(backend_http_settings.value.probe_name)), null)
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
      trusted_root_certificate_names      = backend_http_settings.value.trusted_root_certificate_names

      dynamic "authentication_certificate" {
        for_each = backend_http_settings.value.authentication_certificate
        content {
          name = authentication_certificate.value
        }
      }

      dynamic "connection_draining" {
        for_each = backend_http_settings.value.connection_draining
        content {
          enabled           = connection_draining.value.enabled
          drain_timeout_sec = connection_draining.value.drain_timeout_sec

        }

      }
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_map
    content {
      name                               = format("%s-URL-PATH", upper(url_path_map.value.name))
      default_backend_http_settings_name = format("%s-BACKEND-HTTP-SETTINGS", uppper(url_path_map.value.default_backend_http_settings_name))
      default_backend_address_pool_name  = format("%s-BACKEND-ADDRESSPOOL", upper(url_path_map.value.default_backend_address_pool_name))

      dynamic "path_rule" {
        for_each = url_path_map.value.path_rule
        content {
          name                        = format("%s-PATH-RULE", uppper(path_rule.value.name))
          paths                       = path_rule.value.paths
          backend_address_pool_name   = format("%s-BACKEND-ADDRESSPOOL", upper(path_rule.value.default_backend_address_pool_name))
          backend_http_settings_name  = format("%s-BACKEND-HTTP-SETTINGS", upper(path_rule.value.default_backend_http_settings_name))
          redirect_configuration_name = format("%s-REDIRECT-CONFIG", upper(path_rule.value.redirect_configuration_name))
          rewrite_rule_set_name       = format("%s-REWRITE-RULE-SET", upper(path_rule.value.rewrite_rule_set_name))
          firewall_policy_id          = null
        }
      }
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule
    content {
      name                       = format("%s-REQ-ROUTING-RULE", upper(request_routing_rule.value.name))
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = format("%s-INTERNAL-LISTENER", upper(request_routing_rule.value.http_listener_name))
      backend_address_pool_name  = format("%s-BACKEND-ADDRESSPOOL", upper(request_routing_rule.value.backend_address_pool_name))
      backend_http_settings_name = format("%s-BACKEND-HTTP-SETTINGS", upper(request_routing_rule.value.backend_http_settings_name))
      url_path_map_name          = try(format("%s-URL-PATH", upper(request_routing_rule.value.url_path_map_name)), null)
    }
  }


  dynamic "probe" {
    for_each = var.probe
    content {
      host                                      = probe.value.host
      port                                      = probe.value.port
      name                                      = format("%s-PROBE", upper(probe.value.name))
      protocol                                  = probe.value.protocol
      path                                      = probe.value.path
      interval                                  = coalesce(probe.value.interval, local.defaults_app_gateway.probe.interval)
      timeout                                   = coalesce(probe.value.timeout, local.defaults_app_gateway.probe.timeout)
      unhealthy_threshold                       = coalesce(probe.value.unhealthy_threshold, local.defaults_app_gateway.probe.unhealthy_threshold)
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
      minimum_servers                           = probe.value.minimum_servers

      dynamic "match" {
        for_each = probe.value.match
        content {
          body        = match.value.body
          status_code = match.value.status_code
        }
      }
    }
  }


  dynamic "ssl_policy" {
    for_each = length(var.ssl_policy) == 0 ? local.defaults_app_gateway.ssl_policy : var.ssl_policy
    content {
      disabled_protocols   = ssl_policy.value.disabled_protocols
      policy_type          = ssl_policy.value.policy_type
      cipher_suites        = ssl_policy.value.cipher_suites
      min_protocol_version = ssl_policy.value.min_protocol_version
    }
  }


  dynamic "rewrite_rule_set" {
    for_each = var.rewrite_rule_set
    content {
      name = rewrite_rule_set.value.name
      dynamic "rewrite_rule" {
        for_each = rewrite_rule_set.value.rewrite_rule
        content {
          name          = rewrite_rule.value.name
          rule_sequence = rewrite_rule.value.rule_sequence

          dynamic "condition" {
            for_each = rewrite_rule.value.condition
            content {
              variable    = condition.value.variable
              pattern     = condition.value.pattern
              ignore_case = condition.value.ignore_case
              negate      = condition.value.negate
            }
          }

          dynamic "request_header_configuration" {
            for_each = rewrite_rule.value.request_header_configuration
            content {
              header_name  = request_header_configuration.value.header_name
              header_value = request_header_configuration.value.header_value
            }


          }

          dynamic "response_header_configuration" {
            for_each = rewrite_rule.value.response_header_configuration
            content {
              header_name  = response_header_configuration.value.header_name
              header_value = response_header_configuration.value.header_value

            }
          }

          dynamic "url" {
            for_each = rewrite_rule.value.url
            content {
              path         = url.value.path
              query_string = url.value.query_string
              reroute      = url.value.reroute
            }
          }
        }
      }
    }
  }



  dynamic "redirect_configuration" {
    for_each = var.redirect_configuration
    content {
      name          = redirect_configuration.value.name
      redirect_type = redirect_configuration.value.redirect_type

      target_listener_name = redirect_configuration.value.target_listener_name

      target_url = redirect_configuration.value.target_url

      include_path = redirect_configuration.value.include_path

      include_query_string = redirect_configuration.value.include_query_string
    }
  }

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration
    content {

      min_capacity = var.autoscale_configuration.value.min_capacity

      max_capacity = var.autoscale_configuration.value.max_capacity
    }
  }


}

resource "azurerm_public_ip" "pulbic_ip" {

  count               = var.sku.name == "Standard_v2" ? 1 : 0
  name                = format("%s-PUBIP", upper(var.name))
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_network_security_rule" "appgateway" {
  count                       = var.sku.name == "Standard_v2" ? length(local.nsg_rules) : 0
  name                        = format("%s-%d", upper(local.nsg_rules[count.index]["name"]), count.index)
  priority                    = format("%d%d", local.nsg_rules[count.index]["priority"], count.index)
  direction                   = local.nsg_rules[count.index]["direction"]
  access                      = "Allow"
  protocol                    = local.nsg_rules[count.index]["protocol"]
  source_port_range           = local.nsg_rules[count.index]["source_port_range"]
  destination_port_range      = local.nsg_rules[count.index]["destination_port_range"]
  source_address_prefix       = local.nsg_rules[count.index]["source_address_prefix"]
  destination_address_prefix  = local.nsg_rules[count.index]["destination_address_prefix"]
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.nsg.name
}

