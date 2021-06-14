#tag#---------------------------------------  
variable "ServiceProvider" { default = "" }
variable "name" {
  default     = "cloud_private"
  type        = string
  description = "Name to be used on all the resources as identifier"
}
variable "git_repo" { default = "" }
variable "project" {
  default     = ""
  type        = string
  description = "Name of project this VPC is meant to house - note name as per s3 naming guidelines"
}
variable "environment" {
  default     = ""
  type        = string
  description = "Name of environment this VPC is targeting"
}
variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the VPC resources"
}