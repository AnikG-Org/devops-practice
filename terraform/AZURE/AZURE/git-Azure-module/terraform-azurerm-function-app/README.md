# terraform-azurerm-function-app

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
  name = "PZI-GXUS-G-RGP-OOFMH-T007"

}

data "azurerm_virtual_network" "vnet" {
  name                = var.system_parameters.VNET
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = "PZI-GXUS-G-SNT-OOFMH-T015"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_storage_account" "storage_account" {
  name                = "pzigxsus2ploofmht008"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_app_service_plan" "app_plan" {
  name                = var.user_parameters.naming_service.app-service-planname.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}
module "primary_hc_app" {
  source                     = "../../"
  name                       = "appfuncname"
  location                   = data.azurerm_resource_group.app_env_resource_group.location
  resource_group_name        = data.azurerm_resource_group.app_env_resource_group.name
  app_service_plan_id        = data.azurerm_app_service_plan.app_plan.id
  app_service_plan_sku_tier  = "PremiumV2"
  storage_account_name       = data.azurerm_storage_account.storage_account.name
  storage_account_access_key = data.azurerm_storage_account.storage_account.primary_access_key
  app_settings               = {}
  tags                       = {}
  os_type                    = "linux"
  enable_builtin_logging     = false
  ip_restrictions            = [
      {
        priority  = 101
        name      = format("ALLOW_%s", data.azurerm_subnet.subnet.name)
        subnet_id = data.azurerm_subnet.subnet.id
      }
  ]
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
| app\_service\_plan\_id | The ID of the App Service Plan within which to create this Function App. | `string` | n/a | yes |
| app\_service\_plan\_sku\_tier | App Service Plan Tier: Standard, Basic, Premium, etc. | `string` | n/a | yes |
| location | Location of the resource group in which the azure function is to be deployed. | `string` | n/a | yes |
| name | Name of the azure function app to be deployed. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the Function App. | `string` | n/a | yes |
| storage\_account\_access\_key | The access key for the backend storage account used by the Function App. | `string` | n/a | yes |
| storage\_account\_name | Name of the backend storage account used by the Function App. | `string` | n/a | yes |
| tags | Map of tags to be attached to the function app. | `map(string)` | n/a | yes |
| always\_on | Should the Function App be loaded at all times? | `bool` | `true` | no |
| app\_settings | A key-value pair of App Settings. | `map(string)` | `{}` | no |
| client\_affinity\_enabled | Should the Function App send session affinity cookies, which route client requests in the same session to the same instance? | `string` | `false` | no |
| daily\_memory\_time\_quota | The amount of memory in gigabyte-seconds that your application is allowed to consume per day. Setting this value only affects function apps under the consumption plan. | `number` | `0` | no |
| enable\_builtin\_logging | Should the built-in logging of this Function App be enabled? | `bool` | `true` | no |
| enabled | Is the Function App enabled? | `bool` | `true` | no |
| ftps\_state | State of FTP / FTPS service for this function app. | `string` | `"AllAllowed"` | no |
| function\_app\_version | The runtime version associated with the Function App. | `string` | `"~3"` | no |
| http2\_enabled | Specifies whether or not the http2 protocol should be enabled. | `bool` | `false` | no |
| identity\_ids | Specifies a list of user managed identity ids to be assigned. | `list(string)` | `null` | no |
| identity\_type | Specifies the identity type of the Function App. | `string` | `"SystemAssigned"` | no |
| ip\_restrictions | A list of ip restrictions to impose on this function app. | `list(map(string))` | `null` | no |
| linux\_fx\_version | Linux App Framework and version for the AppService, e.g. DOCKER\|(golang:latest). | `string` | `null` | no |
| min\_tls\_version | The minimum supported TLS version for the function app. | `string` | `"1.2"` | no |
| os\_type | A string indicating the Operating System type for this function app. Defaults to Windows | `string` | `null` | no |
| pre\_warmed\_instance\_count | The number of pre-warmed instances for this function app. Only affects apps on the Premium plan. | `any` | `null` | no |
| use\_32\_bit\_worker\_process | Should the Function App run in 32 bit mode, rather than 64 bit mode? | `bool` | `false` | no |
| websockets\_enabled | Should WebSockets be enabled? | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| default\_hostname | The default hostname associated with the Function App |
| id | The ID of the Function App |
| identity | Contains the Managed Service Identity information for this App Service. |
| kind | The Function App Kind: functionapp, linux, container |
| outbound\_ip\_addresses | List of Outbound IP Address |
| possible\_outbound\_ip\_addresses | List of Possible Outbound IP Address |
| site\_credential | Contains the site-level credentials used to publish to this App Service. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
