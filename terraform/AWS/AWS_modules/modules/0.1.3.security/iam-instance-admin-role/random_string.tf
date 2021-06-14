#provider "random" {}

resource "random_string" "name_1" {
  length  = 8
  special = false
  number  = true
  upper   = false
}

locals {
  random_string = random_string.name_1.result
}

output "random_string" {
  value = local.random_string
}