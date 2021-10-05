resource "azurerm_managed_disk" "datadisk" {
  count                = var.datadisk_count
  name                 = format("%s-datadisk-%s", var.vm_name, count.index + 1)
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = lookup(var.data_disk_specs[count.index], "storage_account_type", local.storage_account_type)
  disk_size_gb         = lookup(var.data_disk_specs[count.index], "disk_size_gb")
  create_option        = lookup(var.data_disk_specs[count.index], "create_option", local.create_option)
  disk_iops_read_write = lookup(var.data_disk_specs[count.index], "disk_iops_read_write", local.disk_iops_read_write)
  disk_mbps_read_write = lookup(var.data_disk_specs[count.index], "disk_mbps_read_write", local.disk_mbps_read_write)
  zones                = var.zones
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attachment" {
  count              = var.datadisk_count
  managed_disk_id    = azurerm_managed_disk.datadisk[count.index].id
  virtual_machine_id = var.vm_id
  lun                = count.index
  caching            = var.caching
}
