variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "directories" {
  description = "List of directories to create in the S3 bucket"
  type        = list(string)
  default     = []
}