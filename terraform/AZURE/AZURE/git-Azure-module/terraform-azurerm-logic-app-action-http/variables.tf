variable "resource_group_name" {
  description = "Name of the resource group to which logic app action http is to be deployed."
  type        = string
}

variable "name" {
  description = "The name of the Logic App action-http to be created."
  type        = string
}

variable "logic_app_id" {
  description = "The ID of the Logic App Workflow."
  type        = string
}

variable "method" {
  description = "Specifies the HTTP Method which should be used for this HTTP Action. Possible values include DELETE, GET, PATCH, POST and PUT."
  type        = string
}

variable "uri" {
  description = "Specifies the URI which will be called when this HTTP Action is triggered."
  type        = string
}
