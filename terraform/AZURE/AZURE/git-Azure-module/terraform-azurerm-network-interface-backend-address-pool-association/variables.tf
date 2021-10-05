variable "nic_ids" {
  description = "The ID of the Network Interface."
  type        = list(string)
}

variable "nic_count" {
  description = "Number of nic's to attach to backend pool"
  type        = number
}

variable "ip_configuration_name" {
  description = "The Name of the IP Configuration within the Network Interface which should be connected to the Backend Address Pool."
  type        = string
}

variable "backend_address_pool_id" {
  description = "The ID of the Load Balancer Backend Address Pool which this Network Interface which should be connected to."
  type        = string
}
