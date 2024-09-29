variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
}

variable "description" {
  description = "The description of the IAM policy"
  type        = string
  default     = ""
}

variable "statements" {
  description = "List of IAM policy statements"
  type        = list(any)
}

variable "assume_role_principal" {
  description = "The AWS principal (service or account) that can assume the role"
  type        = string
}