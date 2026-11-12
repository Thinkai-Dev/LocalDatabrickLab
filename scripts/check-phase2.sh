#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="$ROOT/terraform/local"
export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=us-east-1 AWS_EC2_METADATA_DISABLED=true
curl -fsS http://localhost:4566/_localstack/health >/dev/null
printf 'PASS LocalStack health\n'
for tier in raw processed analytics; do
  bucket="retail-lab-${tier}"
  aws --endpoint-url=http://localhost:4566 s3api head-bucket --bucket "$bucket" >/dev/null
  printf 'PASS S3 bucket %s\n' "$bucket"
done
cd "$TF_DIR"
terraform validate >/dev/null
printf 'PASS Terraform validate\n'
for tier in raw processed analytics; do
  address="module.retail_buckets[\"${tier}\"].aws_s3_bucket.this"
  terraform state show "$address" >/dev/null
  printf 'PASS Terraform state: %s\n' "$address"
done
printf 'PASS Phase 2 basic resource and state checks\n'
