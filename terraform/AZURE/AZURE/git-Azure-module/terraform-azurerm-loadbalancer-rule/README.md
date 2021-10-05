# terraform-azurerm-loadbalancer-rule

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_lb" "lb" {
  name                = var.user_parameters.naming_service.lb.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_lb_backend_address_pool" "adpool" {
  name            = "BackEndAddressPool1"
  loadbalancer_id = data.azurerm_lb.lb.id
}

module "loadbalancer-rule" {
  source  = "../../"

  lb_rule_specs = [
    {
      name                           = "test"
      protocol                       = "tcp"
      frontend_port                  = "8080"
      backend_port                   = "8081"
      frontend_ip_configuration_name = "projectname-lb-nic"
    },
  ]

  resource_group_name     = data.azurerm_resource_group.app_env_resource_group.name
  loadbalancer_id         = data.azurerm_lb.lb.id
  load_distribution       = "Default"
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.adpool.id
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
| backend\_address\_pool\_id | Backend address pool id for the load balancer | `string` | n/a | yes |
| lb\_rule\_specs | Load balancer rules specifications | `list(map(string))` | n/a | yes |
| loadbalancer\_id | ID of the load balancer | `string` | n/a | yes |
| resource\_group\_name | Name of the resource group | `string` | n/a | yes |
| load\_distribution | Specifies the load balancing distribution type to be used by the Load Balancer. Possible values are: Default – The load balancer is configured to use a 5 tuple hash to map traffic to available servers. SourceIP – The load balancer is configured to use a 2 tuple hash to map traffic to available servers. SourceIPProtocol – The load balancer is configured to use a 3 tuple hash to map traffic to available servers. Also known as Session Persistence, where the options are called None, Client IP and Client IP and Protocol respectively. | `string` | `""` | no |
| probe\_id | ID of the loadbalancer probe | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| lb\_rule\_ids | n/a |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
