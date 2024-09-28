provider "aws" {
  region = "us-west-2"
}

module "build-raw-data" {
  source            = "../../modules/s3-lambda"
  bucket_name       = "build-raw-data"
  lambda_functions  = [
    {
      name           = "bucket1-lambda1"
      handler        = "bucket1_lambda1.lambda_handler"
      code_path      = "${path.module}/lambda_code/bucket1_lambda1.py"
      environment    = { BUCKET_NAME = "build-raw-data" }
      runtime        = "python3.9"
      role_arn       = aws_iam_role.lambda_role1.arn 
    },
  ]
}

resource "aws_iam_role" "lambda_role1" {
  name = "lambda-s3-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "lambda-s3-policy"
  description = "Policy for Lambda to access S3 bucket and write logs"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::build-raw-data",
          "arn:aws:s3:::build-raw-data/*"
        ]
      },
      {
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_attach" {
  role       = aws_iam_role.lambda_role1.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}