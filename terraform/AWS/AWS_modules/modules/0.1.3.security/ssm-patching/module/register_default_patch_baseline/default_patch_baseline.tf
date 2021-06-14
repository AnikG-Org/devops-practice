

resource "null_resource" "register_default_patch_baseline" {
  count = var.set_default_patch_baseline ? 1 : 0

  triggers = {
    operating_system = var.operating_system
    baseline_id      = var.patch_baseline_id
  }

  provisioner "local-exec" {
    command = <<EOT
      ${path.module}/register-default-patch-baseline-eu-central-1.py register ${self.triggers.baseline_id} ${self.triggers.operating_system}
EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      ${path.module}/register-default-patch-baseline-eu-central-1.py deregister non-existent ${self.triggers.operating_system}
EOT
  }
}

