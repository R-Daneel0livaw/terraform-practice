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

data "terraform_remote_state" "compute" {
  backend = "local"
  config = {
    path = "../compute/terraform.tfstate"
  }
}

module "lambda_policy" {
  source = "../../../../modules/policy"

  role_arn = data.terraform_remote_state.foundation.outputs.lambda_role_arn
  policy_statements = [
    {
      actions   = ["s3:GetObject", "s3:ListBucket"]
      effect    = "Allow"
      resources = [
        data.terraform_remote_state.foundation.outputs.bucket_info.arn,
        "${data.terraform_remote_state.foundation.outputs.bucket_info.arn}/*"
      ]
    },
    {
      actions   = ["sqs:SendMessage"]
      effect    = "Allow"
      resources = [
        data.terraform_remote_state.foundation.outputs.sqs_queue_arns.waiting,
        data.terraform_remote_state.foundation.outputs.sqs_queue_arns.completed,
        
      ]
    },
    # {
    #   actions   = [
    #     "logs:CreateLogGroup",
    #     "logs:CreateLogStream",
    #     "logs:PutLogEvents"
    #   ]
    #   effect    = "Allow"
    #   resources = ["arn:aws:logs:*:*:*"]
    # }
  ]
}
