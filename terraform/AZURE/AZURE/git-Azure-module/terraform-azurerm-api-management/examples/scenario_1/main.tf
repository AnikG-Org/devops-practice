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

module "api_management" {
  source               = "../../"
  name                 = "ngtestingapim"
  resource_group_name  = data.azurerm_resource_group.app_env_resource_group.name
  location             = data.azurerm_resource_group.app_env_resource_group.location
  publisher_name       = "pwc"
  publisher_email      = "lavanya.neruthan@pwc.com"
  sku_name             = "Developer_1"
  virtual_network_type = "None"
  certificates = [{
    b64_pfx_cert_data    = filebase64("${path.module}/mycert.pfx")
    certificate_password = "Welcome@123"
    store_name           = "Root"
    }
  ]
  hostname_config = {
    management = {
      "host_name" : "mgmt.portal.pwc.com",
      "certificate" : filebase64("${path.module}/mgmt.pfx"),
      "certificate_password" : "Welcome@123",
      "negotiate_client_certificate" : false
    }
    portal = {
      "host_name" : "portal.portal.pwc.com",
      "certificate" : filebase64("${path.module}/portal.pfx"),
      "certificate_password" : "Welcome@123",
      "negotiate_client_certificate" : false
    }
    dev_portal = {
      "host_name" : "dev.portal.pwc.com",
      "certificate" : filebase64("${path.module}/dev.pfx"),
      "certificate_password" : "Welcome@123",
      "negotiate_client_certificate" : false
    }
    scm = {
      "host_name" : "scm.portal.pwc.com",
      "certificate" : filebase64("${path.module}/scm.pfx"),
      "certificate_password" : "Welcome@123",
      "negotiate_client_certificate" : false
    }

    proxy = {
      "default_ssl_binding" : true,
      "host_name" : "proxy.portal.pwc.com",
      "certificate" : filebase64("${path.module}/proxy.pfx"),
      "certificate_password" : "Welcome@123",
      "negotiate_client_certificate" : false
    }
  }
  tags = local.tags
}
