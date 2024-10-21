variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket."
}

variable "directories" {
  type        = list(string)
  description = "List of directories to create in the S3 bucket"
  default     = []
}