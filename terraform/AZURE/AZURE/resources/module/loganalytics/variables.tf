variable "name" {
  description = "loag analystics name"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources to."
  type        = string
}

variable "tags" {
  description = "Map of tags to be attached"
  type        = map(string)
}
variable "resource_group_name" {
  description = "resource_group_name"
  type        = string
}

variable "sku" {
  description = "sku"
  type        = string
}

variable "retention_in_days" {
  description = "retention_in_days"
  type        = string
}

