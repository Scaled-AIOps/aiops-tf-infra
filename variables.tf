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
  description = "Provision the Fast Feedback Resolution System (Lambda, storage, SES, the ffrs.<domain> host). false removes it all. Tenants are configured in SSM, see ffrs-api scripts/tenant.sh."
  type        = bool
  default     = false
}

variable "ffrs_lambda_zip" {
  description = "Path to ffrs-api bundle (cd ../ffrs-api && npm run package)"
  type        = string
  default     = "../ffrs-api/dist/handler.zip"
}

