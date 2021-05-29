provider "random" {}

resource "random_string" "name" {
  length  = 16
  special = false
  number  = true
  upper   = false
}

locals {
  random_name = random_string.name.result
}

output "random_name" {
  value = local.random_name
}