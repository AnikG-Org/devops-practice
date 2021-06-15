variable "create_remote_state_s3" {
  type    = bool
  default = true
}

variable "bucket_name" {
  description = "the name to give the bucket"
  type        = string
  default     = "remote-state-store"
}
variable "s3_aws_region" { default = "us-east-1" }
variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}
variable "principals" {
  description = "list of user/role ARNs to get full access to the bucket"
  type        = list(string)
  default     = ["*"]
}

variable "versioning" {
  default     = false
  description = "enables versioning for objects in the S3 bucket"
  type        = bool
}

variable "region" {
  default     = ""
  description = "Region where the S3 bucket will be created"
  type        = string
}

variable "force_destroy" {
  description = "Whether to allow a forceful destruction of this bucket"
  default     = false
  type        = bool
}

variable "kms_key_id" {
  description = "The ARN of a KMS Key to use for encrypting the state"
  type        = string
  default     = ""
}
variable "enable_bucket_public_access_blocking" {
  type    = bool
  default = false
}
variable "lifecycle_rule" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []
}