locals {

  vm_app_codes = var.vm_app_codes == null ? [""] : var.vm_app_codes
  vm_keys = flatten([
    for num in range(local.vm_resource_names_required ? var.vm_count : 0) : [
      for vm_app_code in local.vm_app_codes : [
        for key_prefix in local.key_prefixes :
        format("%s%svm_%s", key_prefix, vm_app_code == "" ? vm_app_code : format("%s_", vm_app_code), num + 1)
      ]
    ]
  ])

  win_vm_values = flatten([
    for num in range(local.vm_resource_names_required ? var.vm_count : 0) : [
      for vm_app_code in local.vm_app_codes : [
        for index, format_option in local.common_resource_numbering_format :
        lower(format("%s%s-%sw-%s${format_option}", local.pwc_prefix_code, lookup(local.azure_region_abbreviations, index == 0 ? var.location : var.secondary_location), vm_app_code == "" ? substr(var.app_code, 0, 3) : vm_app_code, local.app_env_code, var.vm_numbering_starts_with + num))
      ]
    ]
  ])

  linux_vm_values = flatten([
    for num in range(local.vm_resource_names_required ? var.vm_count : 0) : [
      for vm_app_code in local.vm_app_codes : [
        for index, format_option in local.common_resource_numbering_format :
        lower(format("%s%s-%sl-%s${format_option}", local.pwc_prefix_code, lookup(local.azure_region_abbreviations, index == 0 ? var.location : var.secondary_location), vm_app_code == "" ? substr(var.app_code, 0, 3) : vm_app_code, local.app_env_code, var.vm_numbering_starts_with + num))
      ]
    ]
  ])

}

output "linux_vm_names" {
  value = local.vm_resource_names_required ? zipmap(local.vm_keys, local.linux_vm_values) : null
}

output "windows_vm_names" {
  value = local.vm_resource_names_required ? zipmap(local.vm_keys, local.win_vm_values) : null
}
