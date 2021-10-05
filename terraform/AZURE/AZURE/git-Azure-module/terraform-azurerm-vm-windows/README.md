# terraform-azurerm-vm-windows

## Usage
``` terraform

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

```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12 |
| terraform | >= 0.12 |
| azurerm | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backup\_policy\_id | Specifies the id of the backup policy to use | `string` | n/a | yes |
| boot\_diagnostics\_storage\_acc\_uri | The storage account URI to point the diagnostics to. Default value is empty string. | `string` | n/a | yes |
| hostname | Hostname of the windows vm to be deployed. | `string` | n/a | yes |
| ip\_configuration\_name | IP configuration name on the NIC's. | `string` | n/a | yes |
| ipaddress | Static IPAddress used for the primary nic. | `string` | n/a | yes |
| license\_type | Specifies the type of on-premise license (also known as Azure Hybrid Use Benefit) which should be used for this Virtual Machine. Possible values are None, Windows\_Client and Windows\_Server. | `string` | n/a | yes |
| location | The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions. | `string` | n/a | yes |
| osdisk\_managed\_disk\_size | Size of managed disk for the OSDisk on the VM. | `string` | n/a | yes |
| password | The admin password for the deployed VM. | `string` | n/a | yes |
| recovery\_services\_vault\_name | Specifies the name of the Recovery Services Vault to use. | `string` | n/a | yes |
| resource\_group\_name | Resource group name in which the VM's will be created. | `string` | n/a | yes |
| size | Size of the Azure VM to be deployed. | `string` | n/a | yes |
| source\_image\_id | The Shared Gallery Image ID for the image to be used when deploying the VM. | `string` | n/a | yes |
| subnetid | Subnet id to create primary nic. | `string` | n/a | yes |
| tags | Map of tags to be attached with VM, Recovery Service Vault and Backup Policy. | `map(string)` | n/a | yes |
| application\_security\_group\_id | List of ASG ids to associate to nics associated to deployed VM. | `string` | `""` | no |
| availability\_set\_id | Resource ID for the availability set to attach this VM to. | `string` | `null` | no |
| identity\_type | The Managed Service Identity Type of this Virtual Machine. Possible values are SystemAssigned (where Azure will generate a Service Principal for you), UserAssigned (where you can specify the Service Principal ID's) to be used by this Virtual Machine using the identity\_ids field, and SystemAssigned, UserAssigned which assigns both a system managed identity as well as the specified user assigned identities. | `string` | `null` | no |
| nicids | Provide the NIC ids to be attached to this vm. | `list` | `[]` | no |
| osdisk\_managed\_disk\_type | Type of managed disk for the OSDisk on the VM. | `string` | `"Standard_LRS"` | no |
| zone | Availability zone in which the virtual machine should be deployed (valid values are: 1, 2, or 3) | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| backup\_protected\_vm\_id | The ID of the Backup Protected Virtual Machine. |
| nic\_id | The ID of primary NIC created |
| nic\_name | The Name of primary NIC created |
| vm\_id | The ID of newly created VM |
| vm\_name | The name of newly created VM |

## Release Notes

The newest published version of this module is v7.1.0.

- View the complete change log [here](./changelog.md)
