# output "lambda_bucket_arn" {
#   value = aws_s3_bucket.bucket.arn
# }

# output "lambda_role_arn" {
#   value = aws_iam_role.role.arn
# }

output "bucket_arn" {
  value = aws_s3_bucket.foundation_bucket.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}