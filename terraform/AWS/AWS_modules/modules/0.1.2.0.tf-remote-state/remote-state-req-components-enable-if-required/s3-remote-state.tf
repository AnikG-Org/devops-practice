/**
 * ## S3 Bucket to Store Remote State
 *
 * This module creates a private S3 bucket and IAM policy to access that bucket.
 * The bucket can be used as a remote storage bucket for `terraform`, `kops`, or
 * similar tools.
 *
 */
locals {
  origin_region = var.s3_aws_region
}
provider "aws" {
  alias  = "s3_aws_region"
  region = local.origin_region
}

resource "aws_s3_bucket" "remote_state" {
  count         = var.create_remote_state_s3 ? 1 : 0
  bucket        = "${var.project}-${var.bucket_name}-${local.random_string}"
  acl           = "private"
  provider      = aws.s3_aws_region
  force_destroy = var.force_destroy

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

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = var.versioning
  }
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule
    iterator = rule
    content {
      id                                     = lookup(rule.value, "id", null)
      prefix                                 = lookup(rule.value, "prefix", null)
      tags                                   = lookup(rule.value, "tags", null)
      abort_incomplete_multipart_upload_days = lookup(rule.value, "abort_incomplete_multipart_upload_days", null)
      enabled                                = rule.value.enabled

      dynamic "expiration" {
        for_each = length(keys(lookup(rule.value, "expiration", {}))) == 0 ? [] : [rule.value.expiration]

        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }

      dynamic "transition" {
        for_each = lookup(rule.value, "transition", [])

        content {
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = length(keys(lookup(rule.value, "noncurrent_version_expiration", {}))) == 0 ? [] : [rule.value.noncurrent_version_expiration]
        iterator = expiration

        content {
          days = lookup(expiration.value, "days", null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lookup(rule.value, "noncurrent_version_transition", [])
        iterator = transition

        content {
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }
    }
  }

}

###########


########### Policy attachment
# resource "aws_s3_bucket_policy" "s3-full-access" {
#   bucket = aws_s3_bucket.remote_state[0].id
#   policy = data.aws_iam_policy_document.bucket-full-access.json
# }

# ######################
# # Lookup the current AWS partition
# data "aws_partition" "current" {
# }
# ######################
# data "aws_iam_policy_document" "s3-full-access" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:ListBucket",
#       "s3:GetBucketLocation",
#       "s3:ListBucketMultipartUploads",
#     ]
#     # principals {
#     #   type        = "AWS"
#     #   identifiers = compact(var.principals)
#     # }
#     resources = ["arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.remote_state[0].id}"]
#   }

#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:PutObject",
#       "s3:GetObject",
#       "s3:DeleteObject",
#       "s3:ListMultipartUploadParts",
#       "s3:AbortMultipartUpload",
#     ]
#     # principals {
#     #   type        = "AWS"
#     #   identifiers = compact(var.principals)
#     # }
#     resources = ["arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.remote_state[0].id}/*"]
#   }
# }
# #---------------------
# resource "aws_iam_policy" "s3-full-access" {
#   name   = "s3-${var.bucket_name}-s3-full-access-${local.random_string}"
#   policy = data.aws_iam_policy_document.s3-full-access.json
# }

# ###########
# data "aws_iam_policy_document" "bucket-full-access" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:ListBucket",
#       "s3:GetBucketLocation",
#       "s3:ListBucketMultipartUploads",
#     ]
#     principals {
#       type        = "AWS"
#       identifiers = compact(var.principals)
#     }

#     resources = ["arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.remote_state[0].id}"]
#   }

#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:PutObject",
#       "s3:GetObject",
#       "s3:DeleteObject",
#       "s3:ListMultipartUploadParts",
#       "s3:AbortMultipartUpload",
#     ]
#     principals {
#       type        = "AWS"
#       identifiers = compact(var.principals)
#     }
#     resources = ["arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.remote_state[0].id}/*"]
#   }
# }
# #---------------------
# # resource "aws_iam_policy" "bucket-full-access" {
# #   name   = "s3-${var.bucket_name}-bucket-full-access-${local.random_string}"
# #   policy = data.aws_iam_policy_document.bucket-full-access.json
# # }
# ######################
# data "aws_iam_policy_document" "bucket-full-access-with-mfa" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:ListBucket",
#       "s3:GetBucketLocation",
#       "s3:ListBucketMultipartUploads",
#     ]
#     # principals {
#     #   type        = "AWS"
#     #   identifiers = compact(var.principals)
#     # }
#     resources = ["arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.remote_state[0].id}"]
#   }

#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:PutObject",
#       "s3:GetObject",
#       "s3:DeleteObject",
#       "s3:ListMultipartUploadParts",
#       "s3:AbortMultipartUpload",
#     ]
#     # principals {
#     #   type        = "AWS"
#     #   identifiers = compact(var.principals)
#     # }
#     resources = ["arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.remote_state[0].id}/*"]

#     condition {
#       test     = "Bool"
#       variable = "aws:MultiFactorAuthPresent"
#       values   = [true]
#     }
#   }
# }
# #---------------------
# resource "aws_iam_policy" "bucket-full-access-with-mfa" {
#   name   = "s3-${var.bucket_name}-full-access-with-mfa-${local.random_string}"
#   policy = data.aws_iam_policy_document.bucket-full-access-with-mfa.json
# }

####################### aws_s3_bucket_public_access_block #######################

resource "aws_s3_bucket_public_access_block" "s3" {
  provider = aws.s3_aws_region
  count    = var.enable_bucket_public_access_blocking ? 1 : 0
  # S3 bucket-level Public Access Block configuration # default = true
  # Chain resources (s3_bucket -> s3_bucket_policy -> s3_bucket_public_access_block)
  # to prevent "A conflicting conditional operation is currently in progress against this resource." 

  bucket                  = aws_s3_bucket.remote_state[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.remote_state]
}
######################