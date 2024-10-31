variable "role_arn" {
  description = "The ARN of the IAM role to attach the policy to."
  type = string
}

variable "policy_statements" {
  description = "List of policy statements with actions, effect, and resources."
  type = list(object({
    actions   = list(string)
    effect    = string
    resources = list(string)
  }))
}