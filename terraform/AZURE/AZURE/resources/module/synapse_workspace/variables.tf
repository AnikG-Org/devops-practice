
variable "name" {

}
variable "resource_group_name" {

}
variable "location" {

}

variable "storage_data_lake_gen2_filesystem_id" {

}

variable "sql_administrator_login" {

}
variable "sql_administrator_login_password" {

}

variable "tags" {
  description = "Tags to be attached to synapse-workspace"
  default     = {}
  type        = map
}
