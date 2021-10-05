# terraform-azurerm-vm-linux

## Usage
``` terraform

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

```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14 |
| terraform | >= 0.14 |
| azurerm | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_username | The admin user for the deployed vm. | `string` | n/a | yes |
| backup\_policy\_id | Specifies the id of the backup policy to use | `string` | n/a | yes |
| hostname | Hostname of the VM to be deployed. | `string` | n/a | yes |
| ip\_configuration\_name | Name of the nic Configuration to br created. | `string` | n/a | yes |
| recovery\_vault\_name | Specifies the name of the Recovery Services Vault to use. | `string` | n/a | yes |
| resource\_group\_name | Resource group name in which the VM's will be created | `string` | n/a | yes |
| source\_image\_id | The Shared Gallery Image ID for the image to be used when deploying the VM | `string` | n/a | yes |
| storage\_account\_uri | (Required) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor. | `string` | n/a | yes |
| subnet\_id | Subnet id to create primary nic. | `string` | n/a | yes |
| tags | Map of tags to be attached with VM, Recovery Service Vault and Backup Policy. | `map(string)` | n/a | yes |
| admin\_password | (Optional) The Password which should be used for the local-administrator on this Virtual Machine. | `string` | `null` | no |
| availability\_set\_id | Resource ID for the availability set to attach this VM to. | `string` | `null` | no |
| backend\_pool\_association\_id | Allows specifying an ID to reference a backend pool association for the created VM to ensure dependencies are handled properly by Terraform | `string` | `null` | no |
| caching | The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite. | `string` | `"ReadWrite"` | no |
| delete\_data\_disks\_on\_termination | Toggles whether to delete datadisks on termination or not. Default value is true | `bool` | `true` | no |
| delete\_os\_disk\_on\_termination | Toggles whether to delete the OS disk on termination or not. Default value is true | `bool` | `true` | no |
| disk\_encryption\_set\_id | (Optional) The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. | `string` | `null` | no |
| disk\_size\_gb | The disk size of the OS disk in GB. The recommended size and default is 100gb due to puppet expanding the disksize to 100gb. Do not use less that 100gb | `string` | `"100"` | no |
| identity\_type | The Managed Service Identity Type of this Virtual Machine. Possible values are SystemAssigned (where Azure will generate a Service Principal for you), UserAssigned (where you can specify the Service Principal ID's) to be used by this Virtual Machine using the identity\_ids field, and SystemAssigned, UserAssigned which assigns both a system managed identity as well as the specified user assigned identities. | `string` | `null` | no |
| ip\_address | Set to Null for Dynamic Ip address Allocation. For static set IP Address | `string` | `null` | no |
| location | The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | `"eastus"` | no |
| nicids | Provide the NIC ids to be attached to this vm. | `list(string)` | `[]` | no |
| osdisk\_managed\_disk\_type | Type of managed disk for the OSDisk on the VM. | `string` | `"Standard_LRS"` | no |
| ssh\_public\_key | The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format. Changing this forces a new resource to be created. If set ssh key authentication will be used | `string` | `null` | no |
| storage\_account\_type | The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard\_LRS, StandardSSD\_LRS and Premium\_LRS. Changing this forces a new resource to be created. | `string` | `"Standard_LRS"` | no |
| ultra\_ssd\_enabled | Toggle whether or not to enable Ultra SSD support on the VM. | `bool` | `false` | no |
| virtual\_machine\_scale\_set\_id | (Optional) Specifies the Orchestrated Virtual Machine Scale Set that this Virtual Machine should be created within. Changing this forces a new resource to be created. | `string` | `null` | no |
| vm\_size | Size of the Azure VM to be deployed. | `string` | `"Standard_A1_v2"` | no |
| write\_accelerator\_enabled | (Optional) Should Write Accelerator be Enabled for this OS Disk? Defaults to false. | `bool` | `false` | no |
| zone | the Zone in which this Virtual Machine should be created. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| backup\_protected\_vm\_id | The ID of the Backup Protected Virtual Machine. |
| id | ID of the virtual machine which is created |
| name | Name of the virtual machine which is created |
| nic\_id | ID of the NIC associated with the VM which is created |
| private\_ip\_addresses | All Private IP Addresses allocated to VM |

## Release Notes

The newest published version of this module is v9.0.0.

- View the complete change log [here](./changelog.md)
