# terraform-azurerm-keyvault-byok

## Usage
``` terraform
module "keyvault-byok" {
  source              = "../../"
  location            = var.__ghs.environment_hosting_region
  name                = var.user_parameters.naming_service.key_vault.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  tags = {
    "ghs-los" : var.system_parameters.TAGS["ghs-los"],
    "ghs-solution" : var.system_parameters.TAGS["ghs-solution"],
    "ghs-appid" : var.system_parameters.TAGS["ghs-appid"],
    "ghs-environment" : var.system_parameters.TAGS["ghs-environment"],
    "ghs-owner" : var.system_parameters.TAGS["ghs-owner"],
    "ghs-tariff" : var.system_parameters.TAGS["ghs-tariff"],
    "ghs-srid" : var.system_parameters.TAGS["ghs-srid"],
    "ghs-environmenttype" : var.system_parameters.TAGS["ghs-environmenttype"],
    "ghs-deployedby" : var.system_parameters.TAGS["ghs-deployedby"],
    "ghs-dataclassification" : var.system_parameters.TAGS["ghs-dataclassification"],
    "ghs-envid" : var.system_parameters.TAGS["ghs-envid"],
    "ghs-apptioid" : var.system_parameters.TAGS["ghs-apptioid"]
  }
}

data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12 |
| terraform | >= 0.12 |
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
| access\_policies | Access policy objects for associating to the Azure Key Vault | <pre>list(object({<br>    tenant_id               = string,<br>    object_id               = string,<br>    key_permissions         = list(string),<br>    secret_permissions      = list(string),<br>    certificate_permissions = list(string)<br>  }))</pre> | `[]` | no |
| default\_key\_opts | Default set of key options. | `list(string)` | <pre>[<br>  "decrypt",<br>  "encrypt",<br>  "sign",<br>  "unwrapKey",<br>  "verify",<br>  "wrapKey"<br>]</pre> | no |
| enabled\_for\_disk\_encryption | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false. | `bool` | `false` | no |
| key\_suffix | Unique suffix appended to keys to identify application. | `string` | `""` | no |
| keys | List of keys to be stored in key vault. | `any` | `[]` | no |
| network\_acls | Network ACLs to associate to the Azure Key Vault | <pre>list(object({<br>    default_action             = string,<br>    bypass                     = string,<br>    ip_rules                   = list(string),<br>    virtual_network_subnet_ids = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "bypass": "None",<br>    "default_action": "Deny",<br>    "ip_rules": null,<br>    "virtual_network_subnet_ids": []<br>  }<br>]</pre> | no |
| production | Environment Production or Non-Production | `bool` | `false` | no |
| tags | A map of tags to be assigned to KeyVault. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Key Vault |
| name | The Name of Key Vault created |
| vault\_uri | The URI of the Key Vault |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
