######################## OutPut ###############################
output "output_additional_ebs" {
  value = aws_ebs_volume.ec2ebs_additional[*].id
}
output "device_name" {
  value = aws_volume_attachment.ebs_attachment[*].device_name
}