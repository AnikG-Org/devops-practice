  
# output "datadog_monitor_tags" {
#   value = 
# }

output "datadog_monitor_names" {
  value       = datadog_monitor.resource[*].name
  description = "Names of the created Datadog monitors"
}

output "datadog_monitor_ids" {
  value       = datadog_monitor.resource[*].id
  description = "IDs of the created Datadog monitors"
}

output "datadog_monitors" {
  value       = datadog_monitor.resource[*]
  description = "Datadog monitor outputs"
}
