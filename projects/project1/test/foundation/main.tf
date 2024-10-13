provider "aws" {
  region = "us-west-2"
}

module "constants" {
  source = "../../../../modules/global-constants"
}

module "sqs_queue" {
  source     = "../../../../modules/sqs"
  queue_name = "waiting"
}