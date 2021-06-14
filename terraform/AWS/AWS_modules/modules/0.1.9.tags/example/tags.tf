module "custom_tags" {
  source = "../"

  names = ["prod", "app", "fullstack"]

  tags = {
    "Env"       = "prod",
    "Namespace" = "application",
    "Owner"     = "fullstack Engineering Team"
  }
}


output "module_tags" {
  value = module.custom_tags
}