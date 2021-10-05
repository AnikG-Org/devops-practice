# terraform-azurerm-appgateway-basic

## Usage
``` terraform
locals {
  vnet_resource_group_name = replace(var.system_parameters.VNET, "-VNT-", "-RGP-BASE-")
  app_gateway_name         = var.user_parameters.naming_service.app_gateway.ag03
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

data "azurerm_subnet" "subnet" {
  name                 = "PZI-GXUS-N-SNT-AWOCP-D002"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

module "app_gateway" {
  source              = "../../"
  name                = local.app_gateway_name
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  location            = var.__ghs.environment_hosting_region
  sku_capacity        = 2
  subnet_id           = data.azurerm_subnet.subnet.id
  private_ip_address  = "10.195.251.166"
  sku_name            = "Standard_Small"
  tier                = "Standard"

  ssl_certificates = [{
    "ssl_name" : "example_1" # <Ssl name>
    "ssl_password" : ""
    "data" : "certi.pfx" # < First ssl certificate>
    },
    {
      "ssl_name" : "example_2" # <Ssl name>
      "ssl_password" : ""
      "data" : "certificate2.pfx" # < Second ssl certificate>

  }]

  backend_address_pools = [{
    "name" : "appGatewayBackendPool1", # <First Backend Address Pool Name>
    "ip_addresses" : ["10.0.0.34", "10.0.0.35"]
    "fqdns" : ["vm1.abc-fake.me", "vm2.abc-fake.me"]
    },
    {
      "name" : "appGatewayBackendPool2", # <First Backend Address Pool Name>
      "ip_addresses" : ["10.0.0.36", "10.0.0.37"]
      "fqdns" : ["vm3.abc-fake.me", "vm4.abc-fake.me"]
    }
  ]

  # List of Authentication certificates to add in backend http settings
  auth_cert = [{
    "authentication_certificate_name" : "firstcert"     # <First Certificate Name>
    "authentication_certificate_data" : "certificate.crt" # <First Certificate File>
    },
    {
      "authentication_certificate_name" : "Secondcert"    # <Second Certificate Name>
      "authentication_certificate_data" : "second.crt" # <Second Certificate File>
    }
  ]

  # Enabling Multiple Http settings with protocols
  backend_http_settings = [{
    "name" : "HTTPS_connector" # <First Http settings Name>
    "cookie_based_affinity" : "Enabled"
    "backend_http_port" : "443"
    "backend_http_protocol" : "Https"
    "backend_request_timeout_in_seconds" : "30"
    "probe_name" : "static-website-probe"
    "host_name" : "fake1.example.com"
    "pick_host_name_from_backend_address" : false
    },
    {
      "name" : "appGatewayBackendHttpSettings"
      "cookie_based_affinity" : "Enabled"
      "backend_http_port" : "443"
      "backend_http_protocol" : "Https"
      "backend_request_timeout_in_seconds" : "30"
      "probe_name" : "static-website-probe"
      "host_name" : "fake2.example.com"
      "pick_host_name_from_backend_address" : false
    }
  ]

  # List of Frontend Ports to attach with listeners
  frontend_ports = [{
    "name" : "appGatewayFrontendIP" # <First Frontend port Name>
    "port" : "80"

    },
    {
      "name" : "appGatewayFrontendIP1" # <Second Frontend port Name>
      "port" : "443"
    }
  ]

  # List of http listeners
  listener = [{
    "name" : "appGatewayHttpListener1" # <First Listeners Name>
    "frontend_ip_configuration_name" : join("", [local.app_gateway_name, "-FRONTEND-IPCONFIG"])
    "frontend_port_name" : "appGatewayFrontendIP"
    "protocol" : "Http"
    "ssl_certificate_name" : ""
    "host_name" : ""
    },
    {
      "name" : "appGatewayHttpListener2" # <Second Listeners Name>
      "frontend_ip_configuration_name" : join("", [local.app_gateway_name, "-FRONTEND-IPCONFIG"])
      "frontend_port_name" : "appGatewayFrontendIP1"
      "protocol" : "Https"
      "ssl_certificate_name" : "example_1"
      "host_name" : ""
    }
  ]

  # List of Routing rules
  routing_rule = [{
    "name" : "rule1" #<First Routing Rule Name>
    "http_listener_name" : "appGatewayHttpListener1"
    "backend_address_pool_name" : "appGatewayBackendPool1"
    "backend_http_settings_name" : "HTTPS_connector"
    "url_path_map_name" : join("", [local.app_gateway_name, "-URL-PATH"])
    },
    {
      "name" : "rule2" #<Second Routing Rule Name>
      "http_listener_name" : "appGatewayHttpListener2"
      "backend_address_pool_name" : "appGatewayBackendPool2"
      "backend_http_settings_name" : "appGatewayBackendHttpSettings"
      "url_path_map_name" : join("", [local.app_gateway_name, "-URL-PATH1"])
    }
  ]

url_path_map = [
    {
      "name"         :  join("", [local.app_gateway_name, "-URL-PATH"])
      "default_backend_address_pool_name"  : "appGatewayBackendPool1"
      "default_backend_http_settings_name" : "HTTPS_connector"
      "default_redirect_configuration_name" : null
      path_rule = [
        {
          "path_rule_name" :             "api"
          "backend_address_pool_name" : "appGatewayBackendPool1"
          "backend_http_settings_name" : "HTTPS_connector"
          "paths"                 :     ["/api/*"]
        }
      ]
},
{
      "name"         :  join("", [local.app_gateway_name, "-URL-PATH1"])
      "default_backend_address_pool_name"  : "appGatewayBackendPool2"
      "default_backend_http_settings_name" : "appGatewayBackendHttpSettings"
      "default_redirect_configuration_name" : null
      path_rule = [
        {
          "path_rule_name" :             "api1"
          "backend_address_pool_name" : "appGatewayBackendPool2"
          "backend_http_settings_name" : "appGatewayBackendHttpSettings"
          "paths"                 :     ["/api/*"]
        }
      ]
    }
  ]

  probe = [
    {
      name                                      = "static-website-probe"
      protocol                                  = "Https"
      path                                      = "/"
      interval                                  = 10
      timeout                                   = 10
      unhealthy_threshold                       = 10
      port                                      = null
      pick_host_name_from_backend_http_settings = true
      body                                      = null
      status_code                               = null
    }
  ]
  tags = local.tags
}

```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14 |
| terraform | >= 0.14 |
| azurerm | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auth\_cert | Authentication Certificate Configurations | <pre>list(object({<br>    authentication_certificate_name = string<br>    authentication_certificate_data = string<br>    }<br>  ))</pre> | n/a | yes |
| backend\_address\_pools | Backend Address Pool Configurations | <pre>list(object({<br>    name         = string<br>    ip_addresses = list(string)<br>    fqdns        = list(string)<br>    }<br>  ))</pre> | n/a | yes |
| backend\_http\_settings | Backend HTTP Configurations | <pre>list(object({<br>    name                                = string<br>    cookie_based_affinity               = string<br>    backend_http_port                   = number<br>    backend_http_protocol               = string<br>    backend_request_timeout_in_seconds  = number<br>    host_name                           = string<br>    probe_name                          = string<br>    pick_host_name_from_backend_address = bool<br>    }<br>  ))</pre> | n/a | yes |
| frontend\_ports | Frontend Ports Configurations | <pre>list(object({<br>    name = string<br>    port = number<br>    }<br>  ))</pre> | n/a | yes |
| listener | HTTP Listener Configurations | <pre>list(object({<br>    name                           = string<br>    frontend_ip_configuration_name = string<br>    frontend_port_name             = string<br>    protocol                       = string<br>    ssl_certificate_name           = string<br>    host_name                      = string<br>  }))</pre> | n/a | yes |
| location | The Azure region where the Application Gateway is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | n/a | yes |
| name | Name for azure application gateway | `string` | n/a | yes |
| private\_ip\_address | The Private IP Address to use for the Application Gateway | `string` | n/a | yes |
| resource\_group\_name | Resource group name in which the application gateway is to be created | `string` | n/a | yes |
| routing\_rule | Routing Rules | <pre>list(object({<br>    name                       = string<br>    http_listener_name         = string<br>    backend_address_pool_name  = string<br>    backend_http_settings_name = string<br>    url_path_map_name          = string<br>    }<br>  ))</pre> | n/a | yes |
| sku\_capacity | SKU capacity for application gateway | `string` | n/a | yes |
| ssl\_certificates | SSL Certicate Configurations | <pre>list(object({<br>    ssl_name     = string<br>    data         = string<br>    ssl_password = string<br>  }))</pre> | n/a | yes |
| subnet\_id | Subnet ID in which application gateway must be created. | `string` | n/a | yes |
| tags | Tags to be attached to application gateway | `map` | n/a | yes |
| match | The blocks of match code | <pre>list(object({<br>    healthprobe_match_response_body = list(string)<br>    healthprobe_match_statuscodes   = list(string)<br>  }))</pre> | `[]` | no |
| private\_ip\_address\_allocation | Private IP address allocation (Static/Dynamic) | `string` | `"Dynamic"` | no |
| probe | Probe Settings | <pre>list(object({<br>    name                                      = string<br>    protocol                                  = string<br>    path                                      = string<br>    interval                                  = number<br>    timeout                                   = number<br>    unhealthy_threshold                       = number<br>    port                                      = number<br>    pick_host_name_from_backend_http_settings = bool<br>    body                                      = string<br>    status_code                               = list(string)<br>    }<br>  ))</pre> | `[]` | no |
| sku\_name | The Name of the SKU to use for this Application Gateway. Possible values are Standard\_Small, Standard\_Medium, Standard\_Large, Standard\_v2, WAF\_Medium, WAF\_Large, and WAF\_v2. | `string` | `"Standard_v2"` | no |
| tier | The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard\_v2, WAF and WAF\_v2. | `string` | `"Standard_v2"` | no |
| url\_path\_map | n/a | <pre>list(object({<br>    name : string<br>    default_backend_http_settings_name : string<br>    default_backend_address_pool_name : string<br>    default_redirect_configuration_name : string<br>    path_rule : list(object({<br>      path_rule_name : string<br>      paths : list(string)<br>      backend_address_pool_name : string<br>      backend_http_settings_name : string<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| application\_gateways\_all | n/a |
| backend\_address\_pool\_id | n/a |
| id | n/a |

## Release Notes

The newest published version of this module is v10.1.0.

- View the complete change log [here](./changelog.md)
