# terraform-azurerm-keyvault

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

data "azurerm_subnet" "subnet" {
  name                 = "PZI-GXUS-N-SNT-AEVOP-D078"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}


data "azurerm_client_config" "current" {}

module "keyvault" {
  source              = "../../"
  location            = data.azurerm_resource_group.app_env_resource_group.location
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  name                = var.user_parameters.naming_service.key_vault.k01
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled  = true
  access_policies = [{
    tenant_id               = data.azurerm_client_config.current.tenant_id
    object_id               = data.azurerm_client_config.current.object_id
    key_permissions         = ["create","get","purge","recover","delete"]
    secret_permissions      = ["get"]
    certificate_permissions = ["get"]
    }
  ]
  network_acls = [
    {
      default_action             = "Deny"
      bypass                     = "AzureServices"
      ip_rules                   = ["172.2.0.0"]
      virtual_network_subnet_ids = [data.azurerm_subnet.subnet.id]
    }
  ]
  tfe_hostname = "https://global.tfe.pwcinternal.com"
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
| location | Specify the supported Azure location where the resource exists. | `string` | n/a | yes |
| name | Specifies the name of the Key Vault. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the Key Vault. | `string` | n/a | yes |
| tags | A map of tags to be assigned to KeyVault. | `map(string)` | n/a | yes |
| tenant\_id | The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. | `string` | n/a | yes |
| access\_policies | Access policy objects for associating to the Azure Key Vault | <pre>list(object({<br>    tenant_id               = string,<br>    object_id               = string,<br>    key_permissions         = list(string),<br>    secret_permissions      = list(string),<br>    certificate_permissions = list(string)<br>  }))</pre> | `[]` | no |
| enabled\_for\_deployment | Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. | `bool` | `false` | no |
| enabled\_for\_disk\_encryption | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false. | `bool` | `false` | no |
| enabled\_for\_template\_deployment | Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `bool` | `true` | no |
| network\_acls | Network ACLs to associate to the Azure Key Vault | <pre>list(object({<br>    default_action             = string,<br>    bypass                     = string,<br>    ip_rules                   = list(string),<br>    virtual_network_subnet_ids = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "bypass": "None",<br>    "default_action": "Deny",<br>    "ip_rules": null,<br>    "virtual_network_subnet_ids": null<br>  }<br>]</pre> | no |
| purge\_protection\_enabled | Is Purge Protection enabled for this Key Vault? | `bool` | `false` | no |
| secrets | List of secrets to be stored in key vault. | <pre>list(object({<br>    name = string,<br>    value = string,<br>    }<br>    ))</pre> | `[]` | no |
| sku\_name | The Name of the SKU used for this Key Vault. Possible values are standard and premium. | `string` | `"standard"` | no |
| tfe\_hostname | NGC TFE Instance e.g. https://example.tfe.pwcinternal.com | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Key Vault |
| name | The Name of Key Vault created |
| vault\_uri | The URI of the Key Vault |

## Release Notes

The newest published version of this module is v6.2.0.

- View the complete change log [here](./changelog.md)
