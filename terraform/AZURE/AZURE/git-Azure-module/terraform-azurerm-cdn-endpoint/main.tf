resource "azurerm_cdn_endpoint" "cdnendpoint" {
  name                = var.name
  profile_name        = var.profile_name
  location            = var.location
  resource_group_name = var.resource_group_name
  origin_host_header  = var.origin_host_header
  origin {
    name      = var.origin_name
    host_name = var.host_name
  }
  tags = var.tags
}

