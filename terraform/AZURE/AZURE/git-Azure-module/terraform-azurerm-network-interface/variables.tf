variable "resource_group_name" {
  description = "Name of the resource group where resource is deployed to."
  type        = string
}

variable "name" {
  description = "The name of the Network Interface."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the NIC into."
  type        = string
}

variable "ip_address" {
  description = "A static IP address to be associated with the NIC's ip configuration."
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID that the NIC will be associated to."
  type        = string
}

variable "tags" {
  description = "A map of key value pairs to be used when applying tags to the resource."
  type        = map(string)
}

variable "ip_config_name" {
  description = "The name of the IPconfig on the nic."
  type        = string
}

