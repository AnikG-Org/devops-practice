module "secrets-manager-2" {

  source = "../../"

  secrets = [
    {
      name        = "secret-kv-1"
      description = "This is a key/value secret"
      secret_key_value = {
        key1 = "value1"
        key2 = "value2"
      }
      recovery_window_in_days = 7
    },
    {
      name        = "secret-kv-2"
      description = "Another key/value secret"
      secret_key_value = {
        username = "user"
        password = "topsecret"
      }
      tags = {
        app = "web"
      }
      recovery_window_in_days = 7
    },
  ]

  tags = {
    Owner     = "DevOps team"
    Terraform = true
  }

}
