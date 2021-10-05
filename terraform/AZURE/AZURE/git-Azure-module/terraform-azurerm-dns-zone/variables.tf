variable "name" {
  description = "The name of the image gallery."
  type        = string
}

variable "resource_group_name" {
  description = "Specifies the resource group where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
 }

