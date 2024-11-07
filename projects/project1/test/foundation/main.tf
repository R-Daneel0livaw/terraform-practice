provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}

module "constants" {
  source = "../global-constants"
}

module "waiting_sqs_queue" {
  source     = "../../../../modules/sqs"
  queue_name = "waiting"
}

module "completed_sqs_queue" {
  source     = "../../../../modules/sqs"
  queue_name = "completed"
}

module "build_raw_data_bucket" {
  source      = "../../../../modules/s3"
  bucket_name = module.constants.build_raw_data_bucket_name
  directories = module.constants.directories
}

module "lambda_execution_role" {
  source = "../../../../modules/iam-role"

  role_name = "lambda-execution-role"

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

  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
  }
}
