variable "name" {
  description = "Resource name prefix"
  type        = string
  default     = "ffrs"
}

variable "domain_name" {
  description = "ScaledAIOps domain: the SES sending identity, and the service host is ffrs.<domain>"
  type        = string
}

variable "certificate_arn" {
  description = "us-east-1 ACM certificate covering ffrs.<domain> (the site's wildcard)"
  type        = string
}

variable "lambda_zip" {
  description = "Path to the built ffrs-api bundle (npm run package)"
  type        = string
}

variable "ssm_prefix" {
  description = "SSM path: <prefix>/enabled kill switch, <prefix>/tenants/<slug>/* per tenant (set out-of-band, see ffrs-api scripts/tenant.sh)"
  type        = string
  default     = "/ffrs"
}

variable "default_tenant" {
  description = "Tenant slug served to requests that name no site — the original single-site widget"
  type        = string
  default     = "scaledaiops"
}

variable "screenshot_retention_days" {
  type    = number
  default = 90
}

locals {
  host = "${var.name}.${var.domain_name}"
}
