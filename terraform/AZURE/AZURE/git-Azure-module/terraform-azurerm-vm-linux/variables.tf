variable "resource_group_name" {
  description = "Resource group name in which the VM's will be created"
  type        = string
}

variable "subnet_id" {
  description = "Subnet id to create primary nic."
  type        = string
}

variable "ip_address" {
  description = "Set to Null for Dynamic Ip address Allocation. For static set IP Address"
  type        = string
  default     = null
}

variable "hostname" {
  description = "Hostname of the VM to be deployed."
  type        = string
}

variable "admin_username" {
  description = "The admin user for the deployed vm."
  type        = string
}

variable "admin_password" {
  description = "(Optional) The Password which should be used for the local-administrator on this Virtual Machine."
  type        = string
  default     = null
}

variable "vm_size" {
  description = "Size of the Azure VM to be deployed."
  type        = string
  default     = "Standard_A1_v2"
}

variable "availability_set_id" {
  description = "Resource ID for the availability set to attach this VM to."
  type        = string
  default     = null
}

variable "source_image_id" {
  description = "The Shared Gallery Image ID for the image to be used when deploying the VM"
  type        = string
}

variable "zone" {
  description = "the Zone in which this Virtual Machine should be created."
  type        = string
  default     = null
}

variable "storage_account_uri" {
  description = "(Required) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor."
  type        = string
}

variable "tags" {
  description = "Map of tags to be attached with VM, Recovery Service Vault and Backup Policy."
  type        = map(string)
}

variable "osdisk_managed_disk_type" {
  description = "Type of managed disk for the OSDisk on the VM."
  type        = string
  default     = "Standard_LRS"
}

variable "delete_data_disks_on_termination" {
  description = "Toggles whether to delete datadisks on termination or not. Default value is true"
  type        = bool
  default     = true
}

variable "delete_os_disk_on_termination" {
  description = "Toggles whether to delete the OS disk on termination or not. Default value is true"
  type        = bool
  default     = true
}

variable "location" {
  description = "The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type        = string
  default     = "eastus"
}

variable "nicids" {
  description = "Provide the NIC ids to be attached to this vm."
  type        = list(string)
  default     = []
}

variable "ip_configuration_name" {
  description = "Name of the nic Configuration to br created."
  type        = string
}

variable "disk_size_gb" {
  description = "The disk size of the OS disk in GB. The recommended size and default is 100gb due to puppet expanding the disksize to 100gb. Do not use less that 100gb"
  type        = string
  default     = "100"
}

variable "ultra_ssd_enabled" {
  description = "Toggle whether or not to enable Ultra SSD support on the VM."
  type        = bool
  default     = false
}

variable "identity_type" {
  description = "The Managed Service Identity Type of this Virtual Machine. Possible values are SystemAssigned (where Azure will generate a Service Principal for you), UserAssigned (where you can specify the Service Principal ID's) to be used by this Virtual Machine using the identity_ids field, and SystemAssigned, UserAssigned which assigns both a system managed identity as well as the specified user assigned identities."
  type        = string
  default     = null
}

variable "caching" {
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite."
  type        = string
  default     = "ReadWrite"
}

variable storage_account_type {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS and Premium_LRS. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard_LRS"
}

variable write_accelerator_enabled {
  description = "(Optional) Should Write Accelerator be Enabled for this OS Disk? Defaults to false."
  type        = bool
  default     = false
}

variable disk_encryption_set_id {
  description = "(Optional) The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk."
  type        = string
  default     = null
}

variable virtual_machine_scale_set_id {
  description = "(Optional) Specifies the Orchestrated Virtual Machine Scale Set that this Virtual Machine should be created within. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable ssh_public_key {
  description = "The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format. Changing this forces a new resource to be created. If set ssh key authentication will be used"
  type        = string
  default     = null
}

variable "backend_pool_association_id" {
  description = "Allows specifying an ID to reference a backend pool association for the created VM to ensure dependencies are handled properly by Terraform"
  type        = string
  default     = null
}

variable "recovery_vault_name" {
  description = "Specifies the name of the Recovery Services Vault to use."
  type        = string
}

variable "backup_policy_id" {
  description = "Specifies the id of the backup policy to use"
  type        = string
}
