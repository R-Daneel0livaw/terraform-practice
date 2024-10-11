provider "aws" {
  region = "us-west-2"
}

module "constants" {
  source = "../../modules/global-constants"
}

module "sqs_queue" {
  source     = "../../modules/sqs"
  queue_name = "waiting"
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${module.constants.bucket_name}",
      "arn:aws:s3:::${module.constants.bucket_name}/*"
    ]
  }

  statement {
    actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }

  # statement {
  #   actions = ["sqs:SendMessage"]
  #   resources = [
  #     module.sqs_queue.queue_arn
  #   ]
  # }
}

module "iam_role" {
  source             = "../../modules/iam-role"
  role_name          = "lambda-execution-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

module "s3_access_policy" {
  source          = "../../modules/iam-policy2"
  role_name       = module.iam_role.role_name
  policy_name     = "s3-lambda-sqs-access-policy"
  policy_document = data.aws_iam_policy_document.s3_access_policy.json
}










# module "lambda_s3_role_policy" {
#   source                = "../../modules/iam-policy"
#   role_name             = "lambda-s3-role"
#   policy_name           = "lambda-s3-policy"
#   description           = "Policy for Lambda to access S3 and CloudWatch"
#   assume_role_principal = "lambda.amazonaws.com"

#   statements = [
#     {
#       "Action" : ["s3:GetObject", "s3:ListBucket"],
#       "Effect" : "Allow",
#       "Resource" : [
#         "arn:aws:s3:::${module.constants.bucket_name}",
#         "arn:aws:s3:::${module.constants.bucket_name}/*"
#       ]
#     },
#     {
#       "Action" : [
#         "sqs:SendMessage"
#       ],
#       "Effect" : "Allow",
#       "Resource" : [
#         aws_sqs_queue.waiting_queue.arn
#       ]
#     },
#     {
#       "Action" : ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
#       "Effect" : "Allow",
#       "Resource" : [
#         "arn:aws:logs:*:*:*"
#       ]
#     }
#   ]
# }

# module "build_raw_data" {
#   source      = "../../modules/s3-lambda"
#   bucket_name = module.constants.bucket_name
#   directories = ["inbound", "waiting", "completed", "archived"]
#   lambda_functions = [
#     {
#       name        = "bucket1-lambda1"
#       handler     = "bucket1_lambda1.lambda_handler"
#       code_file   = "bucket1_lambda1.py"
#       trigger_loc = "inbound"
#       environment = { BUCKET_NAME = module.constants.bucket_name }
#       runtime     = "python3.9"
#       role_arn    = module.lambda_s3_role_policy.role_arn
#     },
#   ]
# }