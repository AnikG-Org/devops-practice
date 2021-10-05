variable "acr_count" {
  description = "Count based flag to decide weather to provision ACR or not."
  type        = number
  default     = 1
}

variable "name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Container Registry."
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists. "
  type        = string
}

variable "sku" {
  description = "The SKU name of the the container registry. Possible values are Basic, Standard and Premium. If Firewall and virtual network option to be enable, please choose sku type as Premium."
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Enable an admin user to use to push images to the ACR."
  type        = string
  default     = false
}

variable "georeplications" {
  description = "A list of locations where the container registry should be geo-replicated."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "The tags associated to the resource."
  type        = map(string)
}
