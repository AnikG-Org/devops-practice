variable "name" {
  description = "The name to use for this Notification Hub."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which the Notification Hub Namespace exists."
  type        = string
}

variable "location" {
  description = "The Azure Region in which this Notification Hub Namespace exists."
  type        = string
}

variable "namespace_name" {
  description = "The name of the Notification Hub Namespace in which to create this Notification Hub."
  type        = string
}

