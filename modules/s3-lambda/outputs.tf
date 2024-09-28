output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

output "lambda_arn" {
  value = aws_lambda_function.lambda.arn
}