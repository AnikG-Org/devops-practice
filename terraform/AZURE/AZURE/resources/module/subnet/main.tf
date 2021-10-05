resource "azurerm_subnet" "subnet" {
  name                 = "SUB-${upper(var.org)}-${upper(var.bu_code)}-${upper(var.component)}-${upper(var.app_env_code)}-${var.sequence_no}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
  service_endpoints    = ["Microsoft.AzureActiveDirectory","Microsoft.KeyVault","Microsoft.Sql","Microsoft.Storage","Microsoft.ContainerRegistry","Microsoft.EventHub","Microsoft.ServiceBus"]
}