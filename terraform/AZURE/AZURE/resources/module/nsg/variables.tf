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



variable "tags" {
  description = "A map of tags to be assigned to the network security group."
  type        = map(string)
}

variable "custom_rules" {
  description = "Security rules for the network security group using this format = [name, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix]"
  type = list(object({
    name                       = string
    description                = string
    priority                   = string
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_ranges     = list(string)
    source_address_prefixes      = list(string)
    destination_address_prefixes = list(string)
    }
  ))
  default = null
}


variable "nsg_count" {
  type        = number
  description = "Defines if route table should be deployed (0 or 1)"
  default     = 1
}


