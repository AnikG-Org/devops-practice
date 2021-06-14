output "internal_hosted_name" {
  description = "Hosted Zone Name"
  value       = aws_route53_zone.internal_zone.name
}

output "internal_hosted_zone_id" {
  description = "Hosted Zone ID"
  value       = aws_route53_zone.internal_zone.id
}
