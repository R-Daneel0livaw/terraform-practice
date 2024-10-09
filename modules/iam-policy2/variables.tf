variable "role_name" {
  type        = string
  description = "The name of the IAM role to which the policy should be attached"
}

variable "policy_name" {
  type        = string
  description = "Name of the policy"
}

variable "policy_document" {
  type        = string
  description = "The JSON policy document"
}

variable "managed_policy_arns" {
  type        = list(string)
  default     = []
  description = "List of managed policy ARNs to attach to the role"
}