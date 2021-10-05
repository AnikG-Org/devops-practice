variable "name" {
  type        = string
  description = "The name of the failover group."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group containing the SQL server"
}

variable "primary_server_name" {
  type        = string
  description = "The name of the primary SQL server."
}

variable "databases" {
  type        = list(any)
  description = "The Database ids to add to the failover group"
}

variable "secondary_server_id" {
  type        = string
  description = "The SQL server ID"
}

variable "read_write_endpoint_failover_policy" {
  type = list(object(
    {
      read_write_mode = string,
      grace_minutes   = string
    }
  ))
}

variable "readonly_endpoint_failover_policy" {
  type = list(object(
    {
      readonly_mode = string
    }
  ))
  default = []
}

variable "tags" {
  description = "Map of tags to be attached to the resource group."
  type        = map(string)
}