
output "datadog_synthetics_test_names" {
  value       = datadog_synthetics_test.Synthetictest[*].name
  description = "Names of the created Datadog Synthetic tests"
}

output "datadog_synthetic_tests" {
  value       = datadog_synthetics_test.Synthetictest[*]
  description = "The synthetic tests created in DataDog"
}