variable "bucket" {
  type = object({
    id  = string
    arn = string
  })
  description = "Object containing the ID and ARN of the S3 bucket to trigger the Lambda function."
  default = {
    id  = null
    arn = null
  }
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue to trigger the Lambda function"
  type        = string
  default     = null
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
