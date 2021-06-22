/*
data "aws_eks_cluster" "cluster" {
  name = module.eks-basic.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks-basic.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.2"
}

module "eks-basic" {
  source          = "../../modules/0.1.4.compute/eks"

  cluster_name    = "my-cluster"
  cluster_version = "1.20"
  vpc_id          = module.aws_network_1.vpc_id
  subnets         = module.aws_network_1.private_subnet_ids

  worker_groups = [
    {
      instance_type        = "t3.micro"
      asg_max_size         = 1
      asg_desired_capacity = 1
    }
  ]
  ############################### common tag #####################################
  environment     = var.environment 
  project         = var.project
  git_repo        = var.git_repo
  ServiceProvider = var.ServiceProvider
  ################################################################################  
}
*/