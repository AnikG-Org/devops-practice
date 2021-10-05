variable "name" {
  description = "The name of the SQL Server. This needs to be globally unique within Azure."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the SQL Server."
  type        = string
}

variable "sql_version" {
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
  default     = "12.0"
  type        = string
}

variable "administrator_login_username" {
  description = "The administrator login name for the new server."
  type        = string
}

variable "administrator_login_password" {
  description = "The password associated with the administrator_login user. Needs to comply with Azure's Password Policy."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "firewall_rules" {
  description = "List of firewall rules to be attached to the SQL server."
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = []
}

variable "vnet_rules" {
  description = "List of vnet rules to be attached to the SQL server."
  type = list(object({
    name      = string
    subnet_id = string
  }))
  default = []
}

variable "database_names" {
  description = "List of database names to be created on the SQL server."
  type        = list(string)
  default     = []
}

variable "identity_type" {
  description = "Specifies the identity type of the Microsoft SQL Server. At this time the only allowed value is SystemAssigned."
  type        = string
  default     = "SystemAssigned"
}

variable "connection_policy" {
  type        = string
  description = "The connection policy the server will use. Possible values are Default, Proxy, and Redirect."
  default     = "Default"
}

variable "storage_account_access_key" {
  type        = string
  description = "Specifies the access key to use for the auditing storage account."
  default     = null
}

variable "storage_endpoint" {
  type        = string
  description = "Specifies the blob storage endpoint"
  default     = null
}

variable "storage_account_access_key_is_secondary" {
  type        = bool
  description = "Specifies whether storage_account_access_key value is the storage's secondary key."
  default     = false
}

variable "retention_in_days" {
  type        = number
  description = "Specifies the number of days to retain logs for in the storage account."
  default     = null
}

variable "create_mode" {
  type        = string
  description = "Specifies how to create the database. Valid values are: Default, Copy, OnlineSecondary, NonReadableSecondary, PointInTimeRestore, Recovery, Restore or RestoreLongTermRetentionBackup."
  default     = "Default"
}

variable "edition" {
  type        = string
  description = "The edition of the database to be created."
  default     = null
}

variable "max_size_bytes" {
  type        = number
  description = "The maximum size that the database can grow to."
  default     = null
}

variable "requested_service_objective_name" {
  type        = string
  description = "The service objective name for the database. Valid values depend on edition and location and may include S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool."
  default     = null
}

variable "zone_redundant" {
  type        = bool
  description = "Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones."
  default     = false
}

variable "ad_administrator_login" {
  type        = string
  description = "Login name of a user or a group that will be AD administrator for an Azure SQL server. Must be set together with ad_administrator_object_id."
  default     = null
}

variable "ad_administrator_object_id" {
  type        = string
  description = "Object ID of a user or a group that will be AD administrator for an Azure SQL server. Must be set together with ad_administrator_login."
  default     = null
}