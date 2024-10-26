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

module "lambda_function" {
  source = "../../../../modules/lambda"

  bucket = {
    id  = data.terraform_remote_state.foundation.outputs.bucket_info.id
    arn = data.terraform_remote_state.foundation.outputs.bucket_info.arn
  }

  lambda_functions = [
    {
      function_name    = "bucket1-lambda1"
      handler          = "bucket1_lambda1.lambda_handler"
      source_file_path = "bucket1_lambda1.py"
      trigger_loc      = "inbound"
      environment      = { BUCKET_NAME = module.constants.build_raw_data_bucket_name }
      runtime          = "python3.9"
      role_arn         = data.terraform_remote_state.foundation.outputs.lambda_role_arn
    },
  ]
}
