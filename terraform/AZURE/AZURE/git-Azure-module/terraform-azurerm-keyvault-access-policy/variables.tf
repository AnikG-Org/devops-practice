variable "key_vault_id" {
  type        = string
  description = "Specifies the id of the Key Vault resource."
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
}

variable "object_ids" {
  type        = list(string)
  description = "List of the object IDs of user(s), service principal(s) or security group(s) in the Azure Active Directory tenant for the vault."
}

variable "application_id" {
  type        = string
  description = "The object ID of an Application in Azure Active Directory."
  default     = null
}

variable "certificate_permissions" {
  type        = list(string)
  description = "List of certificate permissions."
  default     = null
}

variable "key_permissions" {
  type        = list(string)
  description = "List of key permissions."
  default     = null
}

variable "secret_permissions" {
  type        = list(string)
  description = "List of secret permissions."
  default     = null
}

variable "storage_permissions" {
  type        = list(string)
  description = "List of storage permissions."
  default     = null
}

variable "grant_full_access" {
  type        = bool
  description = "Defines if full access should be granted."
  default     = false
}

locals {
  object_ids              = distinct(var.object_ids)
  key_permissions         = var.grant_full_access ? ["get", "list", "backup", "create", "decrypt", "delete", "encrypt", "import", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"] : var.key_permissions
  secret_permissions      = var.grant_full_access ? ["get", "list", "backup", "delete", "purge", "recover", "restore", "set"] : var.secret_permissions
  certificate_permissions = var.grant_full_access ? ["create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "purge", "recover", "restore", "setissuers", "update", "backup"] : var.certificate_permissions
  storage_permissions     = var.grant_full_access ? ["backup", "delete", "deletesas", "get", "getsas", "list", "listsas", "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update"] : var.storage_permissions
}
