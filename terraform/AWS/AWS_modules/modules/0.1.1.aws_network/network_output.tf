output "vpc_id" {
  value = aws_vpc.default.id
}
output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
output "subnet_ids" {
  value = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
}
output "aws_vpc_endpoint" {
  value = compact(tolist(aws_vpc_endpoint.s3[*].id))
}
output "public_aws_route_table" {
  value = aws_route_table.public.id
}
output "private_aws_route_table" {
  value = aws_route_table.private.*.id
}
output "cloud_common_sg" {
  value = aws_security_group.myec2common_01.id
}
output "onprem_common_sg" {
  value = aws_security_group.myec2common_02.id
}
output "private_availability_zones" {
  value = aws_subnet.private[*].availability_zone
}
output "public_availability_zones" {
  value = aws_subnet.public[*].availability_zone
}
output "custom_dhcp_options" {
  value = aws_vpc_dhcp_options.this[*].id
}
output "aws_s3_vpc_endpoint" {
  value = aws_vpc_endpoint.s3[*].id
}
