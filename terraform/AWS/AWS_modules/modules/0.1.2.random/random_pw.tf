#provider "random" {}

resource "random_password" "password" {
  length      = local.length
  special     = var.pw_special
  min_upper   = random_integer.min_upper.result
  min_lower   = random_integer.min_lower.result
  min_numeric = random_integer.min_numeric.result
}

resource "random_integer" "min_upper" {
  min = 1
  max = 15
}
resource "random_integer" "min_lower" {
  min = 1
  max = 20
}
resource "random_integer" "min_numeric" {
  min = 1
  max = 15
}

locals {
  length    = var.pw_leangth
  random_pw = random_password.password.result
}


