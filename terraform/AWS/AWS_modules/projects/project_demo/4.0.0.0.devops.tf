# # S3  enable when required
/*
resource "aws_s3_bucket" "myapp-project" {
  bucket        = "ci-cd-project-codebuild-adsadcsaczs"
  force_destroy = true
  acl           = "private"
}

#################### codecommit_repo ####################
module "codecommit_repo" {
  source          = "../../modules/0.1.5.devops/codecommit"
  

  name              = "devops-repo"
  default_branch    = "main"

  enable_trigger_1          = false
  trigger_1_name            = "repo-trigger-1"
  trigger_1_custom_data     = "An event happened"
  trigger_1_destination_arn = "" #module.sns.topic_arn
  trigger_1_events          = ["all"]
}
#################### code build #########################
module "codebuild" {
  source          = "../../modules/0.1.5.devops/codebuild"
  

  name        = "codebuild-app-vpc"
  description = "Codebuild for deploying app in a VPC"

  codebuild_source_version = "master"
  codebuild_source = {
    type            = "GITHUB"
    location        = "https://github.com/AnikG-Org/codebuild-example.git"
    git_clone_depth = 1

    git_submodules_config = {
      fetch_submodules = true
    }
  }

  # Secondary Sources (optional)
#   codebuild_secondary_sources = [
#     {
#       type              = "GITHUB"
#       location          = "https://github.com/myprofile/myproject-1.git"
#       source_identifier = "my_awesome_project1"
#     },
#     {
#       type                = "GITHUB"
#       location            = "https://github.com/myprofile/myproject-2.git"
#       git_clone_depth     = 1
#       source_identifier   = "my_awesome_project2"
#       report_build_status = true
#       insecure_ssl        = true
#     }
#   ]

  environment = {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    # Environment variables
    variables = [
      {
        name  = "REGISTRY_URL"
        value = "388891221585.dkr.ecr.ap-south-1.amazonaws.com/docker-ecs"
      },
      {
        name  = "AWS_DEFAULT_REGION"
        value = "ap-south-1"
      },
    ]
  }

  artifacts = {
    location  = aws_s3_bucket.myapp-project.bucket
    type      = "S3"
    path      = "/artifacts"
    packaging = "ZIP"
  }

  cache = {
    type     = "S3"
    location = "${aws_s3_bucket.myapp-project.id}/cache"
  }

  # Logs
  s3_logs = {
    status   = "ENABLED"
    location = "${aws_s3_bucket.myapp-project.id}/build-log"
  }


  # VPC
  vpc_config = {
    vpc_id             = module.aws_network_1.vpc_id
    subnets            = [module.aws_network_1.private_subnet_ids[0], module.aws_network_1.private_subnet_ids[1]]
    security_group_ids = [module.aws_network_1.cloud_common_sg]

  }

  # Tags
  ################################################################################
  environment     = var.environment
  project         = var.project
  git_repo        = var.git_repo
  ServiceProvider = var.ServiceProvider
  ################################################################################  
  tags = {
    owner = "${var.environment}-team"
  }
}
#################### codedeploy #########################
#ec2

module "codedeploy" {
  source          = "../../modules/0.1.5.devops/codedeploy"
  

  create_application                 = true #false if want to use existing application_name
  application_name                   = "MyCodeDeployApp"
  compute_platform                   = "Server"
  deployment_group_name              = "MyCodeDeployDeploymentGroup"
  deployment_config_name             = "CodeDeployDefault.AllAtOnce"
  deployment_environment             = "Prod"
  enable_bluegreen                   = false  #for BLUE_GREEN target_group_name & autoscaling_groups required
  enable_auto_rollback_configuration = true

  autoscaling_groups     = [] #[module.asg.asg_name_list] #For ASG
  target_group_name      = "" #"test-target-group" #element(module.alb.target_group_names, 0) #for ELB
  clb_name               = "" #module.clb.clb_name   #for CLB

}

#ECS service must be configured for a CODE_DEPLOY deployment controller.
#-------------------------------------------------------------------------
# module "codedeploy" {
#   source          = "../../modules/0.1.5.devops/codedeploy"
#   

#   create_application                 = true #false if want to use existing application_name
#   application_name                   = "MyECSCodeDeployApp"
#   compute_platform                   = "ECS"
#   deployment_group_name              = "MyECSCodeDeployDeploymentGroup"
#   deployment_config_name             = "CodeDeployDefault.ECSAllAtOnce"
#   deployment_environment             = "Prod"
#   enable_bluegreen                   = true  # true for BLUE_GREEN & ECS
#   enable_auto_rollback_configuration = true

#   lb_listener_arns           = []
#   blue_lb_target_group_name  = "blue-target-group"
#   green_lb_target_group_name = "green-targetgroup"
   
#   wait_time_in_minutes       = 10
#   #for "ECS"
#   cluster_name = aws_ecs_cluster.example.name
#   service_name = "sample-app-service" 
# }

#################### code pipeline #########################
locals {
  artifact_store = {
    location = aws_s3_bucket.myapp-project.bucket
    type = "S3" } 
}

module "codepipeline" {
  source          = "../../modules/0.1.5.devops/codepipeline"
  
  name           = var.pipeline_name
  description    = var.description
  artifact_store = local.artifact_store
  stages         = var.stages
  common_tags    = var.common_tags
}
######## codepipeline VAR ########
variable "pipeline_name" {
  type = string
}
variable "stages" {
  type        = list(any)
  description = "This list describes each stage of the build, so it really should be stages."
}
variable "description" {
  type        = string
  description = "Description of build project"
}
variable "common_tags" {
  type        = map(any)
  description = "Implements the common tags scheme"
}
#################################
*/