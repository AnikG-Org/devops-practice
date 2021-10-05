locals {

  rsv_keys = flatten([
    for num in range(var.rsv_count) : [
      for key_prefix in local.key_prefixes :
      format("%srsv_%s", key_prefix, num + 1)
    ]
  ])

  rsv_values = flatten([
    for num in range(var.rsv_count) : [
      for format_option in local.common_resource_numbering_format :
      upper(format("%s-%s%s-%s-RSV-%s${format_option}", local.pwc_prefix_code, local.country_code_subscription, local.pwc_global_it_country_code_subscription, local.subscription_env_code, local.app_env_code, num + 1))
    ]
  ])

}

output "rsv_names" {
  value = zipmap(local.rsv_keys, local.rsv_values)
}