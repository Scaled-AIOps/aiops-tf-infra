data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_cloudwatch_log_group" "api" {
  name              = "/aws/lambda/${var.name}-api"
  retention_in_days = 30
}

resource "aws_iam_role" "lambda" {
  name = "${var.name}-api"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Effect = "Allow", Principal = { Service = "lambda.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}

resource "aws_iam_role_policy" "lambda" {
  name = "${var.name}-api"
  role = aws_iam_role.lambda.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Effect = "Allow", Action = ["logs:CreateLogStream", "logs:PutLogEvents"], Resource = "${aws_cloudwatch_log_group.api.arn}:*" },
      { Effect = "Allow", Action = ["ssm:GetParameter", "ssm:GetParameters"], Resource = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${var.ssm_prefix}/*" },
      { Effect = "Allow", Action = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"], Resource = "${aws_s3_bucket.screenshots.arn}/*" },
      { Effect = "Allow", Action = ["ses:SendEmail", "ses:SendTemplatedEmail"], Resource = "*" },
    ]
  })
}

resource "aws_lambda_function" "api" {
  function_name    = "${var.name}-api"
  role             = aws_iam_role.lambda.arn
  runtime          = "nodejs22.x"
  handler          = "handler.handler"
  architectures    = ["arm64"]
  filename         = var.lambda_zip
  source_code_hash = filebase64sha256(var.lambda_zip)
  memory_size      = 512
  timeout          = 15

  environment {
    variables = {
      SITE_NAME         = var.domain_name
      SSM_PREFIX        = var.ssm_prefix
      SCREENSHOT_BUCKET = aws_s3_bucket.screenshots.bucket
      ALLOWED_ORIGINS   = join(",", var.allowed_origins)
      SITE_URL          = "https://www.${var.domain_name}"
      FROM_EMAIL        = "feedback@${var.domain_name}"
      ALERT_EMAIL       = var.alert_email
      GITHUB_REPO       = var.github_repo
    }
  }

  depends_on = [aws_cloudwatch_log_group.api]
}

# Outbox drain, every minute
resource "aws_cloudwatch_event_rule" "outbox" {
  name                = "${var.name}-outbox"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "outbox" {
  rule  = aws_cloudwatch_event_rule.outbox.name
  arn   = aws_lambda_function.api.arn
  input = jsonencode({ job = "drain_outbox" })
}

# Weekly FFRS metrics report (Monday 07:00 UTC) → GitHub issue
resource "aws_cloudwatch_event_rule" "weekly" {
  name                = "${var.name}-weekly-report"
  schedule_expression = "cron(0 7 ? * MON *)"
}

resource "aws_cloudwatch_event_target" "weekly" {
  rule  = aws_cloudwatch_event_rule.weekly.name
  arn   = aws_lambda_function.api.arn
  input = jsonencode({ job = "weekly_report" })
}

resource "aws_lambda_permission" "events" {
  for_each      = { outbox = aws_cloudwatch_event_rule.outbox.arn, weekly = aws_cloudwatch_event_rule.weekly.arn }
  statement_id  = "AllowEventBridge-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "events.amazonaws.com"
  source_arn    = each.value
}
