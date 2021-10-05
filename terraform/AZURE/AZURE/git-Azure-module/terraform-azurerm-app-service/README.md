# terraform-azurerm-app-service

## Usage
``` terraform

data "azurerm_virtual_network" "vnet" {
  name                = var.system_parameters.VNET
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = element(data.azurerm_virtual_network.vnet.subnets, 0)
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_app_service_plan" "app_plan" {
  name                = "search-app-service-plan"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}


module "app_service" {
  source = "../../"
  # insert required variables here
  resource_group_name = var.__ghs.environment_resource_groups
  location            = var.__ghs.environment_hosting_region
  name                = var.user_parameters.naming_service.app_service.a01
  app_service_plan_id = data.azurerm_app_service_plan.app_plan.id
  app_settings = {
    "ENVIRONMENT" = "DEV"
  }
  scm_type                = "VSTSRM"
  client_affinity_enabled = true
  default_documents       = ["Default.htm", "Default.html"]
  cors = [{
    allowed_origins : ["uk.pwc.com"]
    support_credentials : false
  }]
  ip_restrictions  =  [
      {
        priority  = 101
        name      = "ACL_RULE_NAME"
        ip_address = "13.234.188.64/32"
      },
      {
        priority  = 102
        name      = "ALLOW_AZURE_FRONTDOOR"
        service_tag= "AzureFrontDoor.Backend"
      },
      {
        priority  = 103
        name      = "SUBNET_NAME"
        subnet_id = data.azurerm_subnet.subnet.id
      },
    ]
  linux_fx_version = "app_image_name"
  tags = local.tags
}

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
  vnet_resource_group_name = replace(var.system_parameters.VNET, "-VNT-", "-RGP-BASE-")
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
| app\_service\_plan\_id | The ID of the App Service Plan within which to create this App service. | `string` | n/a | yes |
| location | Location of the resource group in which the azure app service is to be deployed. | `string` | n/a | yes |
| name | Name of the azure app service to be deployed. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the App service. | `string` | n/a | yes |
| tags | Map of tags to be attached to the app service. | `map(string)` | n/a | yes |
| always\_on | Should the App service be loaded at all times? | `bool` | `true` | no |
| app\_command\_line | App command line to launch, e.g. /sbin/myserver -b 0.0.0.0. | `string` | `null` | no |
| app\_settings | A key-value pair of App Settings. | `map(string)` | `{}` | no |
| client\_affinity\_enabled | Should the App service send session affinity cookies, which route client requests in the same session to the same instance? | `string` | `false` | no |
| client\_cert\_enabled | Does the App Service require client certificates for incoming requests? | `bool` | `false` | no |
| cors | A list of CORS to impose on this app service | <pre>list(object({<br>    allowed_origins     = list(string),<br>    support_credentials = bool<br>  }))</pre> | `null` | no |
| custom\_certificates | Certificate Settings | <pre>list(object({<br>    name      = string<br>    pfx_blob  = string<br>    password  = string<br>    ssl_state = string # IpBasedEnabled and SniEnabled<br>  }))</pre> | `[]` | no |
| custom\_domains | The custom hostname to use for the App Service | `list(string)` | `[]` | no |
| custom\_managed\_domains | The hostname to use for the App Service with azure managed certificate | `list(string)` | `[]` | no |
| custom\_no\_cert\_domains | The hostname to use for the App Service without SSL certificate | `list(string)` | `[]` | no |
| default\_documents | The ordering of default documents to load, if an address isn't specified. | `list(string)` | `null` | no |
| dotnet\_framework\_version | The version of the .net framework's CLR used in this App Service. | `string` | `"v4.0"` | no |
| enabled | Is the App service enabled? | `bool` | `true` | no |
| ftps\_state | State of FTP / FTPS service for this function app. | `string` | `"AllAllowed"` | no |
| health\_check\_path | The health check path to be pinged by App Service. | `string` | `null` | no |
| http2\_enabled | Specifies whether or not the http2 protocol should be enabled. | `bool` | `false` | no |
| identity\_ids | Specifies a list of user managed identity ids to be assigned. | `list(string)` | `null` | no |
| identity\_type | Specifies the identity type of the App service. | `string` | `"SystemAssigned"` | no |
| ip\_restrictions | A list of ip restrictions to impose on this app service | `list(map(string))` | `null` | no |
| java\_container | The Java Container to use. If specified java\_version and java\_container\_version must also be specified. | `string` | `null` | no |
| java\_container\_version | The version of the Java Container to use. If specified java\_version and java\_container must also be specified. | `string` | `null` | no |
| java\_version | The version of Java to use. If specified java\_container and java\_container\_version must also be specified. | `string` | `null` | no |
| linux\_fx\_version | Linux App Framework and version for the AppService, e.g. DOCKER\|(golang:latest). | `string` | `null` | no |
| local\_mysql\_enabled | Is MySQL In App Enabled? This runs a local MySQL instance with your app and shares resources from the App Service plan. | `bool` | `null` | no |
| managed\_pipeline\_mode | The Managed Pipeline Mode. | `string` | `"Integrated"` | no |
| min\_tls\_version | The minimum supported TLS version for the app service. | `string` | `"1.2"` | no |
| php\_version | The version of PHP to use in this App Service. | `string` | `null` | no |
| python\_version | The version of Python to use in this App Service. | `string` | `null` | no |
| remote\_debugging\_enabled | Is Remote Debugging Enabled? | `bool` | `false` | no |
| scm\_type | The type of Source Control used by the App service. | `string` | `"None"` | no |
| storage | Configuration options for storage. | <pre>list(object({<br>    storage_name               = string,<br>    storage_share_name         = string,<br>    storage_mount_path         = string,<br>    storage_account_name       = string,<br>    storage_account_type       = string,<br>    storage_account_access_key = string<br>    }<br>  ))</pre> | `[]` | no |
| use\_32\_bit\_worker\_process | Should the App service run in 32 bit mode, rather than 64 bit mode? | `bool` | `false` | no |
| websockets\_enabled | Should WebSockets be enabled? | `bool` | `false` | no |
| windows\_fx\_version | The Windows Docker container image (DOCKER\|<user/image:tag>) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| azurerm\_app\_service\_certificate\_expiration\_date | The App Service certificate expiration date. |
| azurerm\_app\_service\_certificate\_ids | The App Service certificate ids. |
| azurerm\_app\_service\_certificate\_issue\_date | The App Service certificate issue date. |
| azurerm\_app\_service\_certificate\_thumbprint | The thumbprint for the certificate. |
| azurerm\_app\_service\_custom\_hostname\_binding\_id | The ID of the App Service Custom Hostname Binding |
| azurerm\_app\_service\_custom\_hostname\_binding\_virtual\_ip | The virtual IP address assigned to the hostname if IP based SSL is enabled |
| custom\_domain\_verification\_id | An identifier used by App Service to perform domain ownership verification via DNS TXT record. |
| default\_site\_hostname | The default hostname associated with the App Service. |
| id | The ID of the App Service. |
| identity | Contains the Managed Service Identity information for this App Service. |
| outbound\_ip\_addresses | List of Outbound IP Address |
| possible\_outbound\_ip\_addresses | List of Possible Outbound IP Address |
| site\_credential | Contains the site-level credentials used to publish to this App Service. |

## Release Notes

The newest published version of this module is v8.1.0.

- View the complete change log [here](./changelog.md)
