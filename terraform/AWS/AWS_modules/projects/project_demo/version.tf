#TF version
##################### TF > 0.13 Onwards
# terraform {
#   required_version = "~> 0.13"
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.0"
#     }
#   }
# }
# provider "random" {} ##provider.random: version = "~> 3.1"

module "provider_version_tf13" {
  source = "../../modules/0.0.provider_version"
}

################### Local state ##############
# terraform {
#   backend "local" {
#     path = "./terraform.tfstate"
#   }
# }
#############################################
## DATA SOURCES FOR LOCAL STATE REFERENCE
#  data "terraform_remote_state" "local" {
#   backend = "local"
#   config = {
#     path = "${path.module}/terraform-1.tfstate" 
#   }
# }

# plugin_cache_dir   = "$HOME/.terraform.d/plugin-cache"
disable_checkpoint = true
