output "ec2_instance_id" {
  value = aws_instance.ec2_count.*.id
}
output "root_block_device_info" {
  value = aws_instance.ec2_count[*].root_block_device
}
######################################
output "ec2_count_private_ip" {
  description = "private IP address of the EC2 instance"
  value       = aws_instance.ec2_count[*].private_ip
}
output "ec2_count_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2_count[*].public_ip
}

