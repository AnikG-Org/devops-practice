#aws_flow_log CloudWatch Logging
/*
resource "aws_flow_log" "flow_log" {
  iam_role_arn    = aws_iam_role.flow_log.arn
  log_destination = aws_cloudwatch_log_group.flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.default.id
  max_aggregation_interval = "600"

  tags = merge(
    {
      Name        = "${var.project}-VPC-flow-log" ,
      Flowlog = "cloudwatch-flow-log-group"
    },
    var.tags
  )  
}
#------------------------------------
resource "aws_cloudwatch_log_group" "flow_log" {
  name = "vpc_flow_log"
}
#------------------------------------
resource "aws_iam_role" "flow_log" {
  name = "vpc_flow_log_role"

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
  name = "vpc_flow_log_policy"
  role = aws_iam_role.flow_log.id

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
} */
#------------------------------------
#S3 flow Logging
/*
resource "aws_flow_log" "s3_flow_log" {
  log_destination      = aws_s3_bucket.flow_log.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.default.id
  max_aggregation_interval = "600"

  tags = merge(
    {
      Name        = "${var.project}-S3-VPC-flow-log" ,
      Flowlog = "S3"
    },
    var.tags
  )  
}

#s3 make for flow log

resource "aws_s3_bucket" "flow_log" {
  bucket = "${var.project}-${local.random_name}"
  acl    = "private"
  #force_destroy = true 
  versioning {
    enabled = false
  }
    lifecycle_rule {
    prefix  = "AWSLogs/"
    enabled = true
    #expired_object_delete_marker = true
    #abort_incomplete_multipart_upload_days = 0
    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
      days          = 90
      storage_class = "GLACIER"
    }
    noncurrent_version_expiration {
      days = 180
    }
  }
 
  tags = merge(
    {
      used_for        = "${var.project}-VPC-flow-log" ,
    },
    var.tags
  ) 
} */
#------------------------------------
