variable "name" {
  type        = string
  description = "Name of the Logic App Integration Account to be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Logic App Integration Account is to be created."
}

variable "location" {
  description = "The Azure region where the Logic App Integration Account is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions."
  type        = string
}

variable "sku_name" {
  description = "The sku name of the Logic App Integration Account. Possible values are Basic, Free and Standard. Default is Basic."
  default     = "Basic"
  type        = string
}

variable "tags" {
  description = "Map of tags to be attached to the Logic App Integration Account."
  type        = map(string)
}

