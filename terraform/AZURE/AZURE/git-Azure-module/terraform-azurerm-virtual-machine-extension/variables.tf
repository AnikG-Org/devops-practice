variable "name" {
  description = "The name of the virtual machine extension peering"
  type        = string
}

variable "virtual_machine_id" {
  description = " The ID of the Virtual Machine. Changing this forces a new resource to be created"
  type        = string
}

variable "publisher" {
  description = "The publisher of the extension"
  type        = string
}

variable "type" {
  description = "The type of extension"
  type        = string
}

variable "type_handler_version" {
  description = "Specifies the version of the extension to use"
  type        = string
}

variable "auto_upgrade_minor_version" {
  description = "Specifies if the platform deploys the latest minor version update to the type_handler_version specified."
  type        = string
  default     = null
}

variable "settings" {
  description = "The settings passed to the extension, these are specified as a JSON object in a string."
  type        = string
  default     = ""
}

variable "protected_settings" {
  description = "The protected_settings passed to the extension, like settings, these are specified as a JSON object in a string."
  type    = string
  default = ""
}

variable "tags" {
  description = "Mapping of tags to assign to the resource."
  type        = map(string)
  default     = null
}

