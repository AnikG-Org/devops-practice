resource "azurerm_databricks_workspace" "databricks_workspace" {    
  name                        = var.name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku                         = var.sku
  managed_resource_group_name = var.managed_resource_group_name
  custom_parameters {
      no_public_ip  = var.virtual_network_id == "" ? false:true
      public_subnet_name    = var.public_subnet_name
      private_subnet_name   = var.private_subnet_name
      virtual_network_id    = var.virtual_network_id
  }
  tags      = var.tags
}