resource "aws_iam_role" "iam_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": var.assume_role_principal
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy" {
  name        = var.policy_name
  description = var.description
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": var.statements
  })
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}