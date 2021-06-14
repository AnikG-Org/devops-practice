output "arn" {
  description = "The full Amazon Resource Name (ARN) of the task definition"
  value       = aws_ecs_task_definition.service.*.arn
}
output "task_arn" {
  description = "The full Amazon Resource Name (ARN) of the task definition"
  value       = join("", aws_ecs_task_definition.service.*.arn)
}
output "container_definitions" {
  description = "A list of container definitions in JSON format that describe the different containers that make up your task"
  value       = aws_ecs_task_definition.service.*.container_definitions
}

output "name" {
  description = "The family of your task definition, used as the definition name"
  value       = aws_ecs_task_definition.service.*.family
}


