variable "active_directory_id" {
  description = "(optional)"
  type        = string
  default     = null
}

variable "automatic_backup_retention_days" {
  description = "(optional)"
  type        = number
  default     = 0
}

variable "copy_tags_to_backups" {
  description = "(optional)"
  type        = bool
  default     = null
}

variable "daily_automatic_backup_start_time" {
  description = "(optional) The preferred time (in HH:MM format) to take daily automatic backups, in the UTC time zone."
  type        = string
  default     = null
}

variable "deployment_type" {
  description = "(optional) Specifies the file system deployment type, valid values are MULTI_AZ_1, SINGLE_AZ_1 and SINGLE_AZ_2"
  type        = string
  default     = "SINGLE_AZ_1"
}

variable "kms_key_id" {
  description = "(optional)"
  type        = string
  default     = null
}

variable "preferred_subnet_id" {
  description = "(optional)"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "(optional)"
  type        = set(string)
  default     = null
}

variable "skip_final_backup" {
  description = "(optional)"
  type        = bool
  default     = false
}

variable "storage_capacity" {
  description = "(required)"
  type        = number
  default     = 32
}

variable "storage_type" {
  description = "(optional)"
  type        = string
  default     = "SSD"
}

variable "subnet_ids" {
  description = "(required)"
  type        = list(string)
  default     = [] 
}

variable "tags" {
  description = "(optional)"
  type        = map(string)
  default     = {}
}

variable "throughput_capacity" {
  description = "(required)"
  type        = number
  default     =  8
}

variable "weekly_maintenance_start_time" {
  description = "(optional)"
  type        = string
  default     = null
}

variable "self_managed_active_directory" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = set(object(
    {
      dns_ips                                = set(string)
      domain_name                            = string
      file_system_administrators_group       = string
      organizational_unit_distinguished_name = string
      password                               = string
      username                               = string
    }
  ))
  default = []
}

variable "timeouts" {
  description = "nested block: NestingSingle, min items: 0, max items: 0"
  type = set(object(
    {
      create = string
      delete = string
      update = string
    }
  ))
  default = []
}