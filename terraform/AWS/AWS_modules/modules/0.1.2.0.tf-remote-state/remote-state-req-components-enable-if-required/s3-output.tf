output "bucket_arn" {
  value       = aws_s3_bucket.remote_state[0].arn
  description = "`arn` exported from `aws_s3_bucket`"
}

output "bucket_id" {
  value       = aws_s3_bucket.remote_state[0].id
  description = "`id` exported from `aws_s3_bucket`"
}

output "region" {
  value       = aws_s3_bucket.remote_state[0].region
  description = "`region` exported from `aws_s3_bucket`"
}

output "url" {
  value       = "https://s3-${aws_s3_bucket.remote_state[0].region}.amazonaws.com/${aws_s3_bucket.remote_state[0].id}"
  description = "Derived URL to the S3 bucket"
}

# output "principals" {
#   value       = var.principals
#   description = "Export `principals` variable (list of IAM user/role ARNs with access to the bucket)"
# }

# output "s3-full-access-policy-arn" {
#   value       = aws_iam_policy.s3-full-access.arn
#   description = "ARN of IAM policy that grants access to the s3 bucket (without requiring MFA)"
# }

# output "bucket-full-access-with-mfa-policy-arn" {
#   value       = aws_iam_policy.bucket-full-access-with-mfa.arn
#   description = "ARN of IAM policy that grants access to the bucket (with MFA required)"
# }