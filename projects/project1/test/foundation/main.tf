provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}

module "constants" {
  source = "../../../../modules/global-constants"
}

module "sqs_queue" {
  source     = "../../../../modules/sqs"
  queue_name = "waiting"
}

module "build_raw_data_bucket" {
  source      = "../../../../modules/s3"
  bucket_name = module.constants.bucket_name
  directories = ["inbound", "waiting", "completed", "archived"]
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}