resource "aws_iam_role_policy" "inline_policy" {
  count  = var.policy_document != null ? 1 : 0
  name   = var.policy_name
  role   = var.role_name
  policy = var.policy_document
}

resource "aws_iam_role_policy_attachment" "managed_policy_attachments" {
  for_each   = toset(var.managed_policy_arns) # Using for_each to loop over each policy ARN
  role       = var.role_name
  policy_arn = each.value
}