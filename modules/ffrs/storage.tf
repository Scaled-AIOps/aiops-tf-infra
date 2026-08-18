# Private data: sidecars (email), idempotency map, screenshots. Encrypted; screenshots auto-expire.
resource "aws_s3_bucket" "data" {
  bucket = "${var.domain_name}-${var.name}-data"
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket                  = aws_s3_bucket.data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    id     = "expire-screenshots"
    status = "Enabled"
    filter { prefix = "screenshots/" }
    expiration { days = var.screenshot_retention_days }
  }
  rule {
    id     = "expire-idempotency"
    status = "Enabled"
    filter { prefix = "idem/" }
    expiration { days = 7 }
  }
}

# Kill switch. Value is toggled out-of-band; Terraform only guarantees it exists.
resource "aws_ssm_parameter" "enabled" {
  name  = "${var.ssm_prefix}/enabled"
  type  = "String"
  value = "true"
  lifecycle { ignore_changes = [value] }
}
