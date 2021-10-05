###  Mandatory input variables  ###

variable "resource_group_name" {
  description = "Name of existing resource group in which datadisks are to be created"
  type = string
}

variable "location" {
  description = "The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type = string
}

variable "vm_name" {
  description = "Name of the virtual machine to which datadisks must be attached"
  type = string
}

variable "vm_id" {
  description = "Name of the virtual machine to which datadisks must be attached"
  type = string
}

variable "datadisk_count" {
  description = "Number of  data disks to be created for the VM"
  type = number
}

variable "data_disk_specs" {
  type = list(map(string))
  description = "Data disks deployment specifications"
}

variable "tags" {
  description = "A map of the tags to apply to the Azure resources."
  type    = map(string)
}

###  Optional input variables  ###
variable "caching" {
  description = "The caching type of the disk valid values are None, ReadOnly, and ReadWrite. The Default value is ReadWrite."
  type        = string
  default     = "ReadWrite"
}

variable "zones" {
  type        = list(string)
  description = "A collection containing the availability zone to allocate the Managed Disk in."
  default     = null
}

### Local variables ###

locals {
  disk_iops_read_write = null
  disk_mbps_read_write = null
  create_option = "Empty"
  storage_account_type = "Standard_LRS"
}