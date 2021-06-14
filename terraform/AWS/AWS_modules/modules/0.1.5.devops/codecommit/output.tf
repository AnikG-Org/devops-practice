output "arn" {
  description = "The ARN of the repository"
  value       = aws_codecommit_repository.repo.arn
}

output "clone_url_http" {
  description = "The URL to use for cloning the repository over HTTPS."
  value       = aws_codecommit_repository.repo.clone_url_http
}

output "clone_url_ssh" {
  description = "The URL to use for cloning the repository over SSH."
  value       = aws_codecommit_repository.repo.clone_url_ssh
}

output "repository_id" {
  description = "The ID of the repository"
  value       = aws_codecommit_repository.repo.repository_id
}