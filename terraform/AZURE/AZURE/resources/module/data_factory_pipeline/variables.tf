variable "resource_group_name" {
  description = "The name of the resource group in which to create the Data Factory Pipeline."
  type        = string
}

variable "name" {
  description = "The name of the Data Factory Pipeline."
  type        = string
}

variable "data_factory_name" {
  description = "The Data Factory name in which to associate the Pipeline with."
  type        = string
}

