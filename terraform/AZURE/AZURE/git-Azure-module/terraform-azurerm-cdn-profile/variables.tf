variable "resource_group_name" {
  description = "Resource group name in which the CDN profile will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the CDN profile is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type        = string
}

variable "sku_type" {
  description = "The sku type of the CDN profile to be created. Possible values: 'Standard_Akamai', 'Standard_ChinaCdn', 'Standard_Microsoft', 'Standard_Verizon', and 'Premium_Verizon'"
  type        = string
}

variable "cdn_profile_name" {
  description = "The name that will be used for the CDN profile."
  type        = string
}

variable "tags" {
  description = "Map of tags to be attached to the CDN profile"
  type        = map(string)
}

