output "bucket_names" {
  description = "Emulated S3 buckets"
  value       = sort([for b in aws_s3_bucket.retail : b.bucket])
}
