---
name: project-portfolio-infra
description: Terraform layout and scope of the portfolio-site AWS infra (S3+CloudFront) — what exists and what doesn't
metadata:
  type: project
---

The `terraform/` directory (path: `Ultimate-Agentic-DevOps-with-Claude-Code/terraform/`) contains exactly 5 files: `backend.tf`, `main.tf`, `outputs.tf`, `providers.tf`, `variables.tf`. It provisions only an S3 bucket (CloudFront origin) + CloudFront distribution + OAC for a static HTML/CSS portfolio site (see project CLAUDE.md).

- **No IAM/OIDC resources exist anywhere in this repo** — no `aws_iam_role`, no GitHub OIDC provider, no CI deploy role. There is also no `.github/workflows/` directory. So IAM-least-privilege / OIDC-trust-policy checklist items are not applicable to this codebase as of 2026-07-14 — don't flag them as findings, instead note them as out-of-scope/informational (deployment pipeline, if any, is not defined in Terraform).
- `backend.tf` intentionally ships with the S3 remote-state backend block commented out, with inline comments describing a manual bootstrap sequence (apply with local state first, hand-create a separate tfstate bucket via AWS CLI, then uncomment + `terraform init -migrate-state`). This is a deliberate bootstrapping choice, not an oversight — flag it as a lower-severity finding (local state has no encryption/locking) rather than a critical miss, and note the tfstate bucket creation itself lives outside Terraform (manual CLI steps in comments), which is a drift risk worth mentioning.
- Root `.gitignore` (at repo root, not in `terraform/`) already excludes `*.tfstate` and `.terraform/`, so local state files are not committed — don't flag missing gitignore protection.
- `main.tf` resources as of last audit: `aws_s3_bucket.site`, `aws_s3_bucket_public_access_block.site` (fully locked down), `aws_s3_bucket_ownership_controls.site` (BucketOwnerEnforced), `aws_s3_bucket_policy.site` (scoped via `aws:SourceArn` condition to the CloudFront distribution ARN — good, no wildcards), `aws_cloudfront_origin_access_control.site` (OAC, not legacy OAI — good), `aws_cloudfront_distribution.site`.

See [[pattern-recurring-gaps-portfolio-terraform]] for the recurring findings pattern in this specific file set.
