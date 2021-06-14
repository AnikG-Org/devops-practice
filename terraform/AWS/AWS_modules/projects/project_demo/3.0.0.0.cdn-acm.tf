locals {
  #domain_name = "testqueues.com" # trimsuffix(data.aws_route53_zone.this.name, ".") already in place with route 53
  subdomain = "cdn"
}
######
# ACM
######
module "acm" {
  source             = "../../modules/0.1.6.network/acm"

  create_certificate = false

  domain_name               = local.domain_name
  zone_id                   = "" #module.r53_internal_zone.internal_hosted_zone_id
  subject_alternative_names = ["${local.subdomain}.${local.domain_name}"]
  validation_method         = "DNS"
  wait_for_validation       = false
  validate_certificate      = false
}
######

module "cloudfront_origin" {
  source = "../../modules/0.1.6.network/cloudfront"
  #
  create_distribution = false

  aliases             = ["${local.subdomain}.${local.domain_name}"]
  comment             = "This is a cloudfront comment"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = false #true #enable when creating CDN***
  origin_access_identities = {
    s3_bucket_one = "CloudFront can access"
  }

  logging_config = {
    bucket = "testvpn-dp.s3.ap-south-1.amazonaws.com"
    prefix = "cloudfront"
  }

  origin = {
    appsync = {
      domain_name = "appsync.${local.domain_name}"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1"]
      }

      custom_header = [
        {
          name  = "X-Forwarded-Scheme"
          value = "https"
        },
        {
          name  = "X-Frame-Options"
          value = "SAMEORIGIN"
        }
      ]
    }

    s3_one = {
      domain_name = "testvpn-dp.s3.ap-south-1.amazonaws.com"
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one" # key in `origin_access_identities`
        # cloudfront_access_identity_path = "origin-access-identity/cloudfront/E5IGQAA1QO48Z" # external OAI resource
      }
    }
  }

  origin_group = {
    group_one = {
      failover_status_codes      = [403, 404, 500, 502]
      primary_member_origin_id   = "appsync"
      secondary_member_origin_id = "s3_one"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "appsync"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true

    # lambda_function_association = {
    #   # Valid keys: viewer-request, origin-request, viewer-response, origin-response
    #   viewer-request = {
    #     lambda_arn   = "" #module.lambda_function.lambda_function_qualified_arn
    #     include_body = false
    #   }
    #   origin-request = {
    #     lambda_arn = ""
    #   }
    # }  
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true

      # lambda_function_association = {
      #   # Valid keys: viewer-request, origin-request, viewer-response, origin-response
      #   viewer-request = {
      #     lambda_arn   = "" #module.lambda_function.lambda_function_qualified_arn
      #     include_body = false
      #   }
      # #   origin-request = {
      # #     lambda_arn = ""
      # #   }
      # } 
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  geo_restriction = {
    restriction_type = "whitelist"
    locations        = ["NO", "UA", "US", "GB"]
  }

}
