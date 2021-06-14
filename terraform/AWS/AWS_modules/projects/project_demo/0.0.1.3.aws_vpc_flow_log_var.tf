variable "enable_cw_flow_log" {
  description = "Whether or not to enable VPC CloudWatch Flow Logs"
  type        = bool
  default     = false
}

variable "enable_s3_flow_log" {
  description = "Whether or not to enable VPC S3 Flow Logs"
  type        = bool
  default     = false
}

variable "enable_s3_for_flow_log" {
  description = "Whether or not to enable VPC S# Flow Logs , and if enable_s3_flow_log = true , then must enable S3 as well "
  type        = bool
  default     = false
}


