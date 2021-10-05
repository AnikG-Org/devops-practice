variable "resource_group_name" {
  description = "Resource group name to place the resource."
  type        = string
}

variable "name" {
  description = "The name of the Logic App Workflow."
  type        = string
}

variable "location" {
  description = "The location of the resource group."
  type        = string
}

variable "tags" {
  description = "The tags associated to the resource."
  type        = map(string)
}

