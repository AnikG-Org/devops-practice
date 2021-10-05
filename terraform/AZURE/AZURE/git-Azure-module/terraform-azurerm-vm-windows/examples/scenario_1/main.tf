
# Windows -VM
# -------------
# The module will create a Windows Virtual Machine and associate the VM with the Recovery Service Vault

# Required Modules: 
#  > Recovery Service Vault module 
#  > Backup Policy Module

locals {
  vnet_resource_group_name = replace(var.system_parameters.VNET, "N-VNT", "N-RGP-BASE")
  tags = {
    "ghs-los" : var.system_parameters.TAGS.ghs-los,
    "ghs-solution" : var.system_parameters.TAGS.ghs-solution,
    "ghs-appid" : var.system_parameters.TAGS.ghs-appid,
    "ghs-solutionexposure" : var.system_parameters.TAGS.ghs-solutionexposure,
    "ghs-serviceoffering" : var.system_parameters.TAGS.ghs-serviceoffering,
    "ghs-environment" : var.system_parameters.TAGS.ghs-environment,
    "ghs-owner" : var.system_parameters.TAGS.ghs-owner,
    "ghs-apptioid" : var.system_parameters.TAGS.ghs-apptioid,
    "ghs-envid" : var.system_parameters.TAGS.ghs-envid,
    "ghs-tariff" : var.system_parameters.TAGS.ghs-tariff,
    "ghs-srid" : var.system_parameters.TAGS.ghs-srid,
    "ghs-environmenttype" : var.system_parameters.TAGS.ghs-environmenttype,
    "ghs-deployedby" : var.system_parameters.TAGS.ghs-deployedby,
    "ghs-dataclassification" : var.system_parameters.TAGS.ghs-dataclassification
  }
}

data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_virtual_network" "vnet" {
  name                = var.system_parameters.VNET
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = element(data.azurerm_virtual_network.vnet.subnets, 2)
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_availability_set" "availabilityset" {
  name                = var.user_parameters.availabilityset_name
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_storage_account" "storage" {
  name                = var.user_parameters.storage_account_name
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_recovery_services_vault" "vault" {
  name                = var.user_parameters.recovery_services_vault_name
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_backup_policy_vm" "backup_policy" {
  name                = var.user_parameters.backup_policy_vm_name
  recovery_vault_name = data.azurerm_recovery_services_vault.vault.name
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "vm-windows" {
  source                           = "../.."
  hostname                         = var.user_parameters.naming_service.cmdb_ci_vm_instance.k01
  resource_group_name              = data.azurerm_resource_group.app_env_resource_group.name
  location                         = var.__ghs.environment_hosting_region
  subnetid                         = data.azurerm_subnet.subnet.id
  ipaddress                        = null
  size                             = "Standard_D2_v3"
  ip_configuration_name            = var.user_parameters.ip_config_name
  availability_set_id              = data.azurerm_availability_set.availabilityset.id
  source_image_id                  = var.user_parameters.source_image_id
  password                         = var.user_parameters.vm_password
  license_type                     = "Windows_Server"
  osdisk_managed_disk_size         = "50"
  recovery_services_vault_name     = data.azurerm_recovery_services_vault.vault.name
  backup_policy_id                 = data.azurerm_backup_policy_vm.backup_policy.id
  boot_diagnostics_storage_acc_uri = data.azurerm_storage_account.storage.primary_blob_endpoint
  tags                             = local.tags
}
