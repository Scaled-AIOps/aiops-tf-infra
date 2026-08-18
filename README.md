# aiops-tf-infra

Terraform for scaledaiops.org hosting (S3 + CloudFront + ACM) and the optional **FFRS** module (`modules/ffrs`: Lambda, API Gateway, private S3 data bucket, SES identity, weekly report rule, CloudFront `/api/*` behaviour). AWS profile `scaledaiops`, state in `s3://scaledaiops-tf-state`.

```bash
terraform init && terraform fmt -recursive && terraform validate && terraform plan   # confirm before apply
```

`terraform.tfvars` is gitignored — see `terraform.tfvars.example` for the production values (`enable_ffrs = true` since 2026-08-18). FFRS secrets live in SSM `/ffrs/*` (`github_token`, `github_webhook_secret`, `turnstile_secret`, `enabled` kill switch); the Lambda zip comes from `../ffrs-api/dist/handler.zip` (`npm run package`).
