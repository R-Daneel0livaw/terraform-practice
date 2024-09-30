provider "aws" {
  region = "us-west-2"
}

module "constants" {
  source = "../../modules/global-constants"
}

module "lambda_s3_role_policy" {
  source                = "../../modules/iam-policy"
  role_name             = "lambda-s3-role"
  policy_name           = "lambda-s3-policy"
  description           = "Policy for Lambda to access S3 and CloudWatch"
  assume_role_principal = "lambda.amazonaws.com"

  statements = [
    {
      "Action" : ["s3:GetObject", "s3:ListBucket"],
      "Effect" : "Allow",
      "Resource" : [
        "arn:aws:s3:::${module.constants.bucket_name}",
        "arn:aws:s3:::${module.constants.bucket_name}*"
      ]
    },
    {
      "Action" : ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
      "Effect" : "Allow",
      "Resource" : [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}

module "build-raw-data" {
  source      = "../../modules/s3-lambda"
  bucket_name = module.constants.bucket_name
  lambda_functions = [
    {
      name        = "bucket1-lambda1"
      handler     = "bucket1_lambda1.lambda_handler"
      code_file   = "bucket1_lambda1.py"
      environment = { BUCKET_NAME = module.constants.bucket_name }
      runtime     = "python3.9"
      role_arn    = module.lambda_s3_role_policy.role_arn
    },
  ]
}
