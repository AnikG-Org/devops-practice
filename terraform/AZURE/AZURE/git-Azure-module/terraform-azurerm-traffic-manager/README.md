# terraform-azurerm-traffic-manager

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

module "traffic-manager" {
  source                 = "../../"
  name                   = var.user_parameters.naming_service.traffic_manager.k01
  resource_group_name    = data.azurerm_resource_group.app_env_resource_group.name
  traffic_routing_method = "Priority"
  relative_name          = "test-traffic"
  ttl                    = 60 
  protocol               = "https"
  port                   = 443
  path                   = "/"
  interval_in_seconds    = 30
  timeout_in_seconds     = 10
  tolerated_failures     = 3
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
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| interval\_in\_seconds | Interval in seconds | `string` | n/a | yes |
| name | Name of the traffic manager to be created. | `string` | n/a | yes |
| relative\_name | The relative domain name,this is combined with the domain name used by Traffic Manager to form the FQDN which is exported as documented below. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the Traffic Manager. | `string` | n/a | yes |
| tags | Map of tags to be attached to the resource group. | `map(string)` | n/a | yes |
| timeout\_in\_seconds | Timeout in seconds | `string` | n/a | yes |
| tolerated\_failures | Tolerated failures | `string` | n/a | yes |
| path | The path used by the monitoring checks. Required when protocol is set to HTTP or HTTPS - cannot be set when protocol is set to TCP. | `string` | `"/"` | no |
| port | The port number used by the monitoring checks. | `string` | `"80"` | no |
| protocol | The protocol used by the monitoring checks, supported values are HTTP, HTTPS and TCP. | `string` | `"http"` | no |
| traffic\_routing\_method | Specifies the algorithm used to route traffic, possible values are,Geographic - Traffic is routed based on Geographic regions specified in the Endpoint. | `string` | `"Weighted"` | no |
| ttl | The TTL value of the Profile used by Local DNS resolvers and clients. | `string` | `"100"` | no |

## Outputs

| Name | Description |
|------|-------------|
| fqdn | The FQDN of the created Profile. |
| id | ID of the resource group which is created. |
| name | Name of the resource group which is created. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
