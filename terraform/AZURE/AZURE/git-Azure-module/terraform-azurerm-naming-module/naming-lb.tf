locals {

  lb_keys = flatten([
    for num in range(local.vm_resource_names_required ? var.lb_count : 0) : [
      for key_prefix in local.key_prefixes :
      format("%slb_%s", key_prefix, num + 1)
    ]
  ])

  lb_values = flatten([
    for num in range(local.vm_resource_names_required ? var.lb_count : 0) : [
      for format_option in local.common_resource_numbering_format :
      upper(format("%s-%s%s-%s-LBS-%s-%s${format_option}", local.pwc_prefix_code, local.country_code_subscription, local.pwc_global_it_country_code_subscription, local.subscription_env_code, var.app_code, local.app_env_code, num + 1))
    ]
  ])

}

output "lb_names" {
  value = local.vm_resource_names_required ? zipmap(local.lb_keys, local.lb_values) : null
}