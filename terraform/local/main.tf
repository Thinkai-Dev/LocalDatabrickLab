locals {
  bucket_purposes = toset(["raw", "processed", "analytics"])
}

module "retail_buckets" {
  for_each = local.bucket_purposes
  source   = "../modules/s3-bucket"

  bucket_name       = "${var.bucket_prefix}-${each.key}"
  enable_versioning = var.enable_versioning
}
