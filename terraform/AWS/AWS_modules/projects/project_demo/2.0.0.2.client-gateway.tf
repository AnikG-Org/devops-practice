/* #enable when required
data "aws_acm_certificate" "cert" {
  domain      = "test.com"
  most_recent = true
  statuses    = ["ISSUED"]
}

module "client_vpn" {
  source          = "../../modules/0.1.6.network/vpn-gateway/client"
  

  client_vpn_cidr_block      = "192.168.8.0/22"
  name                       = "aws-vpn"
  description                = "Client VPN"
  public_subnets             = []
  private_subnets            = [module.aws_network_1.private_subnet_ids[0], module.aws_network_1.private_subnet_ids[1]]
  split_tunnel               = true
  vpc_id                     = module.aws_network_1.vpc_id
  server_certificate_arn     = data.aws_acm_certificate.cert.arn
  
  type                          = "certificate-authentication" #"directory-service-authentication"#"federated-authentication"
  root_certificate_chain_arn    = data.aws_acm_certificate.cert.arn #The ARN of the client certificate
  #saml_provider_arn             = local.saml_provider_arn
  

  aws_ec2_client_vpn_authorization_rule = local.aws_ec2_client_vpn_authorization_rule
  aws_ec2_client_vpn_route      = local.aws_ec2_client_vpn_route
}

locals {
  saml_provider_arn        = ""
  aws_ec2_client_vpn_authorization_rule = {
    HO = {
      description          = "HO"
      target_network_cidr  = "10.0.1.0/24"
      authorize_all_groups = null    # = null when access_group_id = value
      access_group_id      = "ADGrp1"
    },
    O1 = {
      description          = "Branch1"
      target_network_cidr  = "10.0.2.0/24"
      authorize_all_groups = true
      access_group_id      = null # = null when authorize_all_groups = true
    },
  }  
aws_ec2_client_vpn_route = {
    O1 = {
      description             = "Branch additional route"
      destination_cidr_block  = "10.1.2.0/24"
      target_vpc_subnet_id    = module.aws_network_1.private_subnet_ids[0]
    }, 
    O2 = {
      description             = "Branch additional route"
      destination_cidr_block  = "10.1.2.0/24"
      target_vpc_subnet_id    = module.aws_network_1.private_subnet_ids[1]
    },     
}

}

*/