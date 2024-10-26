output "bucket_info" {
  description = "An object containing the bucket name, id, and arn"
  value = {
    bucket = module.build_raw_data_bucket.bucket
    id     = module.build_raw_data_bucket.bucket_id
    arn    = module.build_raw_data_bucket.bucket_arn
  }
}

output "lambda_role_arn" {
  value = module.lambda_execution_role.role_arn
}
