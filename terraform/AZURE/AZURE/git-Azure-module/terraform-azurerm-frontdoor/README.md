# terraform-azurerm-frontdoor

## Usage
``` terraform
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
| name | (Required) Specifies the name of the Front Door service. Changing this forces a new resource to be created. | `string` | n/a | yes |
| resource\_group\_name | (Required) Specifies the name of the Resource Group in which the Front Door service should exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| tags | Tags to be attached to the policy. | `map(string)` | n/a | yes |
| backend\_pool | Name for backend pool | <pre>object({<br>    name : string<br>    host_header : string<br>    address : string<br>    http_port : number<br>    https_port : number<br>    load_balancing_name : string<br>    health_probe_name : string<br>    }<br>  )</pre> | <pre>{<br>  "address": null,<br>  "health_probe_name": null,<br>  "host_header": null,<br>  "http_port": null,<br>  "https_port": null,<br>  "load_balancing_name": null,<br>  "name": null<br>}</pre> | no |
| backend\_pool\_health\_probe | Required fields name. Setting for backend health probe. | <pre>object({<br>    name : string<br>    enabled : bool<br>    path : string<br>    protocol : string<br>    probe_method : string<br>    interval_in_seconds : number<br>  })</pre> | <pre>{<br>  "enabled": null,<br>  "interval_in_seconds": null,<br>  "name": null,<br>  "path": null,<br>  "probe_method": null,<br>  "protocol": null<br>}</pre> | no |
| backend\_pool\_load\_balancing | Required Field 'name'. Allows tuning of samples otherwise defaults are used | <pre>object({<br>    name : string<br>    sample_size : number<br>    successful_samples_required : number<br>    additional_latency_milliseconds : number<br>  })</pre> | <pre>{<br>  "additional_latency_milliseconds": null,<br>  "name": null,<br>  "sample_size": null,<br>  "successful_samples_required": null<br>}</pre> | no |
| custom\_https\_configuration | n/a | <pre>list(object({<br>    certificate_source : string<br>    azure_key_vault_certificate_secret_name : string<br>    azure_key_vault_certificate_vault_id : string<br>  }))</pre> | `[]` | no |
| custom\_https\_provisioning\_enabled | n/a | `string` | `null` | no |
| frontend\_endpoint | Required fields name, hostname: Frontend end\_point Settings | <pre>object({<br>    name : string<br>    session_affinity_ttl_seconds : number<br>  })</pre> | <pre>{<br>  "name": "fpoint1",<br>  "session_affinity_ttl_seconds": 2<br>}</pre> | no |
| routing\_rules | Required: Rules on how to match the requests | <pre>list(object({<br>    name : string<br>    accepted_protocols : list(string)<br>    patterns_to_match : list(string)<br>    frontend_endpoints : list(string)<br>    enabled : bool<br>    forwarding_configuration : list(object({<br>      forwarding_protocol : string<br>      backend_pool_name : string<br>      }<br>    ))<br>    redirect_configuration : list(object({<br>      custom_host : string<br>      redirect_protocol : string<br>      redirect_type : string<br>      custom_fragment : string<br>      custom_path : string<br>      custom_query_string : string<br>      }<br>    ))<br>  }))</pre> | <pre>[<br>  {<br>    "accepted_protocols": [],<br>    "enabled": null,<br>    "forwarding_configuration": [],<br>    "frontend_endpoints": [],<br>    "name": null,<br>    "patterns_to_match": [],<br>    "redirect_configuration": [<br>      {<br>        "custom_fragment": null,<br>        "custom_host": null,<br>        "custom_path": null,<br>        "custom_query_string": null,<br>        "redirect_protocol": "MatchRequest",<br>        "redirect_type": "TemporaryRedirect"<br>      }<br>    ]<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| frontdoor\_cname | The host that each frontendEndpoint must CNAME to. |
| frontdoor\_header\_frontdoor\_id | The unique ID of the Front Door which is embedded into the incoming headers X-Azure-FDID attribute and maybe used to filter traffic sent by the Front Door to your backend. |
| frontdoor\_id | The ID of the FrontDoor. |

## Release Notes

The newest published version of this module is v8.0.0.

- View the complete change log [here](./changelog.md)
