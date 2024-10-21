output "bucket_arn" {
  value = module.build_raw_data_bucket.bucket_arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}