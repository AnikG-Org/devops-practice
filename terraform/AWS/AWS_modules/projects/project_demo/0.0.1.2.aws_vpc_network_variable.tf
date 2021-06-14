
#VPC#---------------------------------------
variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Region of the VPC"
}
variable "instance_tenancy" {
  default     = "default"
  type        = string
  description = "VPC instance tenancy"
}

#NetWork #---------------------------------------
variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}
variable "cloud_cidr_block" {
  default     = ["10.0.0.0/16"]
  type        = list
  description = "CIDR block for On-Prem network"
}
variable "on_prem_cidr_block" {
  default     = ["192.168.0.0/16"]
  type        = list
  description = "CIDR block for On-Prem network"
}
##---------------------------------------
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
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  type        = list
  description = "List of Subnet Network availability zones"
}

#---------------------------------------
#S3 vpc end point
variable "enable_vpc_s3_endpoint" {
  description = "Whether or not to enable VPC enable_vpc_endpoint for s3"
  type        = bool
  default     = false
}
