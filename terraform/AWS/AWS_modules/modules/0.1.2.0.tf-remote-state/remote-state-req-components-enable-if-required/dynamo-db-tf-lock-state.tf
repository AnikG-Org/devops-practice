resource "aws_dynamodb_table" "terraform_state_lock" {
  count            = var.create_table ? 1 : 0
  name             = "${var.project}-${var.table_name}-${local.random_string}"
  read_capacity    = var.read_capacity
  write_capacity   = var.write_capacity
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type
  hash_key         = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  server_side_encryption {
    enabled     = var.server_side_encryption_enabled
    kms_key_arn = var.server_side_encryption_kms_key_arn
  }

  tags = merge(
    {
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.additional_tags,
    var.tags
  )
  # lifecycle {
  #   ignore_changes = [tags.timestamp]
  # }
}
####################
variable "table_name" { default = "terraform-lock" }
variable "create_table" {
  description = "Controls if DynamoDB table and associated resources are created"
  type        = bool
  default     = false
}
variable "write_capacity" {
  description = "The number of write units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = 5
}
variable "read_capacity" {
  description = "The number of read units for this table. If the billing_mode is PROVISIONED, this field should be greater than 0"
  type        = number
  default     = 5
}
variable "stream_enabled" {
  description = "Indicates whether Streams are to be enabled (true) or disabled (false)."
  type        = bool
  default     = false
}
variable "stream_view_type" {
  description = "When an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES."
  type        = string
  default     = null
}
variable "server_side_encryption_enabled" {
  description = "Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK)"
  type        = bool
  default     = false
}
variable "server_side_encryption_kms_key_arn" {
  description = "The ARN of the CMK that should be used for the AWS KMS encryption. This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb."
  type        = string
  default     = null
}