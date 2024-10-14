provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}

resource "aws_s3_bucket" "foundation_bucket" {
  bucket = "my-foundation-bucket"
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