locals {
  domain_name = "testqueues.com" # trimsuffix(data.aws_route53_zone.this.name, ".")
}

# #creating aws_route53_zone #using with sqs/cdn
/*
module "r53_internal_zone" {
  source          = "../../modules/0.1.6.network/route-53-hz-internal"
  

  environment = "Development"
  name        = local.domain_name
  vpc_id      = module.aws_network_1.vpc_id
}
*/