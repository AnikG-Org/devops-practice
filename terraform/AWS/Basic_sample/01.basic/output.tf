#output
output "instance" {
  value = aws_instance.myec2
}
output "myebsvolume" {
  value = aws_ebs_volume.myec2ebs
}
output "eip" {
  value = aws_eip.lb
}
output "mys3bucket" {
  value = aws_s3_bucket.mys3.bucket_domain_name
}
