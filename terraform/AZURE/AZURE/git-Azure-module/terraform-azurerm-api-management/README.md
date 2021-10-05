# terraform-azurerm-api-management

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

module "api_management" {
  source               = "../../"
  name                 = "ngtestingapim"
  resource_group_name  = data.azurerm_resource_group.app_env_resource_group.name
  location             = data.azurerm_resource_group.app_env_resource_group.location
  publisher_name       = "pwc"
  publisher_email      = "lavanya.neruthan@pwc.com"
  sku_name             = "Developer_1"
  virtual_network_type = "None"
  certificates = [{
    b64_pfx_cert_data    = filebase64("${path.module}/mycert.pfx")
    certificate_password = "Welcome@123"
    store_name           = "Root"
    }
  ]
  hostname_config = {
    management = {
      "host_name" : "mgmt.portal.pwc.com",
      "certificate" : filebase64("${path.module}/mgmt.pfx"),
      "certificate_password" : "Welcome@123",
      "negotiate_client_certificate" : false
    }
    portal = {
      "host_name" : "portal.portal.pwc.com",
      "certificate" : filebase64("${path.module}/portal.pfx"),
      "certificate_password" : "Welcome@123",
      "negotiate_client_certificate" : false
    }
    dev_portal = {
      "host_name" : "dev.portal.pwc.com",
      "certificate" : filebase64("${path.module}/dev.pfx"),
      "certificate_password" : "Welcome@123",
      "negotiate_client_certificate" : false
    }
    scm = {
      "host_name" : "scm.portal.pwc.com",
      "certificate" : filebase64("${path.module}/scm.pfx"),
      "certificate_password" : "Welcome@123",
      "negotiate_client_certificate" : false
    }

    proxy = {
      "default_ssl_binding" : true,
      "host_name" : "proxy.portal.pwc.com",
      "certificate" : filebase64("${path.module}/proxy.pfx"),
      "certificate_password" : "Welcome@123",
      "negotiate_client_certificate" : false
    }
  }
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
| location | The location of the resource group. | `string` | n/a | yes |
| name | The name of the API Management. | `string` | n/a | yes |
| publisher\_email | The email of the publisher. | `string` | n/a | yes |
| publisher\_name | The name of the publisher. | `string` | n/a | yes |
| resource\_group\_name | Resource group name to place the resource. | `string` | n/a | yes |
| sku\_name | The name of the SKU. | `string` | n/a | yes |
| tags | The tags associated to the resource. | `map(string)` | n/a | yes |
| certificates | Certificates to associate to this api management resource. | <pre>list(object({<br>    b64_pfx_cert_data    = string,<br>    certificate_password = string,<br>    store_name           = string<br>  }))</pre> | `null` | no |
| hostname\_config | Hostname configuration object | <pre>object({<br>    management = map(string),<br>    portal     = map(string),<br>    dev_portal = map(string),<br>    scm        = map(string),<br>    proxy      = map(string)<br>  })</pre> | `null` | no |
| identity | Identity block config | <pre>list(object({<br>    type = string,<br>    ids  = list(string)<br>  }))</pre> | `[]` | no |
| subnet\_id | Subnet ID for the API Management Service to use. | `string` | `null` | no |
| virtual\_network\_type | The type of virtual network you want to use, valid values include: None, External, Internal | `string` | `"Internal"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Application Security Group. |
| name | The name of the API Management service. |
| private\_ip\_addresses | Private Static Load Balanced IP addresses of the API Management service. |
| public\_ip\_addresses | Public Static Load Balanced IP addresses of the API Management service in the additional location. Available only for Basic, Standard and Premium SKU. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
