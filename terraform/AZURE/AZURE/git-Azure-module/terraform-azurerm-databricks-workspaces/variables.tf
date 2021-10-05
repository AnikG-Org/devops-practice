variable "resource_group_name" {
  description = "Resource group name to place the resource"
  type        = string
}

variable "name" {
  description = "Name of databricks workspace"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "sku" {
  description = "Choose between Basic or Standard. Default is Basic"
  type        = string
  default     = "Standard"
}

variable "managed_resource_group_name" {
  description = "The name of the resource group where Azure should place the Databricks resource"
  type        = string
}

variable "tags" {
  description = "The tags associated to the resource"
  type        = map
  default     = {}
}

variable "public_subnet_name" {
  description = "databricks public subnet"
  type        = string
  default     = ""
}

variable "private_subnet_name" {
  description = "databricks private subnet"
  type        = string
  default     = ""
}

variable "virtual_network_id" {
  description = "databricks vnet"
  type        = string
  default     = ""
}