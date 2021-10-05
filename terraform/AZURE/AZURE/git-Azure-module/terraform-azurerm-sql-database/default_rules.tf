resource "azurerm_sql_firewall_rule" "UKExternalFacingIPsRange1" {
  count               = var.default_rules == false ? 0 : 1
  name                = "UKExternalFacingIPsRange1"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "155.201.34.0"
  end_ip_address      = "155.201.35.255"
}

resource "azurerm_sql_firewall_rule" "UKExternalFacingIPsRange2" {
  count               = var.default_rules == false ? 0 : 1
  name                = "UKExternalFacingIPsRange2"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "164.143.0.0"
  end_ip_address      = "164.143.255.255"
}

resource "azurerm_sql_firewall_rule" "ChinaSDCExternalFacingIPsRange1" {
  count               = var.default_rules == false ? 0 : 1
  name                = "ChinaSDCExternalFacingIPsRange1"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "210.13.94.0"
  end_ip_address      = "210.13.94.31"
}

resource "azurerm_sql_firewall_rule" "ChinaSDCExternalFacingIPsRange2" {
  count               = var.default_rules == false ? 0 : 1
  name                = "ChinaSDCExternalFacingIPsRange2"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "180.167.18.80"
  end_ip_address      = "180.167.18.95"
}

resource "azurerm_sql_firewall_rule" "SterlingSDCExternalFacingIPsRange1" {
  count               = var.default_rules == false ? 0 : 1
  name                = "SterlingSDCExternalFacingIPsRange1"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "65.183.24.0"
  end_ip_address      = "65.183.24.255"
}

resource "azurerm_sql_firewall_rule" "SterlingSDCExternalFacingIPsRange2" {
  count               = var.default_rules == false ? 0 : 1
  name                = "SterlingSDCExternalFacingIPsRange2"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "65.183.25.0"
  end_ip_address      = "65.183.25.255"
}

resource "azurerm_sql_firewall_rule" "SingaporeSDCExternalFacingIPsRange1" {
  count               = var.default_rules == false ? 0 : 1
  name                = "SingaporeSDCExternalFacingIPsRange1"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "208.175.209.0"
  end_ip_address      = "208.175.209.255"
}

resource "azurerm_sql_firewall_rule" "IndiaSDCExoraExternalFacingIPsRange1" {
  count               = var.default_rules == false ? 0 : 1
  name                = "IndiaSDCExoraExternalFacingIPsRange1"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "121.244.155.96"
  end_ip_address      = "121.244.155.127"
}

resource "azurerm_sql_firewall_rule" "IndiaSDCExoraExternalFacingIPsRange2" {
  count               = var.default_rules == false ? 0 : 1
  name                = "IndiaSDCExoraExternalFacingIPsRange2"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "121.244.155.208"
  end_ip_address      = "121.244.155.211"
}

resource "azurerm_sql_firewall_rule" "IndiaSDCExoraExternalFacingIPsRange3" {
  count               = var.default_rules == false ? 0 : 1
  name                = "IndiaSDCExoraExternalFacingIPsRange3"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "115.248.68.36"
  end_ip_address      = "115.248.68.39"
}

resource "azurerm_sql_firewall_rule" "IndiaSDCExoraExternalFacingIPsRange4" {
  count               = var.default_rules == false ? 0 : 1
  name                = "IndiaSDCExoraExternalFacingIPsRange4"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "115.249.229.148"
  end_ip_address      = "115.249.229.151"
}

resource "azurerm_sql_firewall_rule" "IndiaSDCEGLExternalFacingIPsRange1" {
  count               = var.default_rules == false ? 0 : 1
  name                = "IndiaSDCEGLExternalFacingIPsRange1"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "125.17.157.0"
  end_ip_address      = "125.17.157.255"
}

resource "azurerm_sql_firewall_rule" "IndiaSDCEGLExternalFacingIPsRange2" {
  count               = var.default_rules == false ? 0 : 1
  name                = "IndiaSDCEGLExternalFacingIPsRange2"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "220.227.79.184"
  end_ip_address      = "220.227.79.191"
}

resource "azurerm_sql_firewall_rule" "PRTMBangaloreExternalFacingIPsRange1" {
  count               = var.default_rules == false ? 0 : 1
  name                = "ChinaSDCExternalFacingIPsRange1"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "61.95.163.48"
  end_ip_address      = "61.95.163.63"
}

resource "azurerm_sql_firewall_rule" "PRTMBangaloreExternalFacingIPsRange2" {
  count               = var.default_rules == false ? 0 : 1
  name                = "ChinaSDCExternalFacingIPsRange1"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "115.249.241.160"
  end_ip_address      = "115.249.241.167"
}

resource "azurerm_sql_firewall_rule" "DIACMumbaiExternalFacingIPsRange1" {
  count               = var.default_rules == false ? 0 : 1
  name                = "DIACMumbaiExternalFacingIPsRange1"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "14.140.54.16"
  end_ip_address      = "14.140.54.31"
}

resource "azurerm_sql_firewall_rule" "DIACMumbaiExternalFacingIPsRange2" {
  count               = var.default_rules == false ? 0 : 1
  name                = "DIACMumbaiExternalFacingIPsRange2"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "203.101.91.32"
  end_ip_address      = "203.101.91.39"
}

resource "azurerm_sql_firewall_rule" "PricewaterhouseCoopersGerman" {
  count               = var.default_rules == false ? 0 : 1
  name                = "PricewaterhouseCoopersGerman"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "195.234.12.1"
  end_ip_address      = "195.234.13.254"
}

resource "azurerm_sql_firewall_rule" "PricewaterhouseCoopersEurope" {
  count               = var.default_rules == false ? 0 : 1
  name                = "PricewaterhouseCoopersEurope"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "91.151.24.1"
  end_ip_address      = "91.151.31.254"
}

resource "azurerm_sql_firewall_rule" "PricewaterhouseCoopersUK" {
  count               = var.default_rules == false ? 0 : 1
  name                = "PricewaterhouseCoopersUK"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "164.143.240.1"
  end_ip_address      = "164.143.247.254"
}

resource "azurerm_sql_firewall_rule" "PricewaterhouseCoopersGHCCentral1" {
  count               = var.default_rules == false ? 0 : 1
  name                = "PricewaterhouseCoopersGHCCentral1"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "62.200.104.4"
  end_ip_address      = "62.200.104.4"
}

resource "azurerm_sql_firewall_rule" "PricewaterhouseCoopersGHCCentral2" {
  count               = var.default_rules == false ? 0 : 1
  name                = "PricewaterhouseCoopersGHCCentral2"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "81.209.169.52"
  end_ip_address      = "81.209.169.52"
}

resource "azurerm_sql_firewall_rule" "PricewaterhouseCoopersGHCWest1" {
  count               = var.default_rules == false ? 0 : 1
  name                = "PricewaterhouseCoopersGHCWest1"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "167.14.100.1"
  end_ip_address      = "167.14.100.1"
}

resource "azurerm_sql_firewall_rule" "PricewaterhouseCoopersGHCWest2" {
  count               = var.default_rules == false ? 0 : 1
  name                = "PricewaterhouseCoopersGHCWest2"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "167.14.100.10"
  end_ip_address      = "167.14.100.10"
}

resource "azurerm_sql_firewall_rule" "USExternalFacingIPsRange1" {
  count               = var.default_rules == false ? 0 : 1
  name                = "USExternalFacingIPsRange1"
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  start_ip_address    = "155.201.0.0"
  end_ip_address      = "155.201.255.255"
}

