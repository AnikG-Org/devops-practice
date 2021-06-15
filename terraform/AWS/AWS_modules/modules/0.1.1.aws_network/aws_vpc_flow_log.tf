locals {
  enable_cw_flow_log = var.enable_cw_flow_log

  enable_s3_flow_log     = var.enable_s3_flow_log
  enable_s3_for_flow_log = local.enable_s3_flow_log && var.enable_s3_for_flow_log
}
#-------------------------------------------------------------
#aws_flow_log CloudWatch Logging

resource "aws_flow_log" "flow_log" {
  count = local.enable_cw_flow_log ? 1 : 0

  iam_role_arn             = aws_iam_role.flow_log[count.index].arn
  log_destination          = aws_cloudwatch_log_group.flow_log[count.index].arn
  traffic_type             = "ALL"
  vpc_id                   = aws_vpc.default.id
  max_aggregation_interval = "600"

  tags = merge(
    {
      Name            = "${var.project}-VPC-flow-log",
      Flowlog         = "cloudwatch-flow-log-group"
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
}
#------------------------------------
resource "aws_cloudwatch_log_group" "flow_log" {
  name  = "vpc_flow_log"
  count = local.enable_cw_flow_log ? 1 : 0
}
#------------------------------------
resource "aws_iam_role" "flow_log" {
  name               = "vpc_flow_log_role"
  count              = local.enable_cw_flow_log ? 1 : 0
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "flow_log" {
  name  = "vpc_flow_log_policy"
  count = local.enable_cw_flow_log ? 1 : 0
  role  = aws_iam_role.flow_log[count.index].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
#------------------------------------
#S3 flow Logging

resource "aws_flow_log" "s3_flow_log" {
  count = local.enable_s3_flow_log ? 1 : 0

  log_destination          = aws_s3_bucket.flow_log[count.index].arn
  log_destination_type     = "s3"
  traffic_type             = "ALL"
  vpc_id                   = aws_vpc.default.id
  max_aggregation_interval = "600"

  tags = merge(
    {
      Name            = "${var.project}-S3-VPC-flow-log",
      Flowlog         = "S3"
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
}

#--------------------------------------------------------
#s3 make for flow log

resource "aws_s3_bucket" "flow_log" {
  count = local.enable_s3_for_flow_log ? 1 : 0

  bucket = "${var.project}-vpc-flowlog-${local.random_string}"
  acl    = "private"
  #force_destroy = true 
  versioning {
    enabled = false
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

  tags = merge(
    {
      used_for        = "${var.project}-VPC-flow-log"
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
}
#------------------------------------
