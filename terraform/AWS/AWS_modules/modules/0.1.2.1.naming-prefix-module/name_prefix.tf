
locals {
  name_prefix = "${var.app_name}${var.custom_name1}-${var.environment}-${var.project}-${var.sequence}"
}
#################################
variable "app_name" {
  description = "app_name or instance name"
  type        = string
  default     = "NGNX-webinstance"
}
variable "custom_name1" {
  description = "custom_name"
  type        = string
  default     = ""
}
# variable "custom_name2" {
#   description = "custom_name"
#   type = string
#   default = ""
# }
variable "sequence" {
  type    = string
  default = "001"
}