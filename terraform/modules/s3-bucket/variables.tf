variable "bucket_name" {
  type        = string
  description = "Complete S3 bucket name"

  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name))
    error_message = "The bucket name must be 3-63 characters using lowercase letters, digits, hyphens, or periods."
  }
}

variable "enable_versioning" {
  type        = bool
  description = "Configure S3 versioning in this bucket"
  default     = false
}
