# terraform-azurerm-nic-asg-association

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_network_interface" "interface" {
  name                = var.user_parameters.naming_service.nic.k02
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_application_security_group" "asg" {
  name                = var.user_parameters.naming_service.asg.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "nic-asg-association" {
  source                        = "../../"
  nic_count                     = "1"
  nic_ids                       = [data.azurerm_network_interface.interface.id]
  application_security_group_id = data.azurerm_application_security_group.asg.id
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
| application\_security\_group\_id | The ASG id to associate to NIC | `string` | n/a | yes |
| nic\_ids | The network interface id to associate ASG to. | `list(string)` | n/a | yes |
| nic\_count | The count of NICs to be associated with ASG ids | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the association this module creates. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
