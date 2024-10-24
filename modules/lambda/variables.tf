variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role to assign to the Lambda function"
  type        = string
}

variable "source_file_path" {
  description = "Path to the Lambda function source file"
  type        = string
}

variable "handler" {
  description = "The Lambda function handler (entry point)"
  type        = string
}

variable "runtime" {
  description = "The runtime for the Lambda function"
  type        = string
}

variable "environment_variables" {
  description = "Key-value pairs of environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}
