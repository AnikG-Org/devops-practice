locals {

  udr_keys = flatten([
    for num, code in var.udr_codes : [
      for key_prefix in local.key_prefixes :
      format("%s%s_udr", key_prefix, lower(code))
    ]
  ])

  udr_values = flatten([
    for code in var.udr_codes : [
      for format_option in local.udr_numbering_format :
      upper(format("%s-%s%s-%s-UDR-%s-%s%s${format_option}", local.pwc_prefix_code, local.country_code_subscription, local.pwc_global_it_country_code_subscription, local.subscription_env_code, code, local.app_env_code, local.subscription_number))
    ]
  ])

}

output "udr_names" {
  value = zipmap(local.udr_keys, local.udr_values)
}