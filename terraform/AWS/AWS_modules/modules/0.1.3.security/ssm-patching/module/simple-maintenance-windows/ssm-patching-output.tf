output "scan_maintenance_windows_id" {
  description = "the scan maintenance windows Id"
  value       = aws_ssm_maintenance_window.scan_window.id
}

output "install_maintenance_windows_id" {
  description = "The install maintenance windows Id"
  value       = aws_ssm_maintenance_window.install_window.id
}

