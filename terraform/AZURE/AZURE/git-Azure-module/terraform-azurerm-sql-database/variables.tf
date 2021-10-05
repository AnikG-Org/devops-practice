variable "name" {
  description = "The name of the database."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the database. This must be the same as Database Server resource group currently."
  type        = string
}

variable "server_name" {
  description = "he name of the SQL Server on which to create the database."
  type        = string
}

variable "db_edition" {
  description = "The edition of the database to be created.Valid values are: Basic, Standard, Premium, or DataWarehouse. Please see (https://azure.microsoft.com/en-gb/documentation/articles/sql-database-service-tiers/)."
  type        = string
}

variable "requested_service_objective_name" {
  description = "Use to set the performance level for the database.Valid values are: S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool."
  type        = string
}

variable "collation" {
  description = "The name of the collation.Azure default is SQL_LATIN1_GENERAL_CP1_CI_AS. Changing this forces a new resource to be created."
  default     = "SQL_LATIN1_GENERAL_CP1_CI_AS"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  default     = {}
  type        = map(string)
}

variable "location" {
  description = "Specify the supported Azure location where the resource exists."
  type        = string
}

variable "max_size_bytes" {
  description = "The maximum size that the database can grow to. Applies only if create_mode is Default."
  default     = "250000000000"
  type        = string
}

variable "default_rules" {
  description = "Whether or not to create the default rules"
  type        = bool
  default     = false
}

variable "threat_detection_policy" {
  description = "Threat detection policy configuration."
  type = list(object({
    state                      = string
    disabled_alerts            = list(string)
    email_account_admins       = string
    email_addresses            = list(string)
    retention_days             = number
    storage_account_access_key = string
    storage_endpoint           = string
    use_server_default         = string
  }))
}

variable "read_scale" {
  description = "Read-only connections will be redirected to a high-available replica"
  type        = bool
  default     = false
}

variable "zone_redundant" {
  description = "Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones"
  type        = bool
  default     = false
}

variable "elastic_pool_name" {
  description = "The name of the elastic database pool."
  type        = string
  default     = ""
}