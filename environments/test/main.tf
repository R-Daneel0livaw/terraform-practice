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