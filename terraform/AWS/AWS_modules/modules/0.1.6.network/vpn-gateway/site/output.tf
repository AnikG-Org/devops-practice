########################################## CGW
output "cgw_id" {
  description = "List of IDs of Customer Gateway"
  value       = (concat(local.aws_customer_gateway_id, [var.existing_customer_gateway])) #[for k, v in aws_customer_gateway.this : v.id]
}
output "customer_gateway" {
  description = "Map of Customer Gateway attributes"
  value       = aws_customer_gateway.this
}
########################################## VGW
output "vgw_id" {
  description = "The ID of the VPN Gateway"
  value       = concat(aws_vpn_gateway.this.*.id, [var.existing_vpn_gateway])
}
output "vgw_arn" {
  description = "The ARN of the VPN Gateway"
  value       = concat(aws_vpn_gateway.this.*.arn, [""])[0]
}
##########################################
output "vpn_connection_id" {
  description = "A list with the VPN Connection ID if `create_vpn_connection = true`, or empty otherwise"
  value = element(
    concat(
      aws_vpn_connection.vpn.*.id,
      [""],
    ),
    0,
  )
}

