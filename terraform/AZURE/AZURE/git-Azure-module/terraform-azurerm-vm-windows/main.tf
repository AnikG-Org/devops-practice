resource "azurerm_network_interface" "nic" {
  name                = "${var.hostname}-nic1"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnetid
    private_ip_address_allocation = (var.ipaddress == null ? "dynamic" : "static")
    private_ip_address            = var.ipaddress
  }

  tags = var.tags
}

resource "azurerm_network_interface_application_security_group_association" "assocation" {
  count                         = var.application_security_group_id == "" ? 0 : 1
  network_interface_id          = azurerm_network_interface.nic.id
  application_security_group_id = var.application_security_group_id
}

resource "azurerm_windows_virtual_machine" "windows_virtual_machine" {
  name                  = var.hostname
  admin_username        = "svroperator"
  admin_password        = var.password
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.size
  network_interface_ids = concat(var.nicids, [azurerm_network_interface.nic.id])
  availability_set_id   = var.availability_set_id
  license_type          = var.license_type
  source_image_id       = var.source_image_id
  provision_vm_agent    = true

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_acc_uri
  }

  os_disk {
    name                 = "${var.hostname}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.osdisk_managed_disk_type
    disk_size_gb         = var.osdisk_managed_disk_size
  }

  dynamic "identity" {
    for_each = var.identity_type[*]
    content {
      type = var.identity_type
    }
  }

  tags = var.tags
  zone = var.zone
}

resource "azurerm_backup_protected_vm" "vm_backup" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_services_vault_name
  source_vm_id        = azurerm_windows_virtual_machine.windows_virtual_machine.id
  backup_policy_id    = var.backup_policy_id
  tags                = var.tags
}
