variable "s3_count" {
  type    = number
  default = 1
}
variable "acceleration_status" {
  description = "(Optional) Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended."
  type        = string
  default     = null
}
variable "request_payer" {
  description = "(Optional) Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. By default, the owner of the S3 bucket would incur the costs of any data transfer. See Requester Pays Buckets developer guide for more information."
  type        = string
  default     = null
}
variable "mys3_bucket_name" {
  type    = list(string)
  default = ["s3", "s3", "s3", "s3", "s3"]
}
variable "s3_aws_region" { default = "us-east-1" }
variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}
variable "force_destroy" {
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}
variable "acl" {
  description = "(Optional) ACL to apply. Defaults to 'private' https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl"
  type        = string
  default     = "private"
}
variable "block_public_acls" {
  type    = bool
  default = true
}
variable "block_public_policy" {
  type    = bool
  default = true
}
variable "ignore_public_acls" {
  type    = bool
  default = true
}
variable "restrict_public_buckets" {
  type    = bool
  default = true
}
variable "cors_rule" {
  description = "Object containing a rule of Cross-Origin Resource Sharing."
  type        = any
  default     = {}

  # Example:
  #
  # cors_rule = {
  #   allowed_headers = ["*"]
  #   allowed_methods = ["PUT", "POST"]
  #   allowed_origins = ["https://s3-website-test.example.com"]
  #   expose_headers  = ["ETag"]
  #   max_age_seconds = 3000
  # }
}
variable "logging" {
  description = "Map containing access bucket logging configuration."
  type        = map(string)
  default     = {}
}
variable "versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
  default     = {}
}
variable "object_lock_configuration" {
  description = "Permanently allows objects in this bucket to be locked. Additional Object Lock configuration is required in bucket details after bucket creation to protect objects in this bucket from being deleted or overwritten."
  type        = any
  default     = {}
}
variable "website" {
  description = "Map containing static web-site hosting or redirect configuration."
  type        = map(string)
  default     = {}
}

variable "lifecycle_rule" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = [] #[
  # Example:
  #
  #lifecycle_rule = [
  # {
  #   id      = "log"
  #   enabled = true

  #   prefix = "log/"

  #   tags = {
  #     "rule"      = "log"
  #     "autoclean" = "true"
  #   }
  #   transition = [
  #     {
  #       days          = 30
  #       storage_class = "STANDARD_IA" # or "ONEZONE_IA"
  #     },
  #   ]
  #   expiration = {
  #     days = 90
  #   }
  # }
  # ]
  #]
}
variable "server_side_encryption_configuration" {
  description = "Map containing server-side encryption configuration."
  type        = any
  default     = {}
}
variable "replication_configuration" {
  description = "Map containing cross-region replication configuration."
  type        = any
  default     = {}
}
################# S3_Inventory VAR ##################
variable "count_of_bucket_to_enable" {
  description = "(required when need to enable & how many bucket counts to enable )"
  type        = number
  default     = 0
}
variable "bucket_to_enable" {
  description = "(required when need to enable)"
  type        = string
  default     = null #aws_s3_bucket.mys3[count.index].id
}
variable "s3_bucket_inventory_enabled" {
  description = "(optional)"
  type        = bool
  default     = true
}

variable "included_object_versions" {
  description = "(required)"
  type        = string
  default     = "All"
}

variable "s3_bucket_inventory_name" {
  description = "(required)"
  type        = string
  default     = "s3_inventory"
}

variable "optional_fields" {
  description = "(optional)"
  type        = set(string)
  default     = null
}

variable "destination" {
  description = "nested block: NestingList, min items: 1, max items: 1"
  type = set(object(
    {
      bucket = list(object(
        {
          account_id = string
          bucket_arn = string
          encryption = list(object(
            {
              sse_kms = list(object(
                {
                  key_id = string
                }
              ))
              sse_s3 = list(object(
                {

                }
              ))
            }
          ))
          format = string
          prefix = string
        }
      ))
    }
  ))
  default = [
    {
      bucket = [{
        account_id = null
        bucket_arn = null
        encryption = [{
          sse_kms = [{
            key_id = null
          }]
          sse_s3 = [{

          }]
        }]
        format = null
        prefix = null
      }]
    }
  ]
}

variable "filter" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = set(object(
    {
      prefix = string
    }
  ))
  default = [
    {
      prefix = null
    }
  ]
}

variable "schedule" {
  description = "nested block: NestingList, min items: 1, max items: 1"
  type = set(object(
    {
      frequency = string
    }
  ))
  default = [
    {
      frequency = "Daily"
    }
  ]
}
###########################