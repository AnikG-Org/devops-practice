###  Mandatory input variables  ###

variable "name" {
  description = "Name of the queue to be created under resource group"
  type        = string
}

variable "storage_account_name" {
  description = " Name of the storage account in which the storage queue is to be deployed"
  type        = string
}

