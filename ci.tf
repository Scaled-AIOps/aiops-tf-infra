# TeamCity deploy identity: sync the website bucket and invalidate its distribution, nothing else.
# The access key is created outside Terraform so its secret never lands in state; it lives only in TeamCity.
resource "aws_iam_user" "ci_deploy" {
  name = "${replace(var.domain_name, ".", "-")}-ci-deploy"
}

resource "aws_iam_user_policy" "ci_deploy" {
  name = "site-deploy"
  user = aws_iam_user.ci_deploy.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ListSite"
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = aws_s3_bucket.website.arn
      },
      {
        Sid      = "WriteSite"
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:DeleteObject"]
        Resource = "${aws_s3_bucket.website.arn}/*"
      },
      {
        Sid      = "InvalidateSite"
        Effect   = "Allow"
        Action   = ["cloudfront:CreateInvalidation", "cloudfront:GetInvalidation"]
        Resource = aws_cloudfront_distribution.website.arn
      }
    ]
  })
}
