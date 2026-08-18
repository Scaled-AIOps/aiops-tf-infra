variable "name" {
  description = "Resource name prefix"
  type        = string
  default     = "ffrs"
}

variable "domain_name" {
  description = "Site domain; also the SES sending identity"
  type        = string
}

variable "lambda_zip" {
  description = "Path to the built ffrs-api bundle (npm run package)"
  type        = string
}

variable "ssm_prefix" {
  description = "SSM path holding secrets and the kill switch (values set out-of-band)"
  type        = string
  default     = "/ffrs"
}

variable "allowed_origins" {
  description = "Third-party embedder origins allowed via CORS"
  type        = list(string)
  default     = []
}

variable "screenshot_retention_days" {
  type    = number
  default = 90
}

variable "alert_email" {
  description = "Maintainer inbox for new-feedback alerts (empty disables the alert effect)"
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "owner/repo that is the FFRS system of record; token lives in SSM at <ssm_prefix>/github_token"
  type        = string
}
