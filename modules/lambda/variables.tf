variable "bucket_id" {
  type        = string
  description = "The id of the S3 bucket."
}

variable "bucket_arn" {
  type        = string
  description = "The arn of the S3 bucket."
}

variable "lambda_functions" {
  type = list(object({
    function_name    = string
    handler          = string
    source_file_path = string
    trigger_loc      = optional(string)
    environment      = optional(map(string))
    runtime          = string
    role_arn         = string
  }))
  description = "The Lambda functions to attach."
}
