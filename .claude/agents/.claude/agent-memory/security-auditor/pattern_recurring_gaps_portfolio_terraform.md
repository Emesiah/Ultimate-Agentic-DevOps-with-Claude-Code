---
name: pattern-recurring-gaps-portfolio-terraform
description: Recurring security gaps found in the portfolio-site terraform/ S3+CloudFront stack, to check first on re-audit
metadata:
  type: project
---

On the 2026-07-14 audit of `terraform/{backend,main,outputs,providers,variables}.tf`, the S3 public-access-block, bucket-policy scoping (via aws:SourceArn condition), and OAC-vs-OAI choices were all correctly implemented — these are not recurring problems and don't need repeated deep scrutiny unless the resource blocks change shape.

The recurring gaps (check these first on re-audit, since they're likely to persist until explicitly fixed):
1. No `aws_cloudfront_response_headers_policy` attached to `default_cache_behavior` — no CSP/X-Frame-Options/HSTS/X-Content-Type-Options/Referrer-Policy on the distribution.
2. No `logging_config` block on `aws_cloudfront_distribution.site` — no access logging.
3. No `aws_s3_bucket_versioning`, no `aws_s3_bucket_server_side_encryption_configuration`, no `aws_s3_bucket_logging` on `aws_s3_bucket.site`.
4. `viewer_certificate { cloudfront_default_certificate = true }` is hardcoded even though `var.domain_name` can be set to a custom alias — if `domain_name` is ever populated, this is an invalid/insecure combination (CloudFront requires an ACM cert + `minimum_protocol_version`/`ssl_support_method` for custom aliases, not the default cert). Worth flagging as HIGH whenever `domain_name` support exists without a matching ACM cert resource.

**Why:** these are the same static-site stack pattern (S3 + CloudFront + OAC, no app logic) — the core access-control wiring tends to be done right, but the "defense in depth" layers (headers, logging, encryption-at-rest declarations, versioning) are consistently the omitted parts.

**How to apply:** on future audits of this same `terraform/` directory, verify quickly whether these four gaps have been closed before doing a full line-by-line re-read; if unchanged, the findings below can be reused nearly verbatim.
