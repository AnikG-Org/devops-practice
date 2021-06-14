output "ec2_admin_iam_role" {
  value = aws_iam_instance_profile.myec2role_profile.name
}
output "ec2_admin_iam_role_arn" {
  value = aws_iam_instance_profile.myec2role_profile.arn
}
