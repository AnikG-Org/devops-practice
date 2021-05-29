#s3
resource "aws_s3_bucket" "mys3_log" {
  bucket = var.mys3_log_bucket_name
  acl    = "private"
  versioning {
    enabled = false
  } 
    lifecycle_rule {
    prefix  = "log/"
    enabled = false
    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }
    noncurrent_version_expiration {
      days = 90
    }
  }
 
  tags   = {
    s3_Name = "${var.myec2tagname["Name"]}-${var.myec2tagname["created_by"]}"
    created_by = "TF"
    timestamp = "${timestamp()}"
  }
}