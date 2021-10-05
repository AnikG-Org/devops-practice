# terraform-azurerm-network-interface-backend-address-pool-association

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_lb" "loadbalencer" {
  name                = var.user_parameters.naming_service.lb.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  name            = "BackEndAddressPool1"
  loadbalancer_id = data.azurerm_lb.loadbalencer.id
}

data "azurerm_network_interface" "network_interface" {
  name                = var.user_parameters.naming_service.nic.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "azurerm_network_interface_backend_address_pool_association" {
  source                  = "../../"
  nic_count               = "1"
  nic_ids                 = [data.azurerm_network_interface.network_interface.id]
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.lb_backend_address_pool.id
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
| backend\_address\_pool\_id | The ID of the Load Balancer Backend Address Pool which this Network Interface which should be connected to. | `string` | n/a | yes |
| ip\_configuration\_name | The Name of the IP Configuration within the Network Interface which should be connected to the Backend Address Pool. | `string` | n/a | yes |
| nic\_count | Number of nic's to attach to backend pool | `number` | n/a | yes |
| nic\_ids | The ID of the Network Interface. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the Association between the Network Interface and the Load Balancers Backend Address Pool created. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
