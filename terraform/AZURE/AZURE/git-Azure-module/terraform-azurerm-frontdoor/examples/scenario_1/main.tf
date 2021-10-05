locals {
  tags = {
    "ghs-los" : var.system_parameters.TAGS.ghs-los,
    "ghs-solution" : var.system_parameters.TAGS.ghs-solution,
    "ghs-appid" : var.system_parameters.TAGS.ghs-appid,
    "ghs-solutionexposure" : var.system_parameters.TAGS.ghs-solutionexposure,
    "ghs-serviceoffering" : var.system_parameters.TAGS.ghs-serviceoffering,
    "ghs-environment" : var.system_parameters.TAGS.ghs-environment,
    "ghs-owner" : var.system_parameters.TAGS.ghs-owner,
    "ghs-apptioid" : var.system_parameters.TAGS.ghs-apptioid,
    "ghs-envid" : var.system_parameters.TAGS.ghs-envid,
    "ghs-tariff" : var.system_parameters.TAGS.ghs-tariff,
    "ghs-srid" : var.system_parameters.TAGS.ghs-srid,
    "ghs-environmenttype" : var.system_parameters.TAGS.ghs-environmenttype,
    "ghs-deployedby" : var.system_parameters.TAGS.ghs-deployedby,
    "ghs-dataclassification" : var.system_parameters.TAGS.ghs-dataclassification
  }
}

data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

module "frontdoor" {
  source              = "../../"
  name                = "ngcfrontendtestln"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  routing_rules = [{
    name                     = "default-rule"
    accepted_protocols       = ["Https"]
    patterns_to_match        = ["/*"]
    frontend_endpoints       = ["fpoint1"]
    enabled                  = true
    forwarding_configuration = []
    redirect_configuration = [{
      custom_host         = null
      redirect_protocol   = "HttpOnly"
      redirect_type       = "Found"
      custom_fragment     = null
      custom_path         = null
      custom_query_string = null
    }]
  }]
  backend_pool_load_balancing = {
    name                            = "b-end-load-1"
    sample_size                     = null
    successful_samples_required     = null
    additional_latency_milliseconds = null
  }

  backend_pool = {
    name                = "exampleBackendBing"
    host_header         = "www.bing.com"
    address             = "www.bing.com"
    http_port           = 80
    https_port          = 443
    load_balancing_name = "b-end-load-1"
    health_probe_name   = "b-probe-name-1"
  }
  frontend_endpoint = {
    name                         = "fpoint1"
    session_affinity_ttl_seconds = null
  }
  backend_pool_health_probe = {
    name                = "b-probe-name-1"
    enabled             = true
    path                = null
    protocol            = null
    probe_method        = null
    interval_in_seconds = null
  }
  custom_https_provisioning_enabled = true
  custom_https_configuration = [{
    certificate_source                      = null
    azure_key_vault_certificate_secret_name = null
    azure_key_vault_certificate_vault_id    = null
  }]
  tags = local.tags
}