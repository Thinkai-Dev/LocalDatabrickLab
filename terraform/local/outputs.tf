output "bucket_names" {
  description = "Emulated S3 buckets (compatible with Phase 1 output)"
  value       = sort([for b in module.retail_buckets : b.bucket_name])
}

output "bucket_arns" {
  description = "ARNs of local emulated buckets"
  value       = { for k, b in module.retail_buckets : k => b.bucket_arn }
}
