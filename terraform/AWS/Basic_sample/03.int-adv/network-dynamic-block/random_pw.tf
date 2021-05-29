provider "random" {}

resource "random_password" "password" {
  length      = "${local.length}"
  special     = true
  min_upper   = "${random_integer.min_upper.result}"
  min_lower   = "${random_integer.min_lower.result}"
  min_numeric = "${random_integer.min_numeric.result}"
}

resource "random_integer" "min_upper" {
  min = 1
  max = 5
}
resource "random_integer" "min_lower" {
  min = 1
  max = 5
}
resource "random_integer" "min_numeric" {
  min = 1
  max = 5
}

locals {
  length = 10
  random_pw = random_password.password.result
}

output "random_passwd" {
  value = local.random_pw
}
