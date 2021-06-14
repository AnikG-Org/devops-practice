variable "enable_workspace" {
  description = "(optional)"
  type        = bool
  default     = false
}
variable "ws_count" {
  description = "(optional)"
  type        = number
  default     = 1
}
variable "bundle_id" {
  description = "(required)"
  type        = string
  default     = ""
}

variable "directory_id" {
  description = "(required)"
  type        = string
  default     = ""
}

variable "root_volume_encryption_enabled" {
  description = "(optional)"
  type        = bool
  default     = null
}

variable "tags" {
  description = "(optional)"
  type        = map(string)
  default     = null
}

variable "user_name" {
  description = "(required)"
  type        = string
  default     = ""
}

variable "user_volume_encryption_enabled" {
  description = "(optional)"
  type        = bool
  default     = null
}

variable "volume_encryption_key" {
  description = "(optional)"
  type        = string
  default     = null
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

variable "workspace_properties" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = set(object(
    {
      compute_type_name                         = string
      root_volume_size_gib                      = number
      running_mode                              = string
      running_mode_auto_stop_timeout_in_minutes = number
      user_volume_size_gib                      = number
    }
  ))
  default = []
}
################
variable "enable_workspace_ip_group" {
  description = "(optional)"
  type        = bool
  default     = false
}
variable "description" {
  description = "(optional)"
  type        = string
  default     = null
}

variable "ip_group_name" {
  description = "(required)"
  type        = string
  default     = ""
}

variable "rules" {
  description = "nested block: NestingSet, min items: 0, max items: 0"
  type = set(object(
    {
      description = string
      source      = string
    }
  ))
  default = []
}
#####################
