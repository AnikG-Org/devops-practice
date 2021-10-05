# terraform-azurerm-keyvault-access-policy

## Usage
``` terraform
data "azurerm_key_vault" "keyvault" {
  name                = var.user_parameters.naming_service.key_vault.k01
  resource_group_name = var.__ghs.environment_resource_groups
}

data "azurerm_client_config" "current" {}

module "primary_keyvault_spn_access_policy" {
  source                  = "../../"
  key_vault_id            = data.azurerm_key_vault.keyvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_ids              = [data.azurerm_client_config.current.object_id]
  key_permissions         = ["get", "create", "list", "update", "delete"]
  secret_permissions      = ["get", "set", "list", "delete"]
  certificate_permissions = ["get", "create", "list", "update", "delete"]
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
| key\_vault\_id | Specifies the id of the Key Vault resource. | `string` | n/a | yes |
| object\_ids | List of the object IDs of user(s), service principal(s) or security group(s) in the Azure Active Directory tenant for the vault. | `list(string)` | n/a | yes |
| tenant\_id | The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. | `string` | n/a | yes |
| application\_id | The object ID of an Application in Azure Active Directory. | `string` | `null` | no |
| certificate\_permissions | List of certificate permissions. | `list(string)` | `null` | no |
| grant\_full\_access | Defines if full access should be granted. | `bool` | `false` | no |
| key\_permissions | List of key permissions. | `list(string)` | `null` | no |
| secret\_permissions | List of secret permissions. | `list(string)` | `null` | no |
| storage\_permissions | List of storage permissions. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | n/a |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
