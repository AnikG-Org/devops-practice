variable "name" {
  description = "The name of the Action Group. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Action Group instance."
  type        = string
}

variable "short_name" {
  description = "The short name of the action group. This will be used in SMS messages."
  type        = string
}

variable "email_receivers" {
  description = "The name of the email receiver. Names must be unique (case-insensitive) across all receivers within an action group."
  type        = list
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}