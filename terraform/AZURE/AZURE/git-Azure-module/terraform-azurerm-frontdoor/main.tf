locals {

  defaults_frontdoor = {
    backend_pool_health_probe_name : "default-health-probe"
    frontend_endpoint_name : "default-frontend-endpoint"
    frontend_hostname : "www.bing.com"
    routing_rules_name : "default-rule"
    backend_pool_load_balancing_name : "default-backend-pool-lb"
    backend_pool_name : "default-backend-pool"
    forwarding_configuration : [{
      forwarding_protocol : "HttpsOnly"
      backend_pool_name : "default-backend-pool"
    }]
    custom_https_provisioning_enabled : true

  }
}

resource "azurerm_frontdoor" "frontdoor" {
  name                                         = var.name
  resource_group_name                          = var.resource_group_name
  enforce_backend_pools_certificate_name_check = false

  dynamic "routing_rule" {
    for_each = var.routing_rules
    content {
      name               = coalesce(routing_rule.value.name, local.defaults_frontdoor.routing_rules_name)
      accepted_protocols = length(routing_rule.value.accepted_protocols) == 0 ? ["Http"] : routing_rule.value.accepted_protocols
      patterns_to_match  = length(routing_rule.value.patterns_to_match) == 0 ? ["/*"] : routing_rule.value.patterns_to_match
      frontend_endpoints = length(routing_rule.value.frontend_endpoints) == 0 ? [local.defaults_frontdoor.frontend_endpoint_name] : routing_rule.value.frontend_endpoints
      enabled            = routing_rule.value.enabled
      dynamic "forwarding_configuration" {
        for_each = length(routing_rule.value.forwarding_configuration) == 0 && length(routing_rule.value.redirect_configuration) == 0 ? local.defaults_frontdoor.forwarding_configuration : routing_rule.value.forwarding_configuration
        content {
          forwarding_protocol = forwarding_configuration.value.forwarding_protocol
          backend_pool_name   = forwarding_configuration.value.backend_pool_name
        }
      }
      dynamic "redirect_configuration" {
        for_each = routing_rule.value.redirect_configuration
        content {
          custom_host         = redirect_configuration.value.custom_host
          redirect_protocol   = redirect_configuration.value.redirect_protocol
          redirect_type       = redirect_configuration.value.redirect_type
          custom_fragment     = redirect_configuration.value.custom_fragment
          custom_path         = redirect_configuration.value.custom_path
          custom_query_string = redirect_configuration.value.custom_query_string
        }
      }
    }
  }
  backend_pool_load_balancing {
    name                            = coalesce(var.backend_pool_load_balancing.name, local.defaults_frontdoor.backend_pool_load_balancing_name)
    sample_size                     = try(var.backend_pool_load_balancing.sample_size, null)
    successful_samples_required     = try(var.backend_pool_load_balancing.successful_samples_required, null)
    additional_latency_milliseconds = try(var.backend_pool_load_balancing.additional_latency_milliseconds, null)
  }
  backend_pool_health_probe {
    name                = coalesce(var.backend_pool_health_probe.name, local.defaults_frontdoor.backend_pool_health_probe_name)
    enabled             = try(var.backend_pool_health_probe.enabled, null)
    path                = try(var.backend_pool_health_probe.path, null)
    protocol            = try(var.backend_pool_health_probe.protocol, null)
    probe_method        = try(var.backend_pool_health_probe.probe_method, null)
    interval_in_seconds = try(var.backend_pool_health_probe.interval_in_seconds, null)
  }
  backend_pool {
    name = coalesce(var.backend_pool.name, local.defaults_frontdoor.backend_pool_name)
    backend {
      host_header = coalesce(var.backend_pool.host_header, "www.bing.com")
      address     = coalesce(var.backend_pool.address, "www.bing.com")
      http_port   = coalesce(var.backend_pool.http_port, 80)
      https_port  = coalesce(var.backend_pool.https_port, 443)
    }
    load_balancing_name = coalesce(var.backend_pool.load_balancing_name, local.defaults_frontdoor.backend_pool_load_balancing_name)
    health_probe_name   = coalesce(var.backend_pool.health_probe_name, local.defaults_frontdoor.backend_pool_health_probe_name)
  }
  frontend_endpoint {
    name                                    = coalesce(var.frontend_endpoint.name, local.defaults_frontdoor.frontend_endpoint_name)
    host_name                               = format("%s%s", var.name, ".azurefd.net")
    web_application_firewall_policy_link_id = null # This disables Frontend WAF
    session_affinity_ttl_seconds            = var.frontend_endpoint.session_affinity_ttl_seconds
  }
  tags = var.tags

}

resource "azurerm_frontdoor_custom_https_configuration" "custom_https_configuration" {
  frontend_endpoint_id              = azurerm_frontdoor.frontdoor.frontend_endpoints[coalesce(var.frontend_endpoint.name, local.defaults_frontdoor.frontend_endpoint_name)]
  custom_https_provisioning_enabled = local.defaults_frontdoor.custom_https_provisioning_enabled
  dynamic "custom_https_configuration" {
    for_each = var.custom_https_configuration
    content {
      certificate_source                      = custom_https_configuration.value.certificate_source
      azure_key_vault_certificate_vault_id    = custom_https_configuration.value.azure_key_vault_certificate_vault_id
      azure_key_vault_certificate_secret_name = custom_https_configuration.value.azure_key_vault_certificate_secret_name
    }
  }
}