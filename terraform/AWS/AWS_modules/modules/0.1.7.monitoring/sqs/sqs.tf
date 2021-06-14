locals {
  redrive_policy = "{\"deadLetterTargetArn\":\"${var.dead_letter_target_arn}\",\"maxReceiveCount\":${var.max_receive_count}}"
}

resource "aws_sqs_queue" "queue" {
  content_based_deduplication       = var.content_based_deduplication
  delay_seconds                     = var.delay_seconds
  fifo_queue                        = var.fifo_queue
  kms_master_key_id                 = var.kms_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  max_message_size                  = var.max_message_size
  message_retention_seconds         = var.message_retention_seconds
  name                              = var.name
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  redrive_policy                    = var.enable_redrive_policy ? local.redrive_policy : ""
  tags = merge( 
    var.additional_tags,  
    {
      
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
      sequence    = count.index + 001
    },
    var.tags
  )
  visibility_timeout_seconds        = var.visibility_timeout_seconds
}

# SQS Queue Policy.
resource "aws_sqs_queue_policy" "sqs_policy" {
  count = var.enable_sqs_queue_policy ? 1 : 0

  queue_url = aws_sqs_queue.queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage"
      ],
      "Resource": [
        "${aws_sqs_queue.queue.arn}"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${var.role_arn}"
        ]
      }
    }
  ]
}
POLICY

}

# Create Route53 record
resource "aws_route53_record" "zone_record_alias" {
  count = var.create_internal_zone_record ? 1 : 0

  name    = "${var.internal_record_name}.${var.internal_zone_name}"
  records = [aws_sqs_queue.queue.id]
  ttl     = 300
  type    = "CNAME"
  zone_id = var.route_53_hosted_zone_id
}
