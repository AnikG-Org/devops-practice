variable "resource_group_name" {
  description = "Resource group name in which the VM's will be created."
  type        = string
}

variable "ip_configuration_name" {
  description = "IP configuration name on the NIC's."
  type        = string
}

variable "subnetid" {
  description = "Subnet id to create primary nic."
  type        = string
}

variable "ipaddress" {
  description = "Static IPAddress used for the primary nic."
  type        = string
}

variable "hostname" {
  description = "Hostname of the windows vm to be deployed."
  type        = string
}

variable "password" {
  description = "The admin password for the deployed VM."
  type        = string
}

variable "size" {
  description = "Size of the Azure VM to be deployed."
  type        = string
}

variable "availability_set_id" {
  description = "Resource ID for the availability set to attach this VM to."
  type        = string
  default     = null
}

variable "source_image_id" {
  description = "The Shared Gallery Image ID for the image to be used when deploying the VM."
  type        = string
}

variable "application_security_group_id" {
  description = "List of ASG ids to associate to nics associated to deployed VM."
  type        = string
  default     = ""
}

variable "osdisk_managed_disk_type" {
  description = "Type of managed disk for the OSDisk on the VM."
  type        = string
  default     = "Standard_LRS"
}

variable "osdisk_managed_disk_size" {
  description = "Size of managed disk for the OSDisk on the VM."
  type        = string
}

variable "license_type" {
  description = "Specifies the type of on-premise license (also known as Azure Hybrid Use Benefit) which should be used for this Virtual Machine. Possible values are None, Windows_Client and Windows_Server."
  type        = string
}

variable "boot_diagnostics_storage_acc_uri" {
  description = "The storage account URI to point the diagnostics to. Default value is empty string."
  type        = string
}

variable "tags" {
  description = "Map of tags to be attached with VM, Recovery Service Vault and Backup Policy."
  type        = map(string)
}

variable "location" {
  description = "The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions."
  type        = string
}

variable "nicids" {
  description = "Provide the NIC ids to be attached to this vm."
  type        = list
  default     = []
}

variable "identity_type" {
  description = "The Managed Service Identity Type of this Virtual Machine. Possible values are SystemAssigned (where Azure will generate a Service Principal for you), UserAssigned (where you can specify the Service Principal ID's) to be used by this Virtual Machine using the identity_ids field, and SystemAssigned, UserAssigned which assigns both a system managed identity as well as the specified user assigned identities."
  type        = string
  default     = null
}

locals {
  disk_size_gb = var.osdisk_managed_disk_size < 128 ? 128 : var.osdisk_managed_disk_size
}

variable "recovery_services_vault_name" {
  description = "Specifies the name of the Recovery Services Vault to use."
  type        = string
}

variable "backup_policy_id" {
  description = "Specifies the id of the backup policy to use"
  type        = string
}

variable "zone" {
  type        = number
  description = "Availability zone in which the virtual machine should be deployed (valid values are: 1, 2, or 3)"
  default     = null
}
