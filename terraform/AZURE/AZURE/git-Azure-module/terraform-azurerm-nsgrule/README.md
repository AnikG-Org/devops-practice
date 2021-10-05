# terraform-azurerm-nsgrule

## Usage
``` terraform
locals {
  vnet_resource_group_name = replace(var.system_parameters.VNET, "N-VNT", "N-RGP-BASE")
}

data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_virtual_network" "vnet" {
  name                = var.system_parameters.VNET
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "subnet1" {
  name                 = "PZI-GXUS-G-SNT-OOFMH-T015"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = local.vnet_resource_group_name
}

data "azurerm_subnet" "subnet2" {
  name                 = "PZI-GXUS-N-SNT-OOFMH-D084"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = local.vnet_resource_group_name
}

data "azurerm_application_security_group" "asg" {
  name                = var.user_parameters.naming_service.asg.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_network_security_group" "nsg" {
  name                = var.user_parameters.naming_service.nsg.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "app_nsg_rules" {
  source                      = "../../"
  network_security_group_name = data.azurerm_network_security_group.nsg.name
  resource_group_name         = data.azurerm_resource_group.app_env_resource_group.name
  rules                       = [
    {
      name                  = "ALLOW_ALL_LOADBALANCER_INBOUND1"
      protocol              = "Tcp"
      access                = "Allow"
      direction             = "Inbound",
      source                = "AzureLoadBalancer"
      destination           = data.azurerm_subnet.subnet1.address_prefix
      source_ports          = "*",
      destination_ports     = "*"
    },
    {
      name                  = "ALLOW_APP_SUBNET_1"
      protocol              = "Tcp"
      access                = "Allow"
      direction             = "Inbound",
      source                = data.azurerm_subnet.subnet2.address_prefix
      destination           = data.azurerm_subnet.subnet1.address_prefix
      source_ports          = "*",
      destination_ports     = "443,80,3389,8000-8080"
    },
    {
      name                  = "ALLOW_ASG1"
      protocol              = "Tcp"
      access                = "Allow"
      direction             = "Inbound",
      source                = data.azurerm_application_security_group.asg.id
      destination           = data.azurerm_subnet.subnet1.address_prefix
      source_ports          = "*",
      destination_ports     = "6000-6010"
    },
    {
      name                  = "ALLOW_ALL_LOADBALANCER_INBOUND2"
      protocol              = "Tcp"
      access                = "Allow"
      direction             = "Inbound",
      source                = "AzureLoadBalancer"
      destination           = data.azurerm_subnet.subnet1.address_prefix
      source_ports          = "*",
      destination_ports     = "*"
    },
    {
      name                  = "ALLOW_APP_SUBNET_2"
      protocol              = "Tcp"
      access                = "Allow"
      direction             = "Inbound",
      source                = data.azurerm_subnet.subnet2.address_prefix
      destination           = data.azurerm_subnet.subnet1.address_prefix
      source_ports          = "*",
      destination_ports     = "443,80,3389,8000-8080"
    },
    {
      name                  = "ALLOW_ASG2"
      protocol              = "Tcp"
      access                = "Allow"
      direction             = "Inbound",
      source                = data.azurerm_application_security_group.asg.id
      destination           = data.azurerm_subnet.subnet1.address_prefix
      source_ports          = "*",
      destination_ports     = "6000-6010"
    },
    {
      name                  = "ALLOW_ALL_LOADBALANCER_INBOUND3"
      protocol              = "Tcp"
      access                = "Allow"
      direction             = "Inbound",
      source                = "AzureLoadBalancer"
      destination           = data.azurerm_subnet.subnet1.address_prefix
      source_ports          = "*",
      destination_ports     = "*"
    },
    {
      name                  = "ALLOW_APP_SUBNET_3"
      protocol              = "Tcp"
      access                = "Allow"
      direction             = "Inbound",
      source                = data.azurerm_subnet.subnet2.address_prefix
      destination           = data.azurerm_subnet.subnet1.address_prefix
      source_ports          = "*",
      destination_ports     = "443,80,3389,8000-8080"
    },
    {
      name                  = "ALLOW_ASG3"
      protocol              = "Tcp"
      access                = "Allow"
      direction             = "Inbound",
      source                = data.azurerm_application_security_group.asg.id
      destination           = data.azurerm_subnet.subnet1.address_prefix
      source_ports          = "*",
      destination_ports     = "6000-6010"
    },
    {
      name                  = "ALLOW_ALL_LOADBALANCER_INBOUND4"
      protocol              = "Tcp"
      access                = "Allow"
      direction             = "Inbound",
      source                = "AzureLoadBalancer"
      destination           = data.azurerm_subnet.subnet1.address_prefix
      source_ports          = "*",
      destination_ports     = "*"
    },
    {
      name                  = "ALLOW_APP_SUBNET_4"
      protocol              = "Tcp"
      access                = "Allow"
      direction             = "Inbound",
      source                = data.azurerm_subnet.subnet2.address_prefix
      destination           = data.azurerm_subnet.subnet1.address_prefix
      source_ports          = "*",
      destination_ports     = "443,80,3389,8000-8080"
    },
    {
      name                  = "ALLOW_ASG4"
      protocol              = "Tcp"
      access                = "Allow"
      direction             = "Inbound",
      source                = data.azurerm_application_security_group.asg.id
      destination           = data.azurerm_subnet.subnet1.address_prefix
      source_ports          = "*",
      destination_ports     = "6000-6010"
    },
  ]
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
| network\_security\_group\_name | Name of NSG to which rules will be attached | `string` | n/a | yes |
| resource\_group\_name | The name of a resource group in which network security group is to be created | `string` | n/a | yes |
| rules | List of NSG rules to be attached to the network security group | <pre>list(object({<br>    name              = string<br>    direction         = string<br>    access            = string<br>    protocol          = string<br>    source            = string<br>    destination       = string<br>    source_ports      = string<br>    destination_ports = string<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ids | n/a |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
