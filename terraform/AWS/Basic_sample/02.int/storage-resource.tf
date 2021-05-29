#ebs
resource "aws_ebs_volume" "myec2ebs_backup" {
  size   = 1
  availability_zone = var.ec2_az
  type   =  "gp2"
  tags   = {
    Name = "${var.myec2tagname["Name"]}-backup-ebs"
    created_from = "TF"
    created_by = var.myec2tagname["created_by"]
    timestamp = "${timestamp()}"
  }
}

resource "aws_ebs_volume" "myec2ebs_additional" {
  size   = 1
  availability_zone = var.ec2_az
  type   =  "gp3"
  tags   = {
    Name = "${var.myec2tagname["Name"]}-ebs-additional"
    created_from = "TF"
    created_by = var.myec2tagname["created_by"]
    timestamp = "${timestamp()}"
  }
}


#s3
resource "aws_s3_bucket" "mys3" {
  bucket = var.mys3_bucket_name
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