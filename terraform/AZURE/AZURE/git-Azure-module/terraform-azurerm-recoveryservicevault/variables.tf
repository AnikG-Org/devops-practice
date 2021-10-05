variable "name" {
  description = "Name of the recovery service vault."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Recovery Services Vault."
  type        = string
}

variable "location" {
  description = "Specify the supported Azure location where the resource exists."
  type        = string
}

variable "sku" {
  description = "Sets the vault's SKU. Possible values include: Standard, RS0."
  default     = "Standard"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "soft_delete_enabled" {
  description = "Is soft delete enable for this Vault? If 'true' the backup data is retained for 14 additional days and VM deletion won't happen instantaneously, If 'false' VM resource get deleted instantaneously"
  type        = string
  default     = true
}

variable "monitor_diagnostic_setting_name" {
  description = "Specifies the name of the Diagnostic Setting."
  type        = string
}

variable "tfe_url" {
  type        = string
  description = "Specify TFE instance url like: west.tfe.pwcinternal.com, central.tfe.pwcinternal.com, east.tfe.pwcinternal.com, tfe.pwc.com and global.tfe.pwcinternal.com"
}
