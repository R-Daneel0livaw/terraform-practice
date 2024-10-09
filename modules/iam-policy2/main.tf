resource "aws_iam_role_policy" "inline_policy" {
  name   = var.policy_name
  role   = var.role_name
  policy = var.policy_document
}

# Optionally, attach managed policies to the role
resource "aws_iam_role_policy_attachment" "managed_policy_attachments" {
  for_each  = toset(var.managed_policy_arns)
  role      = var.role_name
  policy_arn = each.value
}