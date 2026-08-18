output "api_origin_domain" {
  description = "API Gateway hostname for the CloudFront /api/* origin"
  value       = replace(aws_apigatewayv2_api.api.api_endpoint, "https://", "")
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.api.api_endpoint
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
      mail_from_mx  = { type = "MX", name = "mail.${var.domain_name}", value = "10 feedback-smtp.${data.aws_region.current.name}.amazonses.com" }
      mail_from_spf = { type = "TXT", name = "mail.${var.domain_name}", value = "v=spf1 include:amazonses.com ~all" }
    }
  )
}
