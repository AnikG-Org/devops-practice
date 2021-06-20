#TF version
##################### TF 0.12 
# terraform {
#   #required_version = ">= 0.12"   #TERRAFORM_CLI_VERSION
#   required_providers {
#     aws = ">= 3.37"   #AWS_providers version
#   }
# }

# provider "random" {} #provider.random: version = "~> 3.1"
##################### TF > 0.13 Onwards
terraform {
  required_version = "~> 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0,<=3.50.0"
    }
  } #hashicorp/aws v3.40.0
}
provider "random" {
  version = "~> 3.1"
} ##hashicorp/random v3.1.0
provider "null" {
  version = "~> 3.1"
} ##hashicorp/null v3.1.0
