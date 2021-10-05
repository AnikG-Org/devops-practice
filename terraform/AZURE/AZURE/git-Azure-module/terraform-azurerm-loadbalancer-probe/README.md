# terraform-azurerm-loadbalancer-probe

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_lb" "lb" {
  name                = var.user_parameters.naming_service.lb.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}
module "loadbalancer-probe" {
  source              = "../../"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  loadbalancer_id     = data.azurerm_lb.lb.id
  name                = "testprobe"
  port                = 22
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
| loadbalancer\_id | ID of the load balancer | `string` | n/a | yes |
| name | Probe name for the load balancer | `string` | n/a | yes |
| port | Port number | `any` | n/a | yes |
| resource\_group\_name | Name of the resource group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | n/a |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
