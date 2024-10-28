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

module "lambda_s3_policy" {
  source     = "../../../../modules/policy"
  role_arn   = data.terraform_remote_state.foundation.outputs.lambda_role_arn
  bucket_arn = data.terraform_remote_state.foundation.outputs.bucket_arn
}
