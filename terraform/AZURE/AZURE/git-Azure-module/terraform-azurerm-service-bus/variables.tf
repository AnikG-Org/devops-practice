variable "name" {
  description = "Specifies the name of the ServiceBus Namespace resource."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the namespace."
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "sku_name" {
  description = "Defines which tier to use. Options are basic, standard or premium."
  type        = string
}

variable "capacity" {
    type = number
    description = "Specifies the capacity. When sku is Premium, capacity can be 1, 2, 4 or 8. When sku is Basic or Standard, capacity can be 0 only."
    default = null
}

variable "zone_redundant" {
    type = bool
    description = "Whether or not this resource is zone redundant. sku needs to be Premium."
    default = false
}

variable "tags" {
  description = "Map of tags to be attached to the service bus."
  type        = map(string)
}
