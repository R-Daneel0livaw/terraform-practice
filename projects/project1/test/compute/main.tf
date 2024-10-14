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

resource "aws_lambda_function" "lambda" {
  function_name = "my-lambda-function"
  s3_bucket     = data.terraform_remote_state.foundation.outputs.bucket_arn  
  role = data.terraform_remote_state.foundation.outputs.lambda_role_arn
}

# resource "aws_lambda_function" "my_lambda" {
#   function_name = "my-lambda-function"
#   s3_bucket     = data.terraform_remote_state.foundation.outputs.lambda_bucket_arn
#   s3_key        = "lambda-code.zip"
#   role          = data.terraform_remote_state.foundation.outputs.lambda_role_arn

#   handler = "index.handler"
#   runtime = "nodejs14.x"
# }

# resource "aws_iam_role_policy" "lambda_s3_policy" {
#   role = data.terraform_remote_state.foundation.outputs.lambda_role_arn

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = ["s3:GetObject"],
#         Effect = "Allow",
#         Resource = "${data.terraform_remote_state.foundation.outputs.lambda_bucket_arn}/*"
#       }
#     ]
#   })
# }