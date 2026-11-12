# Phase 1 -> Phase 2 state migration. Keep these in source control.
# Terraform updates addresses without deleting the already-provisioned buckets.
moved {
  from = aws_s3_bucket.retail["raw"]
  to   = module.retail_buckets["raw"].aws_s3_bucket.this
}

moved {
  from = aws_s3_bucket.retail["processed"]
  to   = module.retail_buckets["processed"].aws_s3_bucket.this
}

moved {
  from = aws_s3_bucket.retail["analytics"]
  to   = module.retail_buckets["analytics"].aws_s3_bucket.this
}
