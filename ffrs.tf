# Fast Feedback Response System — fully detachable via var.enable_ffrs
module "ffrs" {
  count       = var.enable_ffrs ? 1 : 0
  source      = "./modules/ffrs"
  domain_name = var.domain_name
  lambda_zip  = var.ffrs_lambda_zip
}

output "ffrs" {
  value = var.enable_ffrs ? {
    api_endpoint    = module.ffrs[0].api_endpoint
    lambda          = module.ffrs[0].lambda_function_name
    ses_dns_records = module.ffrs[0].ses_dns_records
  } : null
}
