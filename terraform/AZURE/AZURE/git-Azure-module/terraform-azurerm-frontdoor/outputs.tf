output "frontdoor_cname" {
  description = "The host that each frontendEndpoint must CNAME to."
  value       = try(azurerm_frontdoor.frontdoor[*].cname, null)
}

output "frontdoor_id" {
  description = "The ID of the FrontDoor."
  value       = try(azurerm_frontdoor.frontdoor[*].id, null)
}

output "frontdoor_header_frontdoor_id" {
  description = "The unique ID of the Front Door which is embedded into the incoming headers X-Azure-FDID attribute and maybe used to filter traffic sent by the Front Door to your backend."
  value       = try(azurerm_frontdoor.frontdoor[*].header_frontdoor_id, null)
}