output "application_name" {
  description = "CodeDeploy Application Name"
  value       = local.application_name
}

output "deployment_group_iam_role" {
  description = "IAM Role associated to the CodeDeploy Deployment Group"
  value       = zipmap(["server","ecs"], [aws_iam_role.role.name,aws_iam_role.role_1.name])
}

output "deployment_group_iam_role_arn" {
  description = "IAM Role associated to the CodeDeploy Deployment Group"
  value       = zipmap(["server","ecs"], [aws_iam_role.role.arn, aws_iam_role.role_1.arn])
}

output "deployment_group_name" {
  description = "CodeDeploy deployment_group Name"
  value       = concat(aws_codedeploy_deployment_group.deployment_group[*].deployment_group_name, aws_codedeploy_deployment_group.ecs_deployment_group[*].deployment_group_name)
}