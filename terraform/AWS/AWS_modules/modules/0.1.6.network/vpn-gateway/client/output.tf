output "aws_ec2_client_vpn_endpoint_dns" {
  description = "client vpn end point DNS"
  value       = aws_ec2_client_vpn_endpoint.client_vpn.dns_name
}

output "aws_ec2_client_vpn_endpoint_id" {
  description = "client vpn end point id"
  value       = aws_ec2_client_vpn_endpoint.client_vpn.id
}
