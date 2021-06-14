output "output_dynamicsg_v2" {
  value = aws_security_group.dynamicsg_2[*].id
}