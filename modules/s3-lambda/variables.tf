variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket."
}

variable "lambda_functions" {
  type = list(object({
    name        = string
    handler     = string
    code_path   = string
    environment = map(string)
    runtime     = string
    role_arn    = string
  }))
}