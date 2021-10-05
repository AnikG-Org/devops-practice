#data "azurerm_client_config" "current" {}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = var.default_node_pool_name
    node_count = var.node_count
    vm_size    = var.vm_size
  }

#    addon_profile {
#      oms_agent {
#        enabled                    = var.oms_agent
#        log_analytics_workspace_id = var.log_analytics_workspace_id
#  }
#}

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
  tags = var.tags
}
