#tag#---------------------------------------  
variable "name" {
  default     = "cloud_private"
  type        = string
  description = "Name of the VPC"
}

variable "git_repo" {default = "test-git-repo" }

variable "project" {
  default     = "test-project"
  type        = string
  description = "Name of project this VPC is meant to house"
}

variable "environment" {
  default     = "dev"
  type        = string
  description = "Name of environment this VPC is targeting"
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the VPC resources"
}
#Provider #---------------------------------------
variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Region of the VPC"
}

#NetWork #---------------------------------------
variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr_blocks" {
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
  type        = list
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidr_blocks" {
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  type        = list
  description = "List of private subnet CIDR blocks"
}
##---------------------------------------
variable "availability_zones" {
  default     = ["us-east-1a", "us-east-1b","us-east-1c"]
  type        = list
  description = "List of Subnet Network availability zones"
}

#---------------------------------------
#S3 for flow log

