variable "nic_ids" {
  description = "The network interface id to associate ASG to."
  type        = list(string)
}

variable "application_security_group_id" {
  description = "The ASG id to associate to NIC"
  type        = string
}

variable "nic_count" {
  description = "The count of NICs to be associated with ASG ids"
  type = number
  default = 1
}
