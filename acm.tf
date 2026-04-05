# ACM certificate must be in us-east-1 for CloudFront
resource "aws_acm_certificate" "website" {
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
