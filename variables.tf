variable "aws_region" {
  description = "Default AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "domain_name" {
  description = "Primary domain name"
  type        = string
  default     = "scaledaiops.org"
}

variable "enable_ffrs" {
  description = "Provision the Fast Feedback Resolution System (API, storage, SES, CloudFront /api/* behaviour). false removes it all."
  type        = bool
  default     = false
}

variable "ffrs_lambda_zip" {
  description = "Path to ffrs-api bundle (cd ../ffrs-api && npm run package)"
  type        = string
  default     = "../ffrs-api/dist/handler.zip"
}

variable "ffrs_alert_email" {
  description = "Maintainer inbox for FFRS alerts"
  type        = string
  default     = ""
}

variable "ffrs_github_repo" {
  description = "owner/repo for FFRS issues, e.g. Scaled-AIOps/feedback"
  type        = string
  default     = "Scaled-AIOps/feedback"
}
