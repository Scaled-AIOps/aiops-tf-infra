# Screenshots: private, encrypted, auto-expire (PII: may show what the visitor typed)
resource "aws_s3_bucket" "screenshots" {
  bucket = "${var.domain_name}-${var.name}-screenshots"
}

resource "aws_s3_bucket_public_access_block" "screenshots" {
  bucket                  = aws_s3_bucket.screenshots.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "screenshots" {
  bucket = aws_s3_bucket.screenshots.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "screenshots" {
  bucket = aws_s3_bucket.screenshots.id
  rule {
    id     = "expire"
    status = "Enabled"
    filter {}
    expiration { days = var.screenshot_retention_days }
  }
}

# Kill switch. Value is toggled out-of-band; Terraform only guarantees it exists.
resource "aws_ssm_parameter" "enabled" {
  name  = "${var.ssm_prefix}/enabled"
  type  = "String"
  value = "true"
  lifecycle { ignore_changes = [value] }
}
