output "s3_bucket_name" {
  value = aws_s3_bucket.website.id
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.website.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.website.domain_name
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.website.arn
}

# DNS records to configure in GoDaddy
output "dns_records" {
  value = {
    acm_validation = {
      for dvo in aws_acm_certificate.website.domain_validation_options : dvo.domain_name => {
        type  = dvo.resource_record_type
        name  = dvo.resource_record_name
        value = dvo.resource_record_value
      }
    }
    cloudfront_cname = {
      type  = "CNAME"
      name  = var.domain_name
      value = aws_cloudfront_distribution.website.domain_name
    }
    cloudfront_www = {
      type  = "CNAME"
      name  = "www.${var.domain_name}"
      value = aws_cloudfront_distribution.website.domain_name
    }
  }
}
