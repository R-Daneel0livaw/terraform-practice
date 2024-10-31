resource "aws_iam_role_policy" "custom_policy" {
  role = var.role_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = var.policy_statements
  })
}
