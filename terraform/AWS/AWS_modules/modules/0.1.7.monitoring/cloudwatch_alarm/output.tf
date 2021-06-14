output "alarm_id" {
  description = "List of created alarm names"
  value       = aws_cloudwatch_metric_alarm.alarm.*.id
}