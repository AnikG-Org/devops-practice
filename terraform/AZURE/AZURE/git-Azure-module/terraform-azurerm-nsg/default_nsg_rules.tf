locals {
  single_source_single_destination = [{
    "name"                       = "LOADBALANCER_INBOUND"
    "priority"                   = "100"
    "direction"                  = "inbound"
    "access"                     = "Allow"
    "protocol"                   = "*"
    "source_port_range"          = "*"
    "destination_port_range"     = "*"
    "source_address_prefix"      = "AzureLoadBalancer"
    "destination_address_prefix" = var.workload_subnet
    },
    {
      "name"                       = "SNT_INBOUND"
      "priority"                   = "300"
      "direction"                  = "inbound"
      "access"                     = "Allow"
      "protocol"                   = "*"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefix"      = var.workload_subnet
      "destination_address_prefix" = var.workload_subnet
    },
    {
      "name"                       = "GW_INBOUND"
      "priority"                   = "305"
      "direction"                  = "inbound"
      "access"                     = "Allow"
      "protocol"                   = "*"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefix"      = var.gateway_subnet
      "destination_address_prefix" = var.workload_subnet
    },
    {
      "name"                       = "TRANSIT_VNT_INBOUND"
      "priority"                   = "310"
      "direction"                  = "inbound"
      "access"                     = "Allow"
      "protocol"                   = "*"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefix"      = var.transit_subnet
      "destination_address_prefix" = var.workload_subnet
    },
    {
      "name"                       = "PWC_INBOUND"
      "priority"                   = "500"
      "direction"                  = "inbound"
      "access"                     = "Allow"
      "protocol"                   = "*"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefix"      = "10.0.0.0/8"
      "destination_address_prefix" = var.workload_subnet
    },
    {
      "name"                       = "DENY_INTERNET_INBOUND"
      "priority"                   = "600"
      "direction"                  = "inbound"
      "access"                     = "Deny"
      "protocol"                   = "*"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefix"      = "INTERNET"
      "destination_address_prefix" = "*"
    },
    {
      "name"                       = "DENY_ALL_INBOUND_TCP"
      "priority"                   = "4000"
      "direction"                  = "inbound"
      "access"                     = "Deny"
      "protocol"                   = "TCP"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "*"
    },
    {
      "name"                       = "DENY_ALL_INBOUND_UDP"
      "priority"                   = "4001"
      "direction"                  = "inbound"
      "access"                     = "Deny"
      "protocol"                   = "UDP"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "*"
    },
    {
      "name"                       = "SMTP_OUTBOUND"
      "priority"                   = "150"
      "direction"                  = "outbound"
      "access"                     = var.smtp_access
      "protocol"                   = "*"
      "source_port_range"          = "*"
      "destination_port_range"     = "25"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "*"
    },
    {
      "name"                       = "INFR_OUTBOUND"
      "priority"                   = "400"
      "direction"                  = "outbound"
      "access"                     = "Allow"
      "protocol"                   = "*"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefix"      = var.workload_subnet
      "destination_address_prefix" = "10.0.0.0/8"
    },
    {
      "name"                       = "WEB_OUTBOUND_443"
      "priority"                   = "425"
      "direction"                  = "outbound"
      "access"                     = "Allow"
      "protocol"                   = "TCP"
      "source_port_range"          = "*"
      "destination_port_range"     = "443"
      "source_address_prefix"      = var.workload_subnet
      "destination_address_prefix" = "*"
    },
    {
      "name"                       = "WEB_OUTBOUND_80"
      "priority"                   = "430"
      "direction"                  = "outbound"
      "access"                     = "Allow"
      "protocol"                   = "TCP"
      "source_port_range"          = "*"
      "destination_port_range"     = "80"
      "source_address_prefix"      = var.workload_subnet
      "destination_address_prefix" = "*"
    },
    {
      "name"                       = "KMS_OUTBOUND_1688"
      "priority"                   = "435"
      "direction"                  = "outbound"
      "access"                     = "Allow"
      "protocol"                   = "TCP"
      "source_port_range"          = "*"
      "destination_port_range"     = "1688"
      "source_address_prefix"      = var.workload_subnet
      "destination_address_prefix" = "*"
    },
    {
      "name"                       = "DENY_INTERNET_OUTBOUND_TCP"
      "priority"                   = "700"
      "direction"                  = "outbound"
      "access"                     = "Deny"
      "protocol"                   = "TCP"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "INTERNET"
    },
    {
      "name"                       = "DENY_INTERNET_OUTBOUND_UDP"
      "priority"                   = "701"
      "direction"                  = "outbound"
      "access"                     = "Deny"
      "protocol"                   = "UDP"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefix"      = "*"
      "destination_address_prefix" = "INTERNET"
    }
  ]

  single_source_multi_destination = [
    {
      "name"                         = "PUPPET_OUTBOUND_8140"
      "priority"                     = "440"
      "direction"                    = "outbound"
      "access"                       = "Allow"
      "protocol"                     = "TCP"
      "source_port_range"            = "*"
      "destination_port_range"       = "8140"
      "source_address_prefix"        = var.workload_subnet
      "destination_address_prefixes" = ["104.45.170.47", "40.119.145.159", "52.187.64.85", "104.45.175.135"]
    },
    {
      "name"                         = "PUPPET_OUTBOUND_8142"
      "priority"                     = "441"
      "direction"                    = "outbound"
      "access"                       = "Allow"
      "protocol"                     = "TCP"
      "source_port_range"            = "*"
      "destination_port_range"       = "8142"
      "source_address_prefix"        = var.workload_subnet
      "destination_address_prefixes" = ["104.45.170.47", "40.119.145.159", "52.187.64.85", "104.45.175.135"]
    },
  ]

  multi_source_single_destination = [
    {
      "name"                       = "VNT_INBOUND"
      "priority"                   = "320"
      "direction"                  = "inbound"
      "access"                     = "Deny"
      "protocol"                   = "*"
      "source_port_range"          = "*"
      "destination_port_range"     = "*"
      "source_address_prefixes"    = var.vnet_address_spaces
      "destination_address_prefix" = var.workload_subnet
    },
  ]
}
