module "aws_network_1" {
  source = "../../modules/0.1.1.aws_network"

  ################################################################################
  # Provider tag
  ################################################################################

  environment     = var.environment
  project         = var.project
  git_repo        = var.git_repo
  ServiceProvider = var.ServiceProvider
  ################################################################################
  # VPC
  ################################################################################
  instance_tenancy                 = "default"
  cidr_block                       = var.cidr_block #VPC CIDR
  assign_generated_ipv6_cidr_block = false
  enable_nat_gateway               = true
  single_nat_gateway               = true #Single Nat Gateway or HA Nat Gateway #
  manage_default_route_table       = false
  default_route_table_tags         = {}
  enable_custom_dhcp_options       = false
  dhcp_options_tags                = {}
  dhcp_options_domain_name         = "domain.local"
  dhcp_options_domain_name_servers = ["127.0.0.1", "8.8.8.8"]
  ################################################################################
  # Subnets    #1 public & 1 private Route_Table for subnets
  ################################################################################
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks

  availability_zones = var.availability_zones
  ################################################################################
  # vpc endpoint for s3
  ################################################################################
  enable_vpc_s3_endpoint = false
  ################################################################################
  # vpc flow log
  ################################################################################
  enable_cw_flow_log     = false
  enable_s3_flow_log     = false #if = true also enable s3
  enable_s3_for_flow_log = false #empty s3 bucket prior destroying
  #S3 for flow_log   lifecycle_rule will apply once enable_s3_for_flow_log = true
  lifecycle_rule = [{
    id      = "AWSLogs"
    enabled = true
    prefix  = "AWSLogs/"
    tags = {
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
  }]
  ################################################################################
  # default / common sg
  ################################################################################
  on_prem_cidr_block = var.on_prem_cidr_block
  cloud_cidr_block   = var.cloud_cidr_block
}


output "Network_output" {
  value = zipmap(["vpc_id", "private_subnet_ids", "public_subnet_ids"], [module.aws_network_1.vpc_id, module.aws_network_1.private_subnet_ids[*], module.aws_network_1.public_subnet_ids[*]])
}

output "subnet_availability_zones" {
  value = zipmap(["public_availability_zones", "private_availability_zones"], [module.aws_network_1.public_availability_zones, module.aws_network_1.private_availability_zones])
}
