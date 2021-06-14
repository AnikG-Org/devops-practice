module "users_unencrypted_1" {
  source = "../../modules/0.1.7.monitoring/sns-topic"

  create_sns_topic = false #false by default (OPTIONAL)
  name             = "sp-support-standard"
}
module "users_unencrypted_2" {
  source = "../../modules/0.1.7.monitoring/sns-topic"

  create_sns_topic = false
  name             = "sp-support-urgent"
}
module "users_unencrypted_3" {
  source = "../../modules/0.1.7.monitoring/sns-topic"

  create_sns_topic = false
  name             = "sp-support-emergency"

  create_subscription_1 = false
  protocol_1            = "email"
  endpoint_1            = "email@domain.com"
}

module "customer_notifications" {
  source = "../../modules/0.1.7.monitoring/sns-topic"

  create_sns_topic = false
  name             = "customer_notification"
}