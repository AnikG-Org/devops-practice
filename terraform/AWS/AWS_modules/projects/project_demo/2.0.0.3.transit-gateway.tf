
/*  #enable when requirded

provider "aws" {
  region = "us-east-1"
  alias  = "peer"
  default_tags {
    tags = {
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    }
  }  
}
data "aws_caller_identity" "current" {
}
module "transit_gateway" {
  source          = "../../modules/0.1.6.network/transit-gateway"
  
  create_tgw      = true
  name            = "my-transit_gateway"
  description     = "My TGW can with several other AWS accounts"
  amazon_side_asn = 64532
  #multicast_support = true #still not suported by tf
  enable_auto_accept_shared_attachments = true # When "true" there is no need for RAM resources if using multiple AWS accounts

  vpc_attachments = {
    vpc1 = {
      vpc_id                                          = module.aws_network_1.vpc_id
      subnet_ids                                      = module.aws_network_1.private_subnet_ids #Should not have DuplicateSubnetsInSameAZ  
      dns_support                                     = true
      ipv6_support                                    = false #enable if subnets contains ipv6
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      #transit_gateway_route_table_id = "tgw-rtb-073a181ee589b36xx"

      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    },
    # vpc2 = {
    #   vpc_id     = data.aws_vpc.default.id      # module.vpc2.vpc_id
    #   subnet_ids = data.aws_subnet_ids.this.ids # module.vpc2.private_subnets

    #   tgw_routes = [
    #     {
    #       destination_cidr_block = "50.0.0.0/16"
    #     },
    #     {
    #       blackhole              = true
    #       destination_cidr_block = "10.10.10.10/32"
    #     }
    #   ]
    # },
  }
  ##########################
  # Resource Access Manager
  ##########################
  share_tgw                             = true
  ram_allow_external_principals         = true
  ram_principals                        = [] #account ID  : data.aws_caller_identity.current.account_id

  #****nrequired for  aws_ec2_transit_gateway_peering_attachment to target Tgw
  aws_ec2_transit_gateway_peering_attachment_accepter = {
  tgw-us-east-1 = {
	  transit_gateway_attachment_id = module.transit_gateway_peer.aws_ec2_transit_gateway_peering_attachment_id[0]  #aws_ec2_transit_gateway_peering_attachment.thid.id
	},
  } 
  tags = {
    Purpose = "transit-gateway-main"
  }  
}

# This is optional and connects to another account. Meaning you need to be authenticated with 2 separate AWS Accounts

# This provider is required for attachment only installation in another AWS Account. # create_tgw = true for inter region peering
########################################

data "aws_regions" "peer" {
  provider = aws.peer
  all_regions = true
  # filter {
  #   name   = "region-name"
  #   values = ["us-east-1"]   
  # }  
}
# data "aws_vpc" "default" {
#   default = true
# #   filter {
# #     name   = "region-name"
# #     values = ["us-east-1"]
# #   }
# }
# data "aws_subnet_ids" "this" {
#   vpc_id = data.aws_vpc.default.id
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }  
# }
########################################
module "transit_gateway_peer" {
  source          = "../../modules/0.1.6.network/transit-gateway"
  providers = { aws = aws.peer }

  name            = "my-transit_gateway-peer"
  description     = "My TGW Inter region peering"
  amazon_side_asn = 64532

  create_tgw                            = true   ## require for peer # create_tgw = true for inter region peering
  enable_auto_accept_shared_attachments = true # When "true" there is no need for RAM resources if using multiple AWS accounts

  vpc_attachments = {
    vpc1 = {
      #tgw_id                                          = module.transit_gateway.ec2_transit_gateway_id ## require for peer if using multiple AWS accounts in same region
      vpc_id                                          = "vpc-b37a9bce"   
      subnet_ids                                      = ["subnet-994297ff","subnet-e102d1c0"]#data.aws_subnet_ids.this.ids 
      dns_support                                     = true
      ipv6_support                                    = false
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      #transit_gateway_route_table_id                  = module.transit_gateway.ec2_transit_gateway_route_table_id #"tgw-rtb-03157ee27f9829a06" #

      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    },
  }




  ##########################
  # Resource Access Manager
  ##########################
  #ram_resource_share_arn                = module.transit_gateway.ram_resource_share_id  ## require for different AWS account peering aws_ram_resource_share_accepter
  share_tgw                             = true    ## require for peer
  ram_allow_external_principals         = true
  ram_principals                        = [] #account ID  : data.aws_caller_identity.current.account_id

 #**** required for  aws_ec2_transit_gateway_peering_attachment to target Tgw
aws_ec2_transit_gateway_peering_attachment = {
  tgw-mumbai = {
	  peer_account_id         = data.aws_caller_identity.current.account_id
	  peer_region             = var.provider_region
	  peer_transit_gateway_id = module.transit_gateway.ec2_transit_gateway_id
	  transit_gateway_id      = module.transit_gateway_peer.ec2_transit_gateway_id
	},
}
  tags = {
    Purpose = "transit-gateway-peer"
  }
}  

*/