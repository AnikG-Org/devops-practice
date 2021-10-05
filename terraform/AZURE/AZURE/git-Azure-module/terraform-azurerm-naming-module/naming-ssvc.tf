locals {

  ssvc_keys = flatten([
    for num in range(var.ssvc_count) : [
      for key_prefix in local.key_prefixes :
      format("%sssvc_%s", key_prefix, num + 1)
    ]
  ])

  ssvc_values = flatten([
    for num in range(var.ssvc_count) : [
      for format_option in local.common_resource_numbering_format :
      lower(format("%s-%s%s-%s-ssvc-%s-%s${format_option}", local.pwc_prefix_code, local.country_code_subscription, local.pwc_global_it_country_code_subscription, local.subscription_env_code, var.app_code, local.app_env_code, num + 1))
    ]
  ])

}

output "ssvc_names" {
  value = zipmap(local.ssvc_keys, local.ssvc_values)
}