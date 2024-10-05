variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket."
}

variable "directories" {
  type        = list(string)
  description = "List of directories to create in the S3 bucket"
  default     = []
}

variable "lambda_functions" {
  type = list(object({
    name        = string
    handler     = string
    code_file   = string
    trigger_loc = optional(string)
    environment = optional(map(string))
    runtime     = string
    role_arn    = string
  }))
  description = "The Lambda functions to attach."
}