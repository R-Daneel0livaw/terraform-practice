provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}

data "terraform_remote_state" "foundation" {
  backend = "local"
  config = {
    path = "../foundation/terraform.tfstate"
  }
}

data "terraform_remote_state" "compute" {
  backend = "local"
  config = {
    path = "../compute/terraform.tfstate"
  }
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  role = data.terraform_remote_state.foundation.outputs.lambda_role_arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:GetObject", "s3:ListBucket"]
        Effect = "Allow"
        Resource = [
          "${data.terraform_remote_state.foundation.outputs.bucket_arn}",
          "${data.terraform_remote_state.foundation.outputs.bucket_arn}/*"
        ]
      }
    ]
  })
}
