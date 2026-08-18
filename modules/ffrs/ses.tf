resource "aws_sesv2_email_identity" "domain" {
  email_identity = var.domain_name
  dkim_signing_attributes { next_signing_key_length = "RSA_2048_BIT" }
}

resource "aws_sesv2_email_identity_mail_from_attributes" "domain" {
  email_identity   = aws_sesv2_email_identity.domain.email_identity
  mail_from_domain = "mail.${var.domain_name}"
}
