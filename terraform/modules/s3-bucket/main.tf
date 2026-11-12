resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  # Protect against accidental removal of objects. This is *not* a substitute
  # for backups, and it does not prevent bucket deletion when empty.
  force_destroy = false
}

# Optional exercise; default false avoids introducing extra resources during
# the first move into modules. Can be enabled after confirming the migration.
resource "aws_s3_bucket_versioning" "this" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}
