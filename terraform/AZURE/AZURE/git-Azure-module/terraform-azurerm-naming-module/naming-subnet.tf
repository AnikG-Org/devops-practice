locals {

  subnet_keys = flatten([
    for num in range(var.subnet_count) : [
      for key_prefix in local.key_prefixes :
      format("%ssubnet_%s", key_prefix, num + 1)
    ]
  ])

  subnet_values = flatten([
    for num in range(var.subnet_count) : [
      for format_option in local.common_resource_numbering_format :
      upper(format("%s-%s%s-%s-SNT-%s-%s${format_option}", local.pwc_prefix_code, local.country_code_subscription, local.pwc_global_it_country_code_subscription, local.subscription_env_code, var.app_code, local.app_env_code, num + 1))
    ]
  ])

}

output "subnet_names" {
  value = local.subnet_resource_names_required ? zipmap(local.subnet_keys, local.subnet_values) : null
}