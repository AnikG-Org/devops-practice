locals {

  rdc_keys = flatten([
    for num in range(var.rdc_count) : [
      for key_prefix in local.key_prefixes :
      format("%srdc_%s", key_prefix, num + 1)
    ]
  ])

  rdc_values = flatten([
    for num in range(var.rdc_count) : [
      for format_option in local.common_resource_numbering_format :
      lower(format("%s-%s%s-%s-rdc-%s-%s${format_option}", local.pwc_prefix_code, local.country_code_subscription, local.pwc_global_it_country_code_subscription, local.subscription_env_code, var.app_code, local.app_env_code, num + 1))
    ]
  ])

}

output "rdc_names" {
  value = zipmap(local.rdc_keys, local.rdc_values)
}