locals {
  env_codes_by_environment = {
    "san" = "X"
    "dev" = "D"
    "qua" = "Q"
    "uat" = "U"
    "stg" = "S"
    "ute" = "T"
    "prd" = "P"
    "low" = "L"
    "npd" = "N"
  }

  azure_region_abbreviations = {
    "North Europe"        = "NE"
    "Central US"          = "U1"
    "East US"             = "U2"
    "East US 2"           = "U3"
    "Western Europe"      = "WE"
    "West Europe"         = "WE"
    "Canada Central"      = "CC"
    "Canada East"         = "EC"
    "West Central US"     = "U4"
    "US Gov Iowa"         = "U5"
    "US Gov Virginia"     = "U6"
    "West US"             = "U7"
    "South Central US"    = "U8"
    "North Central US"    = "U9"
    "West US 2"           = "UW"
    "Japan East"          = "EJ"
    "Japan West"          = "WJ"
    "Australia East"      = "AU"
    "Southeast Australia" = "SA"
    "Southeast Asia"      = "A1"
  }

  pwc_prefix_code                         = split("-", var.subscription_name)[0]
  country_code_subscription               = substr(split("-", var.subscription_name)[1], 0, 2)
  pwc_global_it_country_code_subscription = substr(split("-", var.subscription_name)[1], 2, 2)
  subscription_env_code                   = split("-", var.subscription_name)[2]
  subscription_number                     = substr(split("-", var.subscription_name)[3], 3, 3)
  app_env                                 = split("-", var.environment)[1]
  app_region                              = split("-", var.environment)[2]
  app_env_code                            = var.app_env_code != null ? var.app_env_code : lookup(local.env_codes_by_environment, local.app_env)
  multi_region                            = var.secondary_location != null
  vm_resource_names_required              = var.vm_numbering_starts_with > 0
  subnet_resource_names_required          = var.subnet_count > 0
  key_prefixes                            = local.multi_region ? ["primary_", "secondary_"] : [""]
  common_resource_numbering_format        = local.multi_region ? ["%02da", "%02db"] : (var.regional_pair_code != null ? ["%02d${var.regional_pair_code}"] : ["%03d"])
  udr_numbering_format                    = local.multi_region ? ["a", "b"] : [""]
}
