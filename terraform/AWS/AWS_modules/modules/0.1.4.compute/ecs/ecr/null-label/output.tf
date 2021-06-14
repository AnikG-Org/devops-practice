output "id" {
  value       = local.enabled ? local.id : ""
  description = "Disambiguated ID restricted to `id_length_limit` characters in total"
}

output "id_full" {
  value       = local.enabled ? local.id_full : ""
  description = "Disambiguated ID not restricted in length"
}

output "enabled" {
  value       = local.enabled
  description = "True if module is enabled, false otherwise"
}

output "namespace" {
  value       = local.enabled ? local.namespace : ""
  description = "Normalized namespace"
}

output "environment" {
  value       = local.enabled ? local.environment : ""
  description = "Normalized environment"
}

output "name" {
  value       = local.enabled ? local.name : ""
  description = "Normalized name"
}

output "stage" {
  value       = local.enabled ? local.stage : ""
  description = "Normalized stage"
}

output "delimiter" {
  value       = local.enabled ? local.delimiter : ""
  description = "Delimiter between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

output "attributes" {
  value       = local.enabled ? local.attributes : []
  description = "List of attributes"
}

output "tags" {
  value       = local.enabled ? local.tags : {}
  description = "Normalized Tag map"
}

output "additional_tag_map" {
  value       = local.additional_tag_map
  description = "The merged additional_tag_map"
}

output "label_order" {
  value       = local.label_order
  description = "The naming order actually used to create the ID"
}