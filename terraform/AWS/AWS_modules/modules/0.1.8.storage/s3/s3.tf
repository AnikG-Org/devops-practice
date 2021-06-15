data "aws_caller_identity" "current" {}
locals {
  cors_enabled  = length(keys(var.cors_rule)) > 0
  cors          = local.cors_enabled ? [var.cors_rule] : []
  origin_region = var.s3_aws_region
}
provider "aws" {
  alias  = "s3_aws_region"
  region = local.origin_region
}

#s3
resource "aws_s3_bucket" "mys3" {
  count               = var.s3_count
  provider            = aws.s3_aws_region
  bucket              = "${var.project}-${var.mys3_bucket_name[count.index]}-${count.index + 1}-${local.random_string}" #List [] for multiple counts 
  acl                 = var.acl
  force_destroy       = var.force_destroy
  acceleration_status = var.acceleration_status
  request_payer       = var.request_payer

  tags = merge(
    var.additional_tags,
    {
      s3_sequence     = count.index + 001
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
      SCM             = var.git_repo
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [tags.timestamp]
  }
  #################### S3 properties ####################
  dynamic "versioning" {
    for_each = length(keys(var.versioning)) == 0 ? [] : [var.versioning]

    content {
      enabled    = lookup(versioning.value, "enabled", null)
      mfa_delete = lookup(versioning.value, "mfa_delete", null)
    }
  }
  ##########
  dynamic "object_lock_configuration" {
    for_each = length(var.object_lock_configuration) != 0 ? [var.object_lock_configuration] : []

    content {
      object_lock_enabled = lookup(object_lock_configuration.value, "object_lock_enabled", null)

      dynamic "rule" {
        for_each = length(var.object_lock_configuration.rule) != 0 ? [var.object_lock_configuration.rule] : []

        content {
          default_retention {
            mode  = lookup(rule.value.default_retention, "mode", null)
            days  = lookup(rule.value.default_retention, "days", null)
            years = lookup(rule.value.default_retention, "years", null)
          }
        }
      }
    }
  }

  #Static website hosting
  dynamic "website" {
    for_each = length(keys(var.website)) == 0 ? [] : [var.website]

    content {
      index_document           = lookup(website.value, "index_document", null)
      error_document           = lookup(website.value, "error_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules            = lookup(website.value, "routing_rules", null)
    }
  }
  ##########
  dynamic "cors_rule" {
    for_each = local.cors

    content {
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", null)
    }
  }
  ##########
  dynamic "logging" {
    for_each = length(keys(var.logging)) == 0 ? [] : [var.logging]

    content {
      target_bucket = logging.value.target_bucket
      target_prefix = lookup(logging.value, "target_prefix", null)
    }
  }
  # Max 1 block - server_side_encryption_configuration
  dynamic "server_side_encryption_configuration" {
    for_each = length(keys(var.server_side_encryption_configuration)) == 0 ? [] : [var.server_side_encryption_configuration]

    content {

      dynamic "rule" {
        for_each = length(keys(lookup(server_side_encryption_configuration.value, "rule", {}))) == 0 ? [] : [lookup(server_side_encryption_configuration.value, "rule", {})]

        content {
          bucket_key_enabled = lookup(rule.value, "bucket_key_enabled", null)

          dynamic "apply_server_side_encryption_by_default" {
            for_each = length(keys(lookup(rule.value, "apply_server_side_encryption_by_default", {}))) == 0 ? [] : [
            lookup(rule.value, "apply_server_side_encryption_by_default", {})]

            content {
              sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
              kms_master_key_id = lookup(apply_server_side_encryption_by_default.value, "kms_master_key_id", null)
            }
          }
        }
      }
    }

  }
  ###################### management ########################    
  ########## lifecycle_rule ############
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule

    content {
      id                                     = lookup(lifecycle_rule.value, "id", null)
      prefix                                 = lookup(lifecycle_rule.value, "prefix", null)
      tags                                   = lookup(lifecycle_rule.value, "tags", null)
      abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)
      enabled                                = lifecycle_rule.value.enabled

      # Several blocks - transition
      dynamic "transition" {
        for_each = lookup(lifecycle_rule.value, "transition", [])
        content {
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }
      # Max 1 block - expiration
      dynamic "expiration" {
        for_each = length(keys(lookup(lifecycle_rule.value, "expiration", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "expiration", {})]
        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }

      # Several blocks - noncurrent_version_transition
      dynamic "noncurrent_version_transition" {
        for_each = lookup(lifecycle_rule.value, "noncurrent_version_transition", [])

        content {
          days          = lookup(noncurrent_version_transition.value, "days", null)
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
      # Max 1 block - noncurrent_version_expiration
      dynamic "noncurrent_version_expiration" {
        for_each = length(keys(lookup(lifecycle_rule.value, "noncurrent_version_expiration", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "noncurrent_version_expiration", {})]

        content {
          days = lookup(noncurrent_version_expiration.value, "days", null)
        }
      }
    }
  }
  ########## Replication_rules  ############
  # Max 1 block - replication_configuration
  dynamic "replication_configuration" {
    for_each = length(keys(var.replication_configuration)) == 0 ? [] : [var.replication_configuration]

    content {
      role = replication_configuration.value.role

      dynamic "rules" {
        for_each = replication_configuration.value.rules

        content {
          id       = lookup(rules.value, "id", null)
          priority = lookup(rules.value, "priority", null)
          prefix   = lookup(rules.value, "prefix", null)
          status   = rules.value.status

          dynamic "destination" {
            for_each = length(keys(lookup(rules.value, "destination", {}))) == 0 ? [] : [lookup(rules.value, "destination", {})]

            content {
              bucket             = destination.value.bucket
              storage_class      = lookup(destination.value, "storage_class", null)
              replica_kms_key_id = lookup(destination.value, "replica_kms_key_id", null)
              account_id         = lookup(destination.value, "account_id", null)

              dynamic "access_control_translation" {
                for_each = length(keys(lookup(destination.value, "access_control_translation", {}))) == 0 ? [] : [lookup(destination.value, "access_control_translation", {})]

                content {
                  owner = access_control_translation.value.owner
                }
              }
            }
          }

          dynamic "source_selection_criteria" {
            for_each = length(keys(lookup(rules.value, "source_selection_criteria", {}))) == 0 ? [] : [lookup(rules.value, "source_selection_criteria", {})]

            content {

              dynamic "sse_kms_encrypted_objects" {
                for_each = length(keys(lookup(source_selection_criteria.value, "sse_kms_encrypted_objects", {}))) == 0 ? [] : [lookup(source_selection_criteria.value, "sse_kms_encrypted_objects", {})]

                content {

                  enabled = sse_kms_encrypted_objects.value.enabled
                }
              }
            }
          }

          dynamic "filter" {
            for_each = length(keys(lookup(rules.value, "filter", {}))) == 0 ? [] : [lookup(rules.value, "filter", {})]

            content {
              prefix = lookup(filter.value, "prefix", null)
              tags   = lookup(filter.value, "tags", null)
            }
          }

        }
      }
    }
  }

}
####################### aws_s3_bucket_public_access_block #######################

resource "aws_s3_bucket_public_access_block" "mys3" {
  provider = aws.s3_aws_region
  count    = var.s3_count
  # S3 bucket-level Public Access Block configuration # default = true
  # Chain resources (s3_bucket -> s3_bucket_policy -> s3_bucket_public_access_block)
  # to prevent "A conflicting conditional operation is currently in progress against this resource." 

  bucket                  = aws_s3_bucket.mys3[count.index].id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  depends_on = [aws_s3_bucket.mys3]
}
####################### aws_s3_bucket_inventory #######################

resource "aws_s3_bucket_inventory" "mys3" {
  provider = aws.s3_aws_region
  count    = var.count_of_bucket_to_enable #enter count value of bucket/buckets to enable aws_s3_bucket_inventory
  # bucket - (required) is a type of string # use this format for > 1 count buckets >> #aws_s3_bucket.mys3[count.index].id
  bucket = var.bucket_to_enable
  # enabled -  is a type of bool #true by default
  enabled = var.s3_bucket_inventory_enabled
  # included_object_versions - (required) is a type of string
  included_object_versions = var.included_object_versions
  # name - (required) is a type of string
  name = var.s3_bucket_inventory_name
  # optional_fields - (optional) is a type of set of string
  optional_fields = var.optional_fields

  dynamic "destination" {
    for_each = var.destination
    content {

      dynamic "bucket" {
        for_each = destination.value.bucket
        content {
          # account_id - (optional) is a type of string
          account_id = bucket.value["account_id"]
          # bucket_arn - (required) is a type of string
          bucket_arn = bucket.value["bucket_arn"]
          # format - (required) is a type of string
          format = bucket.value["format"]
          # prefix - (optional) is a type of string
          prefix = bucket.value["prefix"]

          dynamic "encryption" {
            for_each = bucket.value.encryption
            content {

              dynamic "sse_kms" {
                for_each = encryption.value.sse_kms
                content {
                  # key_id - (required) is a type of string
                  key_id = sse_kms.value["key_id"]
                }
              }

              dynamic "sse_s3" {
                for_each = encryption.value.sse_s3
                content {
                }
              }

            }
          }

        }
      }

    }
  }

  dynamic "filter" {
    for_each = var.filter
    content {
      # prefix - (optional) is a type of string
      prefix = filter.value["prefix"]
    }
  }

  dynamic "schedule" {
    for_each = var.schedule
    content {
      # frequency - (required) is a type of string
      frequency = schedule.value["frequency"]
    }
  }
}
######################    #######################
