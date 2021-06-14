output "ecs_service_id" {
  description = "ARN of the ECS service."
  value       = aws_ecs_service.service.*.id
}
output "ecs_service_name" {
  description = "Name of the ECS service."
  value       = aws_ecs_service.service.*.name
}
