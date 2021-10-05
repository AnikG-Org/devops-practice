###  Mandatory input variables  ###

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "loadbalancer_id" {
  description = "ID of the load balancer"
  type        = string
}

variable "name" {
  description = "Probe name for the load balancer"
  type        = string
}

variable "port" {
  description = "Port number"
}

