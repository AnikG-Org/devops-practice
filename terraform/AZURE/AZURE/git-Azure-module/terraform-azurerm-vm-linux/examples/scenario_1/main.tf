
# Linux -VM
# -------------
# The module will create a Linux Virtual Machine and associate the VM with the Recovery Service Vault

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
  name                 = "PZI-GXUS-G-SNT-OOFMH-T015"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_storage_account" "storage" {
  name                = var.user_parameters.naming_service.storage.k02
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_recovery_services_vault" "vault" {
  name                = "pzi-us-e-rsv-oofmh-r009"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_backup_policy_vm" "backup_policy" {
  name                = "livmbackup"
  recovery_vault_name = data.azurerm_recovery_services_vault.vault.name
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "linux-vm" {
  source                = "../../"
  resource_group_name   = data.azurerm_resource_group.app_env_resource_group.name
  subnet_id             = data.azurerm_subnet.subnet.id
  hostname              = var.user_parameters.naming_service.vm_instance.k02
  admin_username        = "ngadmin"
  admin_password        = "Passw0rd@123"
  source_image_id       = "/subscriptions/c72daa19-9a38-4155-b2c6-9121045a0fdc/resourceGroups/PZI-GXUS-S-RGP-IMGP-P001/providers/Microsoft.Compute/galleries/PwCSIG_West/images/AZU_CENTOS_Base"
  storage_account_uri   = data.azurerm_storage_account.storage.primary_blob_endpoint
  ip_configuration_name = "ipconfig1"
  recovery_vault_name   = data.azurerm_recovery_services_vault.vault.name
  backup_policy_id      = data.azurerm_backup_policy_vm.backup_policy.id
  tags                  = local.tags
}
