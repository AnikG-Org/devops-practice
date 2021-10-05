variable "production" {
  description = "Environment Production or Non-Production"
  type        = bool
  default     = false
}

variable "name" {
  description = "Specifies the name of the Key Vault."
  type        = string
}

variable "key_suffix" {
  description = "Unique suffix appended to keys to identify application."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Key Vault."
  type        = string
}

variable "enabled_for_disk_encryption" {
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to be assigned to KeyVault."
  type        = map(string)
  default     = {}
}

# Complex object specifying what access policies to grant on the Key Vault. 
#		Parameters: 
#			key_permissions: List of key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey.
#			secret_permissions: List of secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set.
#			certificate_permissions: List of certificate permissions, must be one or more from the following: create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, setissuers and update.
#			object_id: The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies.
#			tenant_id: The Azure Active Directory tenant ID to allow access to Key Vault.
variable "access_policies" {
  type = list(object({
    tenant_id               = string,
    object_id               = string,
    key_permissions         = list(string),
    secret_permissions      = list(string),
    certificate_permissions = list(string)
  }))
  description = "Access policy objects for associating to the Azure Key Vault"
  default     = []
}

# Complex object type for passing network ACLs
#		Parameters:
#			default_action: The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
#			bypass: Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.
#			ip_rules: One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
#			virtual_network_subnet_ids: One or more Subnet ID's which should be able to access this Key Vault.
variable "network_acls" {
  type = list(object({
    default_action             = string,
    bypass                     = string,
    ip_rules                   = list(string),
    virtual_network_subnet_ids = list(string)
  }))
  description = "Network ACLs to associate to the Azure Key Vault"
  default = [{
    default_action             = "Deny",
    bypass                     = "None",
    ip_rules                   = null,
    virtual_network_subnet_ids = []
  }]
}

variable "keys" {
  description = "List of keys to be stored in key vault."
  type        = any
  default     = []
}

variable "default_key_opts" {
  description = "Default set of key options."
  type        = list(string)
  default     = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]
}

variable "location" {
  description = "Specify the supported Azure location where the resource exists."
  type        = string
}

