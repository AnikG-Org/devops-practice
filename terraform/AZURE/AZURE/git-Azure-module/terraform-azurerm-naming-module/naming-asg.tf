locals {

  asg_keys = flatten([
    for num in range(var.asg_app_codes != null ? length(var.asg_app_codes) : 1) : [
      for key_prefix in local.key_prefixes :
      format("%sasg_%s", key_prefix, var.asg_app_codes == null ? num + 1 : var.asg_app_codes[num])
    ]
  ])

  asg_values = flatten([
    for num in range(var.asg_app_codes != null ? length(var.asg_app_codes) : 1) : [
      for format_option in local.common_resource_numbering_format :
      upper(format("%s-%s%s-%s-ASG-%s-%s${format_option}", local.pwc_prefix_code, local.country_code_subscription, local.pwc_global_it_country_code_subscription, local.subscription_env_code, var.asg_app_codes == null ? var.app_code : var.asg_app_codes[num], local.app_env_code, var.asg_number))
    ]
  ])

}

output "asg_names" {
  value = zipmap(local.asg_keys, local.asg_values)
}
