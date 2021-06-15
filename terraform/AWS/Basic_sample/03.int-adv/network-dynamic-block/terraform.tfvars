#TAG
git_repo    = "test-git-repo"
environment = "prod"
project     = "projecto-cloud" #use small letter as per  s3 guideline

#providor
region = "ap-south-1"
#VPC
cidr_block                 = "10.0.0.0/16"
private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
public_subnet_cidr_blocks  = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
availability_zones         = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

#S3
