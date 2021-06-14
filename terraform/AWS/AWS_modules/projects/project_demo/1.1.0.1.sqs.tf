# data "aws_caller_identity" "current" {
# }

# ########################################
# # standard_queue
# ########################################
# module "standard_queue" {
#   source          = "../../modules/0.1.7.monitoring/sqs"
#   

#   create_internal_zone_record = true
#   delay_seconds               = 90
#   enable_sqs_queue_policy     = true
#   internal_record_name        = "myqueue"
#   internal_zone_name          = local.domain_name
#   name                        = "myqueue"
#   max_message_size            = 2048
#   message_retention_seconds   = 86400
#   receive_wait_time_seconds   = 10
#   role_arn                    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ec2sqs"
#   route_53_hosted_zone_id     = module.r53_internal_zone.internal_hosted_zone_id
# }  
########################################
# encryption_queue
########################################
# module "encryption_queue" {
#   source          = "../../modules/0.1.7.monitoring/sqs"
#   

#   create_internal_zone_record       = true
#   delay_seconds                     = 90
#   enable_sqs_queue_policy           = true
#   internal_record_name              = "encrypted-queue"
#   internal_zone_name                = local.domain_name
#   kms_data_key_reuse_period_seconds = 300
#   kms_key_id                        = "alias/aws/sqs"
#   name                              = "encrypted-queue"
#   max_message_size                  = 2048
#   message_retention_seconds         = 86400
#   receive_wait_time_seconds         = 10
#   role_arn                          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ec2sqs"
#   route_53_hosted_zone_id           = module.r53_internal_zone.internal_hosted_zone_id
# }
# ########################################
# # 
# ########################################
# module "fifo_queue" {
#   source          = "../../modules/0.1.7.monitoring/sqs"
#   

#   content_based_deduplication = true
#   create_internal_zone_record = true
#   delay_seconds               = 90
#   enable_sqs_queue_policy     = true
#   fifo_queue                  = true
#   internal_record_name        = "fifo-queue"
#   internal_zone_name          = local.domain_name
#   name                        = "fifo-queue.fifo"
#   max_message_size            = 2048
#   message_retention_seconds   = 86400
#   receive_wait_time_seconds   = 10
#   role_arn                    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ec2sqs"
#   route_53_hosted_zone_id     = module.r53_internal_zone.internal_hosted_zone_id
# }
# ########################################
# # 
# ########################################
# module "fifo_encryption_queue" {
#   source          = "../../modules/0.1.7.monitoring/sqs"
#   

#   content_based_deduplication       = true
#   create_internal_zone_record       = true
#   delay_seconds                     = 90
#   enable_sqs_queue_policy           = true
#   fifo_queue                        = true
#   internal_record_name              = "encrypted-fifo-queue"
#   internal_zone_name                = local.domain_name
#   kms_data_key_reuse_period_seconds = 300
#   kms_key_id                        = "alias/aws/sqs"
#   max_message_size                  = 2048
#   message_retention_seconds         = 86400
#   name                              = "encrypted-fifo-queue.fifo"
#   receive_wait_time_seconds         = 10
#   role_arn                          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ec2sqs"
#   route_53_hosted_zone_id           = module.r53_internal_zone.internal_hosted_zone_id
# }
# ########################################
# # deadletter_queue
# ########################################
# module "deadletter_queue" {
#   source          = "../../modules/0.1.7.monitoring/sqs"
#   

#   create_internal_zone_record = true
#   enable_sqs_queue_policy     = true
#   internal_record_name        = "deadletter-queue"
#   internal_zone_name          = local.domain_name
#   name                        = "myqueue_deadletter"
#   role_arn                    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ec2sqs"
#   route_53_hosted_zone_id     = module.r53_internal_zone.internal_hosted_zone_id
# }
# ########################################
# # dl_source_queue
# ########################################
# module "dl_source_queue" {
#   source          = "../../modules/0.1.7.monitoring/sqs"
#   

#   create_internal_zone_record = true
#   dead_letter_target_arn      = module.deadletter_queue.arn
#   delay_seconds               = 90
#   enable_redrive_policy       = true
#   enable_sqs_queue_policy     = true
#   internal_record_name        = "myqueue"
#   internal_zone_name          = local.domain_name
#   name                        = "myqueue"
#   max_message_size            = 2048
#   message_retention_seconds   = 86400
#   receive_wait_time_seconds   = 10
#   role_arn                    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ec2sqs"
#   route_53_hosted_zone_id     = module.r53_internal_zone.internal_hosted_zone_id
# }
