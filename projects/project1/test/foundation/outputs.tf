output "bucket_info" {
  description = "An object containing the bucket name, id, and arn"
  value = {
    bucket = module.build_raw_data_bucket.bucket_name
    id     = module.build_raw_data_bucket.bucket_id
    arn    = module.build_raw_data_bucket.bucket_arn
  }
}

output "lambda_role_arn" {
  value = module.lambda_execution_role.role_arn
}

output "sqs_queue_arns" {
  description = "ARNs of the SQS queues"
  value = {
    waiting = module.waiting_sqs_queue.queue_arn
    completed = module.completed_sqs_queue.queue_arn
  }
}
