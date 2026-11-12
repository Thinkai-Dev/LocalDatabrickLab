# Archived Terraform review questions — resume later

Status: **Paused at user request**, November 2026.

## Unanswered dependency question

```hcl
resource "aws_s3_bucket" "raw" {
  bucket = "retail-lab-raw"
}

resource "aws_s3_bucket_versioning" "raw_versioning" {
  bucket = aws_s3_bucket.raw.id
  versioning_configuration { status = "Enabled" }
}
```

1. Why does Terraform create the bucket before enabling versioning?
2. Is an explicit `depends_on` necessary? Under what circumstances might one be useful?

## Earlier completed scenarios for review

- Drift: a managed bucket is deleted manually; what happens at plan/apply?
- Unmanaged resources: a fourth bucket exists outside state/configuration.
- Missing state: buckets remain but `.tfstate` is lost.
- Removed configuration: a tracked bucket block disappears.
- `prevent_destroy`: destroy planning behavior and protection limits.
- `-target`: targeted destroy and why it's exceptional.

## Phase 2 review questions (defer answers until requested)

- Why use `moved` blocks when putting existing resources into a module?
- What happens if you change the bucket prefix after migration?
- What are the boundaries of S3 `force_destroy = false`?
- How do implicit dependencies arise from resource references?
- What is the difference between a Terraform root module and a child module?
- Why did we need moved.tf even though the S3 bucket names did not change?
- What would happen if you changed bucket_prefix from retail-lab to retail-prod?
- Why does a reference such as aws_s3_bucket.this.id create an implicit dependency?
