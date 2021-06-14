variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues."
  type        = bool
  default     = false
}

variable "create_internal_zone_record" {
  description = "Create Route 53 internal zone record for the SQS QUEUE. i.e true | false"
  type        = bool
  default     = false
}

variable "dead_letter_target_arn" {
  description = "The Amazon Resource Name (ARN) of the dead-letter queue to which Amazon SQS moves messages"
  type        = string
  default     = ""
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes). The default for this attribute is 0 seconds."
  type        = number
  default     = 0
}

variable "enable_redrive_policy" {
  description = "Set to true to create a redrive policy for dead letter queue. Requires dead_letter_target_arn and dead_letter_url. Allowed values: true, false"
  type        = bool
  default     = false
}

variable "enable_sqs_queue_policy" {
  description = "Set to true to create a queue policy. Requires role_arn. Allowed values: true, false"
  type        = bool
  default     = false
}

# variable "environment" {
#   description = "Application environment for which this network is being created. one of: ('Development', 'Integration', 'PreProduction', 'Production', 'QA', 'Staging', 'Test')"
#   type        = string
#   default     = "Development"
# }

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue. If not set, it defaults to false making it standard."
  type        = bool
  default     = false
}

variable "internal_record_name" {
  description = "Record Name for the new Resource Record in the Internal Hosted Zone. i.e. myqueue."
  type        = string
  default     = ""
}

variable "internal_zone_name" {
  description = "TLD for Internal Hosted Zone. i.e. dev.example.com"
  type        = string
  default     = ""
}

variable "kms_data_key_reuse_period_seconds" {
  description = "The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours). The default is 300 (5 minutes).(OPTIONAL)"
  type        = number
  default     = 300
}

variable "kms_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK.(OPTIONAL)"
  type        = string
  default     = ""
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB). The default for this attribute is 262144 (256 KiB)."
  type        = number
  default     = 262144
}

variable "max_receive_count" {
  description = "The number of times a message is delivered to the source queue before being moved to the dead-letter queue."
  type        = number
  default     = 3
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. From 60 (1 minute) to 1209600 (14 days). The default for this attribute is 345600 (4 days)."
  type        = number
  default     = 345600
}

variable "name" {
  description = "The name of the queue."
  type        = string
  default     = ""
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds). The default for this attribute is 0, meaning that the call will return immediately."
  type        = number
  default     = 0
}

variable "role_arn" {
  description = "Enter an EC2 Instance Role allowed to talk with the SQS queue."
  type        = string
  default     = ""
}

variable "route_53_hosted_zone_id" {
  description = "The Route53 Internal Hosted Zone ID."
  type        = string
  default     = ""
}

# variable "tags" {
#   description = "Custom tags to apply to all resources."
#   type        = map(string)
#   default     = {}
# }

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours). The default for this attribute is 30. (OPTIONAL)"
  type        = number
  default     = 30
}