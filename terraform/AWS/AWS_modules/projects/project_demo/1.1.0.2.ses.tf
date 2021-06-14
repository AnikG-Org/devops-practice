/* #enable when required
module "ses" {
  source          = "../../modules/0.1.7.monitoring/ses"
  

  domain              = local.domain_name
  iam_name            = "" #"anik.g@ses.com"
  zone_id             = module.r53_internal_zone.internal_hosted_zone_id 
  enable_verification = false
  enable_mx           = false
  enable_spf_domain   = false
 }
 */