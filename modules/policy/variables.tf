variable "role_arn" {
  description = "The ARN of the IAM role to attach the policy to."
  type        = string
}

variable "bucket_arn" {
  description = "The ARN of the S3 bucket to which access should be granted."
  type        = string
}
