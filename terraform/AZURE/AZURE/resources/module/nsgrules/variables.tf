variable "resource_group_name" {
  description = "The name of a resource group in which network security group is to be created"
  type        = string
}

variable "network_security_group_name" {
  description = "Name of NSG to which rules will be attached"
  type        = string
}

variable "rules" {
  description = "List of NSG rules to be attached to the network security group"
  type = list(object({
    name              = string
    direction         = string
    access            = string
    protocol          = string
    source            = string
    destination       = string
    source_ports      = string
    destination_ports = string
  }))
}