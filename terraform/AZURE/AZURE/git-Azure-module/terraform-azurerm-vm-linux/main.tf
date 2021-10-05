locals {
  os_disk_size                    = var.disk_size_gb < 100 ? 100 : var.disk_size_gb
  disable_password_authentication = (var.ssh_public_key != null) ? true : false
  admin_password                  = (var.ssh_public_key != null) ? null : var.admin_password
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.hostname}-nic1"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = (var.ip_address == null ? "dynamic" : "static")
    private_ip_address            = var.ip_address
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  name                = var.hostname
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size

  network_interface_ids           = concat(var.nicids, [azurerm_network_interface.nic.id])
  availability_set_id             = var.availability_set_id
  admin_username                  = var.admin_username
  admin_password                  = local.admin_password
  disable_password_authentication = local.disable_password_authentication

  boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }

  source_image_id              = var.source_image_id
  virtual_machine_scale_set_id = var.virtual_machine_scale_set_id
  zone                         = var.zone

  os_disk {
    name                      = "${var.hostname}_osdisk"
    storage_account_type      = var.storage_account_type
    caching                   = var.caching
    disk_size_gb              = local.os_disk_size
    disk_encryption_set_id    = var.disk_encryption_set_id
    write_accelerator_enabled = var.write_accelerator_enabled
  }

  additional_capabilities {
    ultra_ssd_enabled = var.ultra_ssd_enabled
  }

  dynamic "identity" {
    for_each = var.identity_type[*]
    content {
      type = var.identity_type
    }
  }

  dynamic "admin_ssh_key" {
    for_each = (var.ssh_public_key != null) ? [var.ssh_public_key] : []
    content {
      username   = var.admin_username
      public_key = file(admin_ssh_key.value)
    }
  }

  tags = var.tags

  depends_on = [var.backend_pool_association_id]
}

resource "azurerm_backup_protected_vm" "vm_backup" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = azurerm_linux_virtual_machine.linux_virtual_machine.id
  backup_policy_id    = var.backup_policy_id
  tags                = var.tags
}
