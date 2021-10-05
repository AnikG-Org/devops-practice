variable "resource_group_name" {
  description = "Name of the resource group to which table storage is to be deployed."
  type        = string
}

variable "name" {
  description = "The name of the Logic App Workflow reccurance to be created"
  type        = string
}

variable "logic_app_id" {
  description = "The ID of the Logic App Workflow."
  type        = string
}

variable "frequency" {
  description = "Specifies the Frequency at which this Trigger should be run. Possible values include Month, Week, Day, Hour, Minute and Second."
  type        = string
}

variable "interval" {
  description = "Specifies interval used for the Frequency, for example a value of 4 for interval and hour for frequency would run the Trigger every 4 hours"
  type        = number
}