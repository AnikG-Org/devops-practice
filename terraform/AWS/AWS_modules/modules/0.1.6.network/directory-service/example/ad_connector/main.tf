provider "aws" {
  region = "us-east-1"
}

module "ad_connector" {
  source = "../../"

  name       = "corp.${random_string.domain.result}.com"
  password   = random_string.password.result
  size       = "Small"
  subnet_ids = module.vpc.private_subnets
  type       = "ADConnector"

  connect_settings = {
    customer_username = "Administrator"
    customer_dns_ips  = module.directory_service.dns_ip_addresses
  }

  tags = {
    Name = "tardigrade-test-directory-service-${random_string.domain.result}"
  }
}

module "directory_service" {
  source = "../../"

  name       = "corp.${random_string.domain.result}.com"
  password   = random_string.password.result
  size       = "Small"
  subnet_ids = module.vpc.private_subnets
  type       = "SimpleAD"

  tags = {
    Name = "tardigrade-test-directory-service-${random_string.domain.result}"
  }
}

module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v2.77.0"

  name            = "tardigrade-test-directory-service-${random_string.domain.result}"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
}

resource "random_string" "password" {
  length      = 10
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}

resource "random_string" "domain" {
  length  = 10
  upper   = false
  number  = false
  special = false
}
