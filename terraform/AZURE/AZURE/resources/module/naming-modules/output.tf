###  Output variables  ###

output "name" {
  description = "Resource group name to use"
  value = "RG-${upper(var.org)}-${upper(var.bu_code)}-${upper(var.component)}-${upper(var.app_env_code)}-${var.sequence_no}"
  #value       = "${upper(var.base_codes["pwc_prefix_code"])}-${upper(var.base_codes["country_code_subscription"])}${upper(var.base_codes["pwc_global_it_country_code_subscription"])}-${upper(var.base_codes["subscription_env_code"])}-RGP-${upper(var.app_code)}-${upper(var.app_env_code)}${var.sequence_no}"
}