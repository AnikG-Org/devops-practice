/*
locals {
  cluster_name = "tf-aws-eks-${random_string.suffix.result}"
}
resource "random_string" "suffix" {
  length  = 8
  special = false
}
###########################################################
data "aws_eks_cluster" "cluster" {
  name = module.eks-ng.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks-ng.cluster_id
}
data "aws_availability_zones" "available" {
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}


module "eks-ng" {
  source          = "../../modules/0.1.4.compute/eks"

  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  vpc_id          = module.aws_network_1.vpc_id
  subnets         = module.aws_network_1.private_subnet_ids

  tags = {
    deployment-ci-cd = "jenkins-eks-tf"
  }


  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 20
  }

  node_groups = {
    eks1 = {
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1

      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
      k8s_labels = {
        GithubOrg   = "AnikG-Org"
      }
      additional_tags = {
        ExtraTag = "eks1-ng"
      }
      taints = [
        {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  }


  manage_aws_auth = true

  map_roles    = var.map_roles
  map_users    = var.map_users
  map_accounts = var.map_accounts
  ############################### common tag #####################################
  environment     = var.environment 
  project         = var.project
  git_repo        = var.git_repo
  ServiceProvider = var.ServiceProvider
  ################################################################################   
}

####################################    VAR    ###################################
variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
  default = []
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}
*/