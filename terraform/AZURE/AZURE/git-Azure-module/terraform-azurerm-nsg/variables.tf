variable "name" {
  description = "Name of NSG to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of a resource group in which network security group is to be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions."
  type        = string
}

variable "workload_subnet" {
  description = "The workload subnet for the nsg."
  type        = string
}

variable "gateway_subnet" {
  description = "The gateway subnet."
  type        = string
}

variable "transit_subnet" {
  description = "The transit subnet in CIDR notation."
  type        = string
}

variable "vnet_address_spaces" {
  description = "List of all address spaces on the vnet. This must be queried and provided as a list."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to be assigned to the network security group."
  type        = map(string)
}

variable "custom_rules" {
  description = "Security rules for the network security group using this format = [name, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix]"
  type = list(object({
    name                       = string
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
    }
  ))
  default = null
}

variable "smtp_access" {
  description = "The value that determines 'allow' or 'deny' on the SMTP rule. Default value is Deny, use Allow to allow SMTP outbound traffic."
  type        = string
  default     = "Deny"
}

variable "create_default_rules" {
  type        = bool
  description = "Boolean flag to define if default NSG rules should be created."
  default     = true
}

variable "nsg_count" {
  type        = number
  description = "Defines if route table should be deployed (0 or 1)"
  default     = 1
}
locals {
}

