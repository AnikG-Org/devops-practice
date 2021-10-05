variable "resource_group_name" {
  description = "The name of the resource group in which to create the CDN Endpoint."
  type        = string
}

variable "location" {
  description = "Location of resource group in which the end point needs to be created."
  type        = string
}

variable "name" {
  description = "Name of the cdn endpoint."
  type        = string
}

variable "profile_name" {
  description = "Name of the cdn profile in which the endpoint has to be created."
  type        = string
}

variable "origin_name" {
  description = "Origin name for cdn endpoint."
  type        = string
}

variable "host_name" {
  description = "Host name for cdn endpoint."
  type        = string
}

variable "origin_host_header" {
  description = "The host header CDN provider will send along with content requests to origins."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
}

