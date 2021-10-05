variable "name" {
  description = " Specifies the name of the Media Services Account.Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Media Services Account. Changing this forces a new resource to be created."
  type        = string
 }

variable "location" {
  description = " Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
  }

variable "storage_account_id" {
  description = "name of the storage_account and storage_account block supports the following below."
  type        = string
 }

variable "is_primary" {
  description = "Specifies whether the storage account should be the primary account or not. Defaults to false."
  type        = string
  default     = "false"
 }