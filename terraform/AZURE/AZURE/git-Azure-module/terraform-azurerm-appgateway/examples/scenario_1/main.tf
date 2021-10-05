locals {
  vnet_resource_group_name = replace(var.system_parameters.VNET, "N-VNT", "N-RGP-BASE")
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

data "azurerm_virtual_network" "vnet" {
  name                = var.system_parameters.VNET
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "appgw" {
  name                 = "PZI-GXUS-N-SNT-WHABV-D015"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

module "app_gateway" {
  source              = "../../"
  location            = data.azurerm_resource_group.app_env_resource_group.location
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  tags                = local.tags
  name                = var.user_parameters.naming_service.app_gateway.av202
  sku = {
    name : "Standard_Medium"
    tier : "Standard"
    capacity : 1
  }
  subnet_id = data.azurerm_subnet.appgw.id

  frontend_port = [80, 8080]

  http_listener = [{
    name : "test"
    frontend_ip_configuration_name : "test"
    port : 80
    protocol : "Http"
    host_name : null
    host_names : []
    require_sni : null
    ssl_certificate_name : null
    custom_error_configuration : []
    }, {
    name : "test2"
    frontend_ip_configuration_name : "test"
    port : 8080
    protocol : "Http"
    host_name : null
    host_names : []
    require_sni : null
    ssl_certificate_name : null
    custom_error_configuration : []
    }
  ]

  frontend_ip_configuration = [
    {
      name : "test"
      subnet_id : data.azurerm_subnet.appgw.id
      private_ip_address : "10.204.71.37"
      private_ip_address_allocation : "Static"
    }

  ]
  backend_address_pool = [{
    name : "test"
    ip_addresses : []
    fqdns : ["www.bing.com"]
  }]

  backend_http_settings = [{
    name : "test"
    cookie_based_affinity : null
    affinity_cookie_name : null
    path : "/"
    port : "80"
    protocol : "http"
    request_timeout : null
    host_name : null
    probe_name : null
    pick_host_name_from_backend_address : true
    trusted_root_certificate_names : []
    authentication_certificate : []

    connection_draining : []
  }]

  request_routing_rule = [
    {
      name : "test"
      rule_type : "Basic"
      http_listener_name : "test"
      backend_address_pool_name : "test"
      backend_http_settings_name : "test"
      url_path_map_name : null
    },
    {
      name : "test2"
      rule_type : "Basic"
      http_listener_name : "test2"
      backend_address_pool_name : "test"
      backend_http_settings_name : "test"
      url_path_map_name : null
    }

  ]

  nsg = {
    name : "PZI-GXUS-N-NSG-WHABV-D015"
    priority_inbound_prefix : 27
    priority_outbound_prefix : 30
  }

}

