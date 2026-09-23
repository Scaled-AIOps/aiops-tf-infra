output "endpoint" {
  description = "The service host every tenant embeds"
  value       = "https://${local.host}"
}

output "distribution_domain" {
  description = "CNAME target for ffrs.<domain> at the registrar"
  value       = aws_cloudfront_distribution.service.domain_name
}

output "distribution_id" {
  value = aws_cloudfront_distribution.service.id
}

output "assets_bucket" {
  value = aws_s3_bucket.assets.bucket
}

output "lambda_function_name" {
  value = aws_lambda_function.api.function_name
}

output "data_bucket" {
  value = aws_s3_bucket.data.bucket
}

# Add these at GoDaddy to verify SES sending
output "ses_dns_records" {
  value = merge(
    { for i, t in aws_sesv2_email_identity.domain.dkim_signing_attributes[0].tokens :
      "dkim_${i + 1}" => { type = "CNAME", name = "${t}._domainkey.${var.domain_name}", value = "${t}.dkim.amazonses.com" }
    },
    {
      mail_from_mx  = { type = "MX", name = "mail.${var.domain_name}", value = "10 feedback-smtp.${data.aws_region.current.region}.amazonses.com" }
      mail_from_spf = { type = "TXT", name = "mail.${var.domain_name}", value = "v=spf1 include:amazonses.com ~all" }
    }
  )
}
