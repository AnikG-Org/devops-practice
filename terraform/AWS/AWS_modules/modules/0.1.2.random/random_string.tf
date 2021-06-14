

resource "random_string" "name" {
  length  = var.name_length
  special = var.name_special
  number  = var.name_number
  upper   = var.name_upper
}

locals {
  random_name = random_string.name.result
}

