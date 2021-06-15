#common var


#Launch template#
variable "aws_launch_template_create_lt" {
  description = "Determines whether to create launch template or not"
  type        = bool
  default     = true
}
variable "lt_name" {
  description = "Name used across the resources created"
  type        = string
  default     = "launch_template"
}
variable "name_prefix" {
  description = "Determines whether to use `lt_name` as is or create a unique name beginning with the `lt_name` as the prefix"
  type        = bool
  default     = true
}
variable "description" {
  description = "(LT) Description of the launch template"
  type        = string
  default     = null
}
variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}
variable "image_id" {
  type    = string
  default = ""
}
variable "instance_type" { default = "t3.micro" }
variable "key_name" {
  description = "The key name that should be used for the instance"
  type        = string
  default     = null
}
variable "user_data_base64" {
  description = "The Base64-encoded user data to provide when launching the instance"
  type        = string
  default     = null
}
variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate"
  type        = list(string)
  default     = null
}
variable "default_version" {
  description = "(LT) Default Version of the launch template"
  type        = string
  default     = null
}
variable "update_default_version" {
  description = "(LT) Whether to update Default Version each update. Conflicts with `default_version`"
  type        = string
  default     = "true"
}
variable "disable_api_termination" {
  description = "(LT) If true, enables EC2 instance termination protection"
  type        = bool
  default     = null
}

variable "instance_initiated_shutdown_behavior" {
  description = "(LT) Shutdown behavior for the instance. Can be `stop` or `terminate`. (Default: `stop`)"
  type        = string
  default     = "stop"
}

variable "kernel_id" {
  description = "(LT) The kernel ID"
  type        = string
  default     = null
}

variable "ram_disk_id" {
  description = "(LT) The ID of the ram disk"
  type        = string
  default     = null
}
variable "block_device_mappings" {
  description = "(LT) Specify volumes to attach to the instance besides the volumes specified by the AMI"
  type        = list(any)
  default     = []
}

variable "capacity_reservation_specification" {
  description = "(LT) Targeting for EC2 capacity reservations"
  type        = any
  default     = null
}

variable "cpu_options" {
  description = "(LT) The CPU options for the instance"
  type        = map(string)
  default     = null
}

variable "credit_specification" {
  description = "(LT) Customize the credit specification of the instance"
  type        = map(string)
  default     = null
}

variable "elastic_gpu_specifications" {
  description = "(LT) The elastic GPU to attach to the instance"
  type        = map(string)
  default     = null
}

variable "elastic_inference_accelerator" {
  description = "(LT) Configuration block containing an Elastic Inference Accelerator to attach to the instance"
  type        = map(string)
  default     = null
}

variable "enclave_options" {
  description = "(LT) Enable Nitro Enclaves on launched instances"
  type        = map(string)
  default     = null
}

variable "hibernation_options" {
  description = "(LT) The hibernation options for the instance"
  type        = map(string)
  default     = null
}
variable "iam_instance_profile_name" {
  description = "The name attribute of the IAM instance profile to associate with launched instances"
  type        = string
  default     = null
}
variable "iam_instance_profile_arn" {
  description = "(LT) The IAM Instance Profile ARN to launch the instance with"
  type        = string
  default     = null
}
variable "instance_market_options" {
  description = "(LT) The market (purchasing) option for the instance"
  type        = any
  default     = null
}
variable "license_specifications" {
  description = "(LT) A list of license specifications to associate with"
  type        = map(string)
  default     = null
}
variable "metadata_options" {
  description = "Customize the metadata options for the instance"
  type        = map(string)
  default     = null
}
variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring"
  type        = bool
  default     = null
}
variable "network_interfaces" {
  description = "(LT) Customize network interfaces to be attached at instance boot time"
  type        = list(any)
  default     = []
}
variable "placement" {
  description = "(LT) The placement of the instance"
  type        = map(string)
  default     = null
}



#tag_variable

variable "lttagname" {
  type    = string
  default = "aws_launch_template"
}
##marging LT variable{tag_specifications} default value with local{tag_specifications} need to change type > to map(list(any))
variable "tag_specifications" {
  description = "(LT) The tags to apply to the resources during launch"
  type        = list(any)
  default     = []
}
#########################################