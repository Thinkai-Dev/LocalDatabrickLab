variable "bucket_prefix" {
  description = "Prefix used for all three locally emulated S3 buckets. Keep default when migrating Phase 1 state."
  type        = string
  default     = "retail-lab"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_prefix)) && length(var.bucket_prefix) <= 48
    error_message = "Use lowercase letters, digits and hyphens; start/end with an alphanumeric character; max 48 characters."
  }
}

variable "enable_versioning" {
  description = "Optional lesson extension: add S3 versioning resources. Off for safe Phase 1 migration."
  type        = bool
  default     = false
}
