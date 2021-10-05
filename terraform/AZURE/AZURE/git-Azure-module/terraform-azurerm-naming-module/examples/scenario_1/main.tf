# module "naming" {
#   source                   = "../../"
#   subscription_name        = data.terraform_remote_state.devops_subscription_base_state.outputs.subscription_name
#   location                 = data.terraform_remote_state.devops_subscription_base_state.outputs.base_vnet_location
#   app_code                 = var.app_code
#   environment              = var.environment
#   vm_numbering_starts_with = var.vm_numbering_starts_with
# }
