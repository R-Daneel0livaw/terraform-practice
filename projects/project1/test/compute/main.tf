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

module "constants" {
  source = "../../../../modules/global-constants"
}

resource "aws_lambda_function" "lambda" {
  function_name = "bucket1-lambda1"
  role          = data.terraform_remote_state.foundation.outputs.lambda_role_arn
  handler       = "bucket1_lambda1.lambda_handler"
  runtime       = "python3.9"
  filename      = data.archive_file.lambda_zip.output_path

  environment {
    variables = {
      BUCKET_NAME = module.constants.bucket_name
    }
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

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_code/bucket1_lambda1.py"
  output_path = "${path.module}/bucket1-lambda1.zip"
}
