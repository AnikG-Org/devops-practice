module "naming" {
  source       = "../../modules/0.1.2.1.naming-prefix-module"
  app_name     = "NGX"
  custom_name1 = "-APS1"
  project      = "TFM"
  environment  = terraform.workspace #"PRD"
  sequence     = "0"
} ##name_prefix = "${var.app_name}${var.custom_name1}-${var.environment}-${var.project}-${var.sequence}"
output "naming" {
  value = module.naming.name_prefix
}
#####################
module "ec2_iam_admin_role" {
  source = "../../modules/0.1.3.security/iam-instance-admin-role"
  #common_tag
  environment = var.environment
  project     = var.project
  git_repo    = var.git_repo
}

module "ec2_count_autorecovery" {
  source = "../../modules/0.1.4.compute/ec2-count-auto-recovery"

  instance_count              = 0
  ec2tagname                  = module.naming.name_prefix
  ami                         = module.ec2_count_autorecovery.ami_linux.ubuntu_ami
  instance_type               = "t3.micro"
  iam_instance_profile        = module.ec2_iam_admin_role.ec2_admin_iam_role
  subnet_id                   = module.aws_network_1.private_subnet_ids[0] #string
  key_name                    = "anik_test"
  monitoring                  = true
  associate_public_ip_address = false
  user_data                   = null
  user_data_base64            = base64encode(local.user_data_base64)
  security_groups             = []                                                      #avoid(unstable) If you are creating Instances in a VPC and SG on common main file.
  vpc_security_group_ids      = [module.count_security_groups_2.output_dynamicsg_v2[0]] ##If you are creating Instances in a VPC, use vpc_security_group_ids instead.(Optional, VPC only)
  private_ips                 = []
  source_dest_check           = true
  disable_api_termination     = false
  tenancy                     = "default"

  #common_tag
  environment = var.environment
  project     = var.project
  git_repo    = var.git_repo

  additional_tags = {
    app    = "web-app"
    region = "mumbai"
  }
  #root_block_device
  root_block_volume_type                  = "gp3"
  root_block_volume_size                  = 10
  root_block_device_iops                  = "3000"
  root_block_device_encryption            = false
  kms_key_id                              = ""
  root_block_device_delete_on_termination = true


  enable_auto_recovery_alarm    = true
  enable_public_route53_record  = false
  enable_private_route53_record = false

  route53_hosted_zone_id = ""
  record_name            = ""


  ec2_count_depends_on = [module.aws_network_1]

}

locals {
  user_data_base64 = <<EOF
#!/bin/bash

echo "Hello Terraform! $(date +'%d/%m/%Y')" > op.txt
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx
EOF
}
##############
locals {
  ebs_count       = 0
  ebs_count_value = local.ebs_count == 0 ? "" : element(module.ec2_count_autorecovery.ec2_instance_id[*], 0)
}

module "additional_ebs_1" {
  source = "../../modules//0.1.8.storage/ebs"

  ebs_count   = local.ebs_count
  volume_size = 1
  #tag
  ebstagname = "EBS"
  additional_tags = {
    app    = "demo-app"
    region = "mumbai"
    Volume = "Additional_app_volume"
  }
  #common_tag
  environment = var.environment
  project     = var.project
  git_repo    = var.git_repo

  availability_zone = [module.aws_network_1.public_availability_zones[0]]

  enable_aws_volume_attachment = false
  instance_id                  = [local.ebs_count_value] #[module.ec2_count_autorecovery.ec2_instance_id[0]] 
  device_name                  = ["/dev/sdf"]

  ebs_attachment_depends_on = [
    module.ec2_count_autorecovery,
  ]
}

# output "root_block_device_name" {
#   value = module.ec2_count_autorecovery[*].root_block_device_info
# }


##############################
