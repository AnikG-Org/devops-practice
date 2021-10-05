locals {

  nsg_keys = flatten([
    for num in range(var.subnet_count) : [
      for key_prefix in local.key_prefixes :
      format("%snsg_%s", key_prefix, num + 1)
    ]
  ])

  nsg_values = flatten([
    for num in range(var.subnet_count) : [
      for format_option in local.common_resource_numbering_format :
      upper(format("%s-%s%s-%s-NSG-%s-%s${format_option}", local.pwc_prefix_code, local.country_code_subscription, local.pwc_global_it_country_code_subscription, local.subscription_env_code, var.app_code, local.app_env_code, num + 1))
    ]
  ])

}

output "nsg_names" {
  value = local.subnet_resource_names_required ? zipmap(local.nsg_keys, local.nsg_values) : null
}