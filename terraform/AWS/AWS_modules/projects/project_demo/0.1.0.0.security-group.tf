module "security_groups_1" {
  source = "../../modules/0.1.3.security/sg-dynamic-ingress"

  #tag
  sg_custom_name01 = "elb-sg"
  #common_tag
  environment = var.environment
  project     = var.project
  git_repo    = var.git_repo

  aws_vpc_id = module.aws_network_1.vpc_id #or hardcode vpc_id to attach

  sg_ports                   = [443, 80] #multiple values eligible
  dynamicsg_protocol         = "tcp"
  dynamicsg_cidr_block_1     = ["0.0.0.0/0"] #multiple values eligible
  dynamicsg_security_groups  = []            #var.dynamicsg_security_groups   #multiple values eligible
  dynamicsg_ipv6_cidr_blocks = []            #multiple values eligible

}
############################################### sg-count
module "count_security_groups_1" {
  source            = "../../modules/0.1.3.security/sg-count"
  
  count_dynamicsg_2 = 1
  #tag
  sg2_custom_name01 = "ec2box"
  #common_tag
  environment = var.environment
  project     = var.project
  git_repo    = var.git_repo

  aws_vpc_id = module.aws_network_1.vpc_id #or hardcode vpc_id to attach


  ingress = [
    {
      from_port        = "80"
      to_port          = "80"
      description      = "custom ingress for app "
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      security_groups  = [module.security_groups_1.output_dynamicsg_1]
      prefix_list_ids  = []
      self             = false
    }, #multiple custom  ingress format can added based on requirement
    {
      from_port        = "80"
      to_port          = "80"
      description      = "custom ingress for web app "
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      prefix_list_ids  = []
      self             = false
    },
  ]
}
###############################################
module "count_security_groups_2" {
  source = "../../modules/0.1.3.security/sg-count-adv"

  #tag
  sg2_custom_name01 = "ec2box-autorecovery"
  count_dynamicsg_2 = 1
  aws_vpc_id        = module.aws_network_1.vpc_id

  # to use below sg rules need to enable  create_sg_rule = true by default
  create_sg_rule      = true
  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "All SSH from 0.0.0.0/0"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]


  #common_tag
  environment = var.environment
  project     = var.project
  git_repo    = var.git_repo
}
###############################################
module "count_security_groups_3" {
  source            = "../../modules/0.1.3.security/sg-count"
  
  count_dynamicsg_2 = 0
  #tag
  sg2_custom_name01 = "db-sg"
  #common_tag
  environment = var.environment
  project     = var.project
  git_repo    = var.git_repo

  aws_vpc_id = module.aws_network_1.vpc_id #or hardcode vpc_id to attach
}
#-----------------------------------------------
module "sg_rule_1" {
  source = "../../modules/0.1.3.security/sgrule"

  create_sg_rule = false

  aws_vpc_id               = module.aws_network_1.vpc_id
  sgrule_security_group_id = "" #module.count_security_groups_3.output_dynamicsg_v2[0]
  ingress_rules            = ["http-80-tcp"]
  ingress_cidr_blocks      = ["0.0.0.0/0"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 5433
      to_port     = 5433
      protocol    = "tcp"
      description = "All Postgress custom"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
###############################################
###############################################
module "count_security_groups_4" {
  source = "../../modules/0.1.3.security/sg-count-adv"

  #tag
  sg2_custom_name01 = "lambda-sg"
  count_dynamicsg_2 = 1
  aws_vpc_id        = module.aws_network_1.vpc_id

  # to use below sg rules need to enable  create_sg_rule = true by default
  create_sg_rule = true

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "All traffic from 0.0.0.0/0"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  #common_tag
  environment = var.environment
  project     = var.project
  git_repo    = var.git_repo
}
###############################################
module "count_security_groups_5" {
  source = "../../modules/0.1.3.security/sg-count-adv"

  #tag
  sg2_custom_name01 = "rds"
  count_dynamicsg_2 = 1
  aws_vpc_id        = module.aws_network_1.vpc_id

  # to use below sg rules need to enable  create_sg_rule = true by default
  create_sg_rule      = true
  ingress_rules       = ["mysql-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  #common_tag
  environment = var.environment
  project     = var.project
  git_repo    = var.git_repo
}
###############################################
