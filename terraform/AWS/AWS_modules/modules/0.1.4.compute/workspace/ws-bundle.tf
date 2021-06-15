data "aws_workspaces_bundle" "standard_windows_10" {
  bundle_id = "wsb-8vbljg4r6" # Standard Windows 10 (English)
}
data "aws_workspaces_bundle" "value_windows_10" {
  bundle_id = "wsb-bh8rsxt14" # Value with Windows 10 (English)
}
data "aws_workspaces_bundle" "value_al_2" {
  bundle_id = "wsb-clj85qzj1" # Value with AL 2
}
data "aws_workspaces_bundle" "standard_al_2" {
  bundle_id = "wsb-8vbljg4r6" # Standard Windows 10 (English)
}
data "aws_workspaces_bundle" "power_al_2" {
  bundle_id = "wsb-2bs6k5lgn" # Power with AL 2
}
data "aws_workspaces_bundle" "value_Windows_10_Office_2016" {
  owner = "AMAZON"
  name  = "Value with Windows 10 and Office 2016"
}
########################### OP ###############################
output "ws_bundle_id" {
  value = zipmap(["standard_windows_10", "value_windows_10", "value_Windows_10_Office_2016", "value_al_2", "power_al_2"], [data.aws_workspaces_bundle.standard_windows_10.id, data.aws_workspaces_bundle.value_windows_10.id, data.aws_workspaces_bundle.value_Windows_10_Office_2016.id, data.aws_workspaces_bundle.value_al_2.id, data.aws_workspaces_bundle.power_al_2.id])
}