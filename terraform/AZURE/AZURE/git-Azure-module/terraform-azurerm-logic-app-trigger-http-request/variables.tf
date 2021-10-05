variable "resource_group_name" {
  description = "Name of the resource group in which HTTP Action is to be deployed."
  type        = string
}

variable "name" {
  description = "Specifies the name of the HTTP Action is to be created within the Logic App Workflow."
  type        = string
}

variable "logic_app_id" {
  description = "The name of the Logic App Workflow created."
  type        = string
}

variable "filename" {
  description = "Specifies the Name of the local json file."
  type        = string
}
