resource "azurerm_synapse_workspace" "synapse_workspace" {
  name                                 = var.name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.storage_data_lake_gen2_filesystem_id
  sql_administrator_login              = var.sql_administrator_login
  sql_administrator_login_password     = var.sql_administrator_login_password

 # aad_admin {
 #   login     = var.aad_admin_login
 #   object_id = var.object_id
 #   tenant_id = var.tenant_id
 # }

  tags = var.tags
}