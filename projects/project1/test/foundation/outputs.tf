output "bucket_arn" {
  value = module.build_raw_data_bucket.bucket_arn
}

output "bucket_id" {
  value = module.build_raw_data_bucket.bucket_id
}

output "lambda_role_arn" {
  value = module.lambda_execution_role.role_arn
}
