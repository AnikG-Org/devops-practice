resource "aws_sns_topic" "topic" {
  count = var.create_sns_topic ? 1 : 0  
  name = var.name
  name_prefix = var.name_prefix

  display_name                             = var.display_name
  policy                                   = var.policy
  delivery_policy                          = var.delivery_policy
  application_success_feedback_role_arn    = var.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.application_success_feedback_sample_rate
  application_failure_feedback_role_arn    = var.application_failure_feedback_role_arn
  http_success_feedback_role_arn           = var.http_success_feedback_role_arn
  http_success_feedback_sample_rate        = var.http_success_feedback_sample_rate
  http_failure_feedback_role_arn           = var.http_failure_feedback_role_arn
  lambda_success_feedback_role_arn         = var.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate      = var.lambda_success_feedback_sample_rate
  lambda_failure_feedback_role_arn         = var.lambda_failure_feedback_role_arn
  sqs_success_feedback_role_arn            = var.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate         = var.sqs_success_feedback_sample_rate
  sqs_failure_feedback_role_arn            = var.sqs_failure_feedback_role_arn
  kms_master_key_id                        = var.kms_master_key_id

  tags = merge( 
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
}

resource "aws_sns_topic_subscription" "subscription1" {
  count = var.create_subscription_1 ? 1 : 0

  endpoint               = var.endpoint_1
  endpoint_auto_confirms = var.endpoint_auto_confirms_1
  protocol               = var.protocol_1
  topic_arn              = aws_sns_topic.topic[0].arn
}

resource "aws_sns_topic_subscription" "subscription2" {
  count = var.create_subscription_2 ? 1 : 0

  endpoint               = var.endpoint_2
  endpoint_auto_confirms = var.endpoint_auto_confirms_2
  protocol               = var.protocol_2
  topic_arn              = aws_sns_topic.topic[0].arn
}

resource "aws_sns_topic_subscription" "subscription3" {
  count = var.create_subscription_3 ? 1 : 0

  endpoint               = var.endpoint_3
  endpoint_auto_confirms = var.endpoint_auto_confirms_3
  protocol               = var.protocol_3
  topic_arn              = aws_sns_topic.topic[0].arn
}

resource "aws_sns_topic_subscription" "subscription4" {
  count = var.create_subscription_4 ? 1 : 0

  endpoint               = var.endpoint_4
  endpoint_auto_confirms = var.endpoint_auto_confirms_4
  protocol               = var.protocol_4
  topic_arn              = aws_sns_topic.topic[0].arn
}

resource "aws_sns_topic_subscription" "subscription5" {
  count = var.create_subscription_5 ? 1 : 0

  endpoint               = var.endpoint_5
  endpoint_auto_confirms = var.endpoint_auto_confirms_5
  protocol               = var.protocol_5
  topic_arn              = aws_sns_topic.topic[0].arn
}