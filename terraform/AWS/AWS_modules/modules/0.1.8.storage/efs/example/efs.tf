module "efs" {
  source          = "../"
  provider_region = var.provider_region
  enabled         = true
  region          = var.region
  vpc_id          = var.vpc_id
  subnets         = var.private_subnet_ids
  security_groups = [var.vpc_default_security_group_id]
}

output "efs_id" {
  value       = module.efs.id
  description = "EFS ID"
}