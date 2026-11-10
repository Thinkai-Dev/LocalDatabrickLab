#!/usr/bin/env bash
set -euo pipefail
export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=us-east-1 AWS_EC2_METADATA_DISABLED=true
printf 'LocalStack health:\n'
curl -fsS http://localhost:4566/_localstack/health
printf '\nS3 buckets:\n'
aws --endpoint-url=http://localhost:4566 s3 ls
