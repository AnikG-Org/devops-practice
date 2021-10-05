# terraform-azurerm-loadbalancer

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
  name                 = "PZI-GXUS-G-SNT-OOFMH-T015"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = local.vnet_resource_group_name
}

data "azurerm_network_interface" "nic" {
  name                = "ngnetworkinterface"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "load_balancer" {
  source                                 = "../../"
  name                                   = var.user_parameters.naming_service.lb.k02
  resource_group_name                    = data.azurerm_resource_group.app_env_resource_group.name
  location                               = data.azurerm_resource_group.app_env_resource_group.location
  sku                                    = "Standard"
  lb_frontend_ip_configuration_name      = "projectname-lb-nic"
  lb_frontend_ip_configuration_subnet_id = data.azurerm_subnet.subnet.id
  private_ip_address                     = "10.195.250.236"
  private_ip_address_allocation          = "Static"
 
  vm_nics   = [
    {
      nic_id               = data.azurerm_network_interface.nic.id
      ip_config_name       = "ipconfig1"
    }
  ]

  enable_floating_ip                  = false
  idle_timeout_minutes                = 5
  lb_probe_interval                   = 5
  lb_probe_unhealthy_threshold        = 3

  lb_ports = [
    {
      frontend_port = 80
      backend_port  = 80
      protocol      = "tcp"
      has_probe     = true
    },
    {
      frontend_port = 443
      backend_port  = 443
      protocol      = "tcp"
      has_probe     = true
    }
  ]

  lb_probe_ports = [
    {
      backend_port  = 80
      protocol      = "tcp"
    },
    {
      backend_port  = 443
      protocol      = "tcp"
    }
  ]

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
| location | The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | n/a | yes |
| name | The name of load balancer to be created | `string` | n/a | yes |
| resource\_group\_name | The name of existing resource group in which load balancer is to be created | `string` | n/a | yes |
| backend\_pool\_id | Optional backend pool id to ensure association and proper ordering in Terraform DAG | `string` | `null` | no |
| enable\_floating\_ip | Floating IP is pertinent to failover scenarios: a floating IP is reassigned to a secondary server in case the primary server fails. Floating IP is required for SQL AlwaysOn. | `bool` | `false` | no |
| idle\_timeout\_minutes | Timeout for the tcp idle connection in minutes | `number` | `5` | no |
| lb\_frontend\_ip\_configuration\_name | Load Balancer Frontend IP configuration name | `string` | `"LBFrontendIPConfig"` | no |
| lb\_frontend\_ip\_configuration\_subnet\_id | ID of the Subnet which should be associated with the Load Balancer's IP Configuration | `string` | `null` | no |
| lb\_nat\_rules | NAT rules to associate to the load balancer | `list(object({protocol = string, frontend_port = number, backend_port = number, ip_config = string}))` | `[]` | no |
| lb\_ports | Ports to be used for mapping frontend to backend ports on the load balancer. | `list(object({frontend_port = number, backend_port = number, protocol = string, has_probe = bool}))` | <pre>[<br>  {<br>    "backend_port": 443,<br>    "frontend_port": 443,<br>    "has_probe": false,<br>    "protocol": "tcp"<br>  }<br>]</pre> | no |
| lb\_probe\_interval | Interval in seconds the load balancer health probe rule does a check | `number` | `5` | no |
| lb\_probe\_ports | Ports to be used for lb health probes. | `any` | <pre>[<br>  {<br>    "backend_port": 8080,<br>    "protocol": "tcp"<br>  }<br>]</pre> | no |
| lb\_probe\_unhealthy\_threshold | Number of times the load balancer health probe has an unsuccessful attempt before considering the endpoint unhealthy. | `number` | `2` | no |
| load\_distribution | Specifies the load balancing distribution type to be used by the Load Balancer. | `string` | `"Default"` | no |
| private\_ip\_address | Private IP Address to assign to the Load Balancer | `string` | `null` | no |
| private\_ip\_address\_allocation | The allocation method for the Private IP Address used by this Load Balancer (Dynamic/Static) | `string` | `"Dynamic"` | no |
| public\_ip\_address\_id | ID of a Public IP Address which should be associated with the Load Balancer | `string` | `null` | no |
| sku | SKU for load balancer | `string` | `"Standard"` | no |
| tags | Map of tags to be attached to the load balancer | `map(string)` | `{}` | no |
| vm\_nics | List of VM nic ID's to associate with the load balancer | `list(object({nic_id = string, ip_config_name = string}))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| backend\_address\_pool\_association\_id | ID of backend address pool association resource |
| backend\_address\_pool\_id | ID of load balancer's backend address pool |
| id | ID of load balancer that is created |
| private\_ip\_address | First private ip address assigned to load balancer in frontend\_ip\_configuration |
| private\_ip\_addresses | List of private ip addresses assigned to load balancer in frontend\_ip\_configuration |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
