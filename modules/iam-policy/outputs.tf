output "role_arn" {
  description = "The ARN of the IAM Role"
  value       = aws_iam_role.iam_role.arn
}

output "role_name" {
  description = "The name of the IAM Role"
  value       = aws_iam_role.iam_role.name
}