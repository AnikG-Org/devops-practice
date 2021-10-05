locals {

  storage_acc_keys = flatten([
    for num in range(var.storage_acc_replication_type != null ? var.storage_acc_count : 0) : [
      for key_prefix in local.key_prefixes :
      format("%ssa_%s", key_prefix, num + 1)
    ]
  ])

  standard_storage_acc_values = flatten([
    for num in range(var.storage_acc_replication_type != null ? var.storage_acc_count : 0) : [
      for index, format_option in local.common_resource_numbering_format :
      lower(format("%s%s%s%sS%s%s%s${format_option}", local.pwc_prefix_code, local.country_code_subscription, local.subscription_env_code, lookup(local.azure_region_abbreviations, index == 0 ? var.location : var.secondary_location), substr(var.storage_acc_replication_type, 0, 1), var.app_code, local.app_env_code, num + 1))
    ]
  ])

  premium_storage_acc_values = flatten([
    for num in range(var.storage_acc_replication_type != null ? var.storage_acc_count : 0) : [
      for index, format_option in local.common_resource_numbering_format :
      lower(format("%s%s%s%sP%s%s%s${format_option}", local.pwc_prefix_code, local.country_code_subscription, local.subscription_env_code, lookup(local.azure_region_abbreviations, index == 0 ? var.location : var.secondary_location), substr(var.storage_acc_replication_type, 0, 1), var.app_code, local.app_env_code, num + 1))
    ]
  ])

}

output "standard_sa_names" {
  value = var.storage_acc_replication_type != null ? zipmap(local.storage_acc_keys, local.standard_storage_acc_values) : null
}

output "premium_sa_names" {
  value = var.storage_acc_replication_type != null ? zipmap(local.storage_acc_keys, local.premium_storage_acc_values) : null
}