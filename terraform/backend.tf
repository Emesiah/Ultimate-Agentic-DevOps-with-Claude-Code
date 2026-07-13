# -----------------------------------------------------------------------------
# Remote state backend (S3)
# -----------------------------------------------------------------------------
# The backend is COMMENTED OUT on purpose so the very first run works with a
# local state file. Bootstrapping order:
#
#   1. First run (local state):
#        terraform init
#        terraform apply
#      This creates the site bucket, CloudFront, etc.
#
#   2. Create a SEPARATE bucket to hold Terraform state (do NOT reuse the site
#      bucket). For example:
#        aws s3 mb s3://portfolio-site-tfstate --region ap-south-1
#        aws s3api put-bucket-versioning \
#          --bucket portfolio-site-tfstate \
#          --versioning-configuration Status=Enabled
#
#   3. Uncomment the block below, fill in the bucket name, then migrate:
#        terraform init -migrate-state
#      Terraform will copy your existing local state into S3.
# -----------------------------------------------------------------------------

# terraform {
#   backend "s3" {
#     bucket       = "portfolio-site-tfstate" # the state bucket from step 2
#     key          = "portfolio-site/terraform.tfstate"
#     region       = "ap-south-1"
#     encrypt      = true
#     use_lockfile = true # S3-native state locking (Terraform >= 1.10)
#   }
# }
