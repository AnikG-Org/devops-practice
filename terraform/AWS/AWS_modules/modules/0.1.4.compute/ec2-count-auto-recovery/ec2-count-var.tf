#EC2 variable
variable "instance_count" {
  type = number
  default = 1 
}
variable "ami" {}
variable "instance_type" { default = "t3.micro" }
variable "iam_instance_profile" { default = "" }
variable "subnet_id" {}
variable "key_name" {}
variable "monitoring" {
  type    = bool
  default = true
}
variable "associate_public_ip_address" {
  type    = bool
  default = false
}
variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = null
}
variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption."
  type        = string
  default     = null
}
variable "security_groups" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = [] #[null]
}
variable "vpc_security_group_ids" {
  description = "A list of security group IDs .NOTE:#If you are creating Instances in a VPC, use vpc_security_group_ids instead.(Optional, VPC only) A list of security group IDs to associate with. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#vpc_security_group_ids"
  type        = list(string)
  default     = [] #[null]
}
 /*
variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
} */
variable "private_ips" {
  description = "A list of private IP address to associate with the instance in a VPC. Should match the number of instances."
  type        = list(string)
  default     = []
}
variable "cpu_credits" {
  description = "The credit option for CPU usage (unlimited or standard)"
  type        = string
  default     = "standard"
}
variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  type        = bool
  default     = true
}
variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = false
}
variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance"
  type        = string
  default     = "stop"
}
variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host."
  type        = string
  default     = "default"
}
variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}
variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type        = list(map(string))
  default     = []
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type        = map(string)
  default     = {}
}
variable "ec2_count_depends_on" {
  type = any
  default = []
}
#storage
variable "root_block_volume_type" { default = "gp2" }
variable "root_block_volume_size" {
  type    = number
  default = null
}
variable "root_block_device_iops" {
  type    = number
  default = null
}
variable "root_block_device_encryption" {
  type    = bool
  default = false
}
variable "kms_key_id" { default = "" }
variable "root_block_device_delete_on_termination" {
  type    = bool
  default = true
}
# variable "root_block_device_name" { default = "/dev/sda1" }
#tag_variable
variable "ec2tagname" {}
variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}
#auto_recovery_alarm
variable "enable_auto_recovery_alarm" {
  type    = bool
  default = true
}
variable "threshold" {
  type    = number
  default = 1
}
#route 53
variable "enable_public_route53_record" {
  type        = bool
  default     = false
  description = "enable if public instance have elastic/static public IP only"
}
variable "enable_private_route53_record" {
  type        = bool
  default     = false
  description = "enable if private instance have created and having private IP only"
}
variable "route53_hosted_zone_id" { default = "" }
variable "health_check_path" { default = "" }
variable "record_name" {
   type = string
   default = ""
} 

