# Fast Feedback Resolution System — fully detachable via var.enable_ffrs
module "ffrs" {
  count           = var.enable_ffrs ? 1 : 0
  source          = "./modules/ffrs"
  domain_name     = var.domain_name
  certificate_arn = aws_acm_certificate.website.arn
  lambda_zip      = var.ffrs_lambda_zip
}

output "ffrs" {
  value = var.enable_ffrs ? {
    endpoint            = module.ffrs[0].endpoint
    distribution_domain = module.ffrs[0].distribution_domain # CNAME ffrs.<domain> → this, at GoDaddy
    distribution_id     = module.ffrs[0].distribution_id
    assets_bucket       = module.ffrs[0].assets_bucket
    lambda              = module.ffrs[0].lambda_function_name
    ses_dns_records     = module.ffrs[0].ses_dns_records
  } : null
}
