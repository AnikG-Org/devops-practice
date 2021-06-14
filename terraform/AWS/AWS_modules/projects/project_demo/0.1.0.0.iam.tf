/*
################## iam_user ##################################
module "iam_user" {
  source = "../../modules/0.1.3.security/iam-enhanced/modules/iam-user"
  name          = "anik.g@domain.com"
  #IAM access key
  create_iam_access_key         = true
  create_iam_user_login_profile = true
  pgp_key = "keybase:anikg"                # User "test" has uploaded his public key here - https://keybase.io/test/pgp_keys.asc  # When pgp_key is specified as keybase:username, make sure that that user has already uploaded public key to keybase.io. For example, user with username test has done it properly
                                          #https://keybase.io/anikg/key.asc  #https://docs.aws.amazon.com/cdk/latest/guide/pgp-keys.html
  password_reset_required = false

  groups    = []

  # SSH public key
  upload_iam_user_ssh_key = false
  #ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA0sUjdTEcOWYgQ7ESnHsSkvPUO2tEvZxxQHUZYh9j6BPZgfn13iYhfAP2cfZznzrV+2VMamMtfiAiWR39LKo/bMN932HOp2Qx2la14IbiZ91666FD+yZ4+vhR2IVhZMe4D+g8FmhCfw1+zZhgl8vQBgsRZIcYqpYux59FcPv0lP1EhYahoRsUt1SEU2Gj+jvgyZpe15lnWk2VzfIpIsZ++AeUqyHoJHV0RVOK4MLRssqGHye6XkA3A+dMm2Mjgi8hxoL5uuwtkIsAll0kSfL5O2G26nsxm/Fpcl+SKSO4gs01d9V83xiOwviyOxmoXzwKy4qaUGtgq1hWncDNIVG/aQ=="
}
###################### IAM USER GROUP ##########################
module "iam_sysops_group" {
  source = "../../modules/0.1.3.security/iam-enhanced/modules/iam-group-with-policies"
  name = "SysopsAdministrator"

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/SystemAdministrator",
    "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess",
  ]
  group_users = [
    module.iam_user.iam_user_name,
  ]
}
########################

################################################################
output "keybase_login_profile_password_pgp_message" {
  value = module.iam_user.keybase_password_pgp_message  
}
output "iam_access_key_id" {
  value = module.iam_user.iam_access_key_id  
}
output "keybase_secret_access_key_pgp_message" {
  value = module.iam_user.keybase_secret_key_pgp_message  
}


*/


