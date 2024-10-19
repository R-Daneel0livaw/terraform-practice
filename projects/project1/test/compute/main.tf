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

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_code/bucket1_lambda1.py"
  output_path = "${path.module}/bucket1-lambda1.zip"
}
