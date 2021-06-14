/*

################### TERRAFORM TFVARS ###################
##PROJECT DEPLOYMENT with prod workspace   -var-file=dev.tfvars     ##
########################################################


#providor & #vpc endpoint ###############################################################
provider_region = "ap-south-1"

#TAG        #use small letter as per  s3 naming guideline         #######################
git_repo        = "github.com/project_demo/project-demo_GIT_repo"
environment     = "dev"
project         = "project-terraform"
ServiceProvider = "Anik"

#VPC          ##########################################################################
cidr_block = "10.1.0.0/16" #VPC

private_subnet_cidr_blocks = ["10.1.1.0/24", "10.1.3.0/24", "10.1.5.0/24"]
public_subnet_cidr_blocks  = ["10.1.0.0/24", "10.1.2.0/24"]
availability_zones         = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

#VPC endpoint  ########################################################################

#VPC flow log  ########################################################################

#Default SG            ########################################################################
on_prem_cidr_block = ["192.168.0.0/16"] #On-Prem Network CIDR #type = list
cloud_cidr_block   = ["10.1.0.0/16"]    #AWS VPC CIDR for common cloud sg
#dynamic SG            ########################################################################
*/