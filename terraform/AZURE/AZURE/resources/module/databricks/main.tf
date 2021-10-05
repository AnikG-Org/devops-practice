resource "azurerm_databricks_workspace" "databrics_workspace" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.databricks_sku
  tags                = var.tags
}
#  custom_parameters {
#    no_public_ip        = var.no_public_ip
#    public_subnet_name  = var.public_subnet_name
#    private_subnet_name = var.private_subnet_name
#    virtual_network_id  = var.virtual_network_id
#  }