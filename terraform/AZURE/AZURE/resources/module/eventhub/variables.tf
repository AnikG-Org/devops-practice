variable "location" {
  description = "The Azure region to deploy resources to."
  type        = string
}
variable "namespace_name" {
  description = "vnet_address_Space"
}

variable "resource_group_name" {
  description = "resource_group_name"
  type        = string
}
variable "tags" {
  description = "Map of tags to be attached"
  type        = map(string)
}



variable "eventhubname" {
  description = "eventhubname"
  type        = string
}
variable "partition_count" {
  description = "partition_count"
  type        = string
}
variable "sku" {
  description = "sku"
  type        = string
}

variable "capacity" {
  description = "capacity"
  type        = string
}
variable "message_retention" {
  description = "message_retention"
  type        = string
}



