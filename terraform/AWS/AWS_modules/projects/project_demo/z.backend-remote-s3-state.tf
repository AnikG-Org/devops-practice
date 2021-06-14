/*

module "s3_remote_state" {
  source          = "../../modules/0.1.2.0.tf-remote-state/remote-state-req-components-enable-if-required"
  s3_aws_region = var.provider_region
  create_remote_state_s3 = true
  versioning = false
  enable_bucket_public_access_blocking = true
  ############################ common tag ########################################
  
  environment = var. environment
project         = var.project
  git_repo        = var.git_repo
  ServiceProvider = var.ServiceProvider
  ################################################################################  
  additional_tags = {
     Used_for = "TF-S3-remote-state" 
  }
  lifecycle_rule = [{
    id      = "tfstate"
    enabled = true
    prefix  = "tfstate/"
    noncurrent_version_transition = [{
        days          = 30
        storage_class = "STANDARD_IA"
      }]
    noncurrent_version_expiration = {
      days = 31
    }
  }]

  #### Dynamo db for lock state file
  
  create_table    = false
}

# terraform {
#   backend "s3" {
#     bucket = module.s3_remote_state.bucket_id  # "remote-backends"
#     key    = "tfstate/terraform.tfstate"
#     region = var.provider_region
#     # access_key = "YOUR-ACCESS-KEY"
#     # secret_key = "YOUR-SECRET-KEY"
#     dynamodb_table = module.s3_remote_state.dynamodb_table_id #"terraform-lock"
#   }
# }
*/