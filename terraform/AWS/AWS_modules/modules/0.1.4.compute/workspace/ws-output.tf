output "computer_name" {
  description = "returns a string"
  value       = aws_workspaces_workspace.this.*.computer_name
}
output "id" {
  description = "returns a string"
  value       = aws_workspaces_workspace.this.*.id
}
output "ip_address" {
  description = "returns a string"
  value       = aws_workspaces_workspace.this.*.ip_address
}
output "state" {
  description = "returns a string"
  value       = aws_workspaces_workspace.this.*.state
}
output "this" {
  value = aws_workspaces_workspace.this[*]
}
##########
output "ip_group_id" {
  description = "returns a string"
  value       = aws_workspaces_ip_group.this.*.id
}
output "ip_group" {
  value = aws_workspaces_ip_group.this[*]
}