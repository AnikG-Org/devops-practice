variable "name" {
  description = "Name of availability set to be created."
  type        = string
}

variable "resource_group_name" {
  description = "Name of existing resource group in which availability set is to be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type        = string
}

variable "platform_update_domain_count" {
  description = "Specifies the number of update domains that are used. Defaults to 5 if not specified."
  type        = number
  default     = 5
}

variable "platform_fault_domain_count" {
  description = "Specifies the number of fault domains that are used. Defaults to 3 if not specified."
  type        = number
  default     = 3
}

variable "tags" {
  description = "A map of tags to be assigned to availability set."
  type        = map(string)
}

variable "managed" {
  description = "Specifies whether the availability set is managed or not.Possible values are true or false."
  type        = bool
  default     = true
}

