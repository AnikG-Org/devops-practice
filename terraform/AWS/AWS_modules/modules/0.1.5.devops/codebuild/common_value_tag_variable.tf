################################################################################
##TF provider
################################################################################
# provider "aws" {
#   region = var.provider_region

#   default_tags {
#     tags = {
#       Environment     = var.Environment
#       Created_Via     = "Terraform IAAC"
#       Project         = var.project
#       SCM             = var.git_repo
#       ServiceProvider = var.ServiceProvider
#     }
#   }
# }

#tag#--------------------------------------- 
variable "ServiceProvider" { default = "" }
#VPC#---------------------------------------
variable "provider_region" {
  default     = "us-east-1"
  type        = string
  description = "Region of the VPC/provider"
}
#-------------------------------------------
# variable "name" {
#   default     = ""
#   type        = string
#   description = "Name of the VPC"
# }

variable "git_repo" { default = "" }

variable "project" {
  default     = ""
  type        = string
  description = "Name of project this VPC is meant to house - note name as per s3 naming guidelines"
}

variable "Environment" {
  default     = ""
  type        = string
  description = "Name of environment this VPC is targeting"
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the VPC resources"
}