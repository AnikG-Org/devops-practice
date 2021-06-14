output "topic_arn" {
  description = "The ARN of the SNS Topic"
  value       = aws_sns_topic.topic[*].arn
}

output "topic_id" {
  description = "The id of the SNS topic."
  value       = aws_sns_topic.topic[*].id
}