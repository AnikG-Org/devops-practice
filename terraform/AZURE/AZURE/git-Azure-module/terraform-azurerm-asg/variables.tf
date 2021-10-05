variable "name" {
  description = "Name of the ASG to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the ASG."
  type        = string
}

variable "location" {
  description = "The Azure region where the ASG is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions."
  type        = string
}

variable "tags" {
  description = "Map of tags to be attached to the ASG."
  type        = map(string)
}

variable "asg_count" {
  description = "Count used as a flag to define if ASG should be deployed."
  type        = number
  default     = 1
}

variable "nic_ids" {
  description = "List of NIC Id's to be associated to the ASG."
  type        = list(string)
  default     = null
}
