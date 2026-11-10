locals {
  buckets = toset(["raw", "processed", "analytics"])
}
resource "aws_s3_bucket" "retail" {
  for_each = local.buckets
  bucket   = "retail-lab-${each.key}"
}
