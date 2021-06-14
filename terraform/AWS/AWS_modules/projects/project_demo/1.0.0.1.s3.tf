module "s3_1" {
  source = "../../modules/0.1.8.storage/s3"
  #
  s3_aws_region = "us-east-2"
  s3_count      = 0

  acl           = "private"
  force_destroy = true

  versioning = {
    enabled    = false
    mfa_delete = false
  }

  lifecycle_rule = [
    {
      id      = "log-recycle"
      enabled = true
      prefix  = "log/"
      tags = {
        "rule"      = "log"
        "autoclean" = "true"
      }
      transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA" # or "ONEZONE_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        },
      ]
      expiration = {
        days = 180
      }
    }
  ]
  #aws_s3_bucket_public_access_block
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  #aws_s3_bucket_inventory
  count_of_bucket_to_enable = 0
  bucket_to_enable          = null

  #tag
  mys3_bucket_name = ["testing-bucket01", "testing-bucket02"] #add bucket names based on count number #list
  #common_tag
  environment = var.environment
  project     = "project-tf"
  git_repo    = var.git_repo
}  