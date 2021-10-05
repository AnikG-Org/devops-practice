# terraform-azurerm-appgateway

## Usage
``` terraform
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
| backend\_address\_pool | n/a | <pre>list(object({<br>    name : string<br>    ip_addresses : list(string)<br>    fqdns : list(string)<br>  }))</pre> | n/a | yes |
| backend\_http\_settings | n/a | <pre>list(object({<br>    name : string<br>    cookie_based_affinity : string<br>    affinity_cookie_name : string<br>    path : string<br>    port : number<br>    protocol : string<br>    request_timeout : number<br>    host_name : string<br>    probe_name : string<br>    pick_host_name_from_backend_address : bool<br>    trusted_root_certificate_names : list(string)<br>    authentication_certificate : list(string)<br><br>    connection_draining : list(object({<br>      enabled : bool<br>      drain_timeout_sec : number<br>    }))<br>  }))</pre> | n/a | yes |
| frontend\_ip\_configuration | n/a | <pre>list(object({<br>    name : string<br>    subnet_id : string<br>    private_ip_address : string<br>    private_ip_address_allocation : string<br>  }))</pre> | n/a | yes |
| frontend\_port | Frontend port number for application gateway | `list(number)` | n/a | yes |
| http\_listener | n/a | <pre>list(object({<br>    name : string<br>    frontend_ip_configuration_name : string<br>    port : number<br>    host_name : string<br>    host_names : list(string)<br>    protocol : string<br>    require_sni : bool<br>    ssl_certificate_name : string<br>    custom_error_configuration : list(object({<br>      status_code : string<br>      custom_error_page_url : string<br>    }))<br>  }))</pre> | n/a | yes |
| location | The Azure region where the ASG is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | n/a | yes |
| name | Name for azure application gateway | `string` | n/a | yes |
| request\_routing\_rule | n/a | <pre>list(object({<br>    name : string<br>    rule_type : string<br>    http_listener_name : string<br>    backend_address_pool_name : string<br>    backend_http_settings_name : string<br>    url_path_map_name : string<br>  }))</pre> | n/a | yes |
| resource\_group\_name | Resource group name in which the application gateway is to be created | `string` | n/a | yes |
| sku | n/a | <pre>object({<br>    name : string<br>    tier : string<br>    capacity : number<br>  })</pre> | n/a | yes |
| subnet\_id | Subnet ID in which application gateway must be created. | `any` | n/a | yes |
| tags | Map of tags to be attached to the app service. | `map(string)` | n/a | yes |
| autoscale\_configuration | n/a | <pre>list(object({<br><br>    min_capacity : number<br><br>    max_capacity : number<br>  }))</pre> | `[]` | no |
| nsg | n/a | <pre>object({<br>    name : string<br>    priority_inbound_prefix : number<br>    priority_outbound_prefix : number<br><br>  })</pre> | <pre>{<br>  "name": "change_me",<br>  "priority_inbound_prefix": 27,<br>  "priority_outbound_prefix": 30<br>}</pre> | no |
| probe | n/a | <pre>list(object({<br>    name : string<br>    host : string<br>    port : number<br>    protocol : string<br>    path : string<br>    interval : number<br>    timeout : number<br>    unhealthy_threshold : number<br>    pick_host_name_from_backend_http_settings : bool<br>    minimum_servers : number<br><br>    match : list(object({<br>      body : string<br>      status_code : list(number)<br>    }))<br>  }))</pre> | `[]` | no |
| redirect\_configuration | n/a | <pre>list(object({<br>    name : string<br>    redirect_type : string<br><br>    target_listener_name : string<br><br>    target_url : string<br><br>    include_path : string<br><br>    include_query_string : string<br>  }))</pre> | `[]` | no |
| rewrite\_rule\_set | n/a | <pre>list(object({<br>    name : string<br>    rewrite_rule : list(object({<br>      name : string<br>      rule_sequence : number<br><br>      condition : list(object({<br>        variable : string<br>        pattern : string<br>        ignore_case : bool<br>        negate : bool<br>      }))<br><br>      request_header_configuration : list(object({<br>        header_name : string<br>        header_value = string<br>      }))<br><br>      response_header_configuration : list(object({<br>        header_name : string<br>        header_value : string<br>      }))<br><br>      url : list(object({<br>        path : string<br>        query_string : string<br>        reroute : bool<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| ssl\_certificate | n/a | <pre>list(object({<br>    name : string<br>    file_name : string<br>    password : string<br>    key_vault_secret_id : string<br>  }))</pre> | `[]` | no |
| ssl\_policy | n/a | <pre>list(object({<br>    disabled_protocols : list(string)<br>    policy_type : string<br>    cipher_suites : list(string)<br>    min_protocol_version : string<br>  }))</pre> | `[]` | no |
| url\_path\_map | n/a | <pre>list(object({<br>    name : string<br>    default_backend_http_settings_name : string<br>    default_backend_address_pool_name : string<br>    path_rule : list(object({<br>      name : string<br>      paths : list(string)<br>      backend_address_pool_name : string<br>      backend_http_settings_name : string<br>      redirect_configuration_name : string<br>      rewrite_rule_set_name : string<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| backend\_address\_pool\_id | n/a |
| id | # Output variables |
| public\_ip | n/a |

## Release Notes

The newest published version of this module is v8.0.0.

- View the complete change log [here](./changelog.md)
