
#for global value usage
provider "aws" {
  region                  = var.provider_region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
  access_key              = var.AWS_ACCESS_KEY_ID
  secret_key              = var.AWS_SECRET_ACCESS_KEY

  default_tags {
    tags = {
      # Environment     = var.environment
      # Project         = var.project
      # SCM             = var.git_repo
      # ServiceProvider = var.ServiceProvider
      # Created_Via = "Terraform IAAC"
    }
  }
}
#Provider #---------------------------------------
variable "provider_region" {
  #default     = "us-east-1"
  type        = string
  description = "Region of the Provider"
}

variable "shared_credentials_file" {
  default = ""
}
variable "profile"{
  default = ""
}

variable "AWS_ACCESS_KEY_ID" {
  default = ""
}
variable "AWS_SECRET_ACCESS_KEY" {
  default = ""
}

