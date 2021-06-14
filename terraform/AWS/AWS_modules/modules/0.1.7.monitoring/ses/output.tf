
output "domain_identity_arn" {
  value       = join("", aws_ses_domain_identity.default.*.arn)
  description = "ARN of the SES domain identity. Terraform module to create domain identity using domain"
}