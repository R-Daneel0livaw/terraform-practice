resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_lambda_function" "lambda" {
  for_each      = { for lambda in var.lambda_functions : lambda.name => lambda }

  function_name = each.value.name
  role          = each.value.role_arn  
  handler       = each.value.handler
  runtime       = each.value.runtime
  filename      = data.archive_file.lambda_zip[each.value.name].output_path

  environment {
    variables = each.value.environment
  }
}

resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  dynamic "lambda_function" {
    for_each = aws_lambda_function.lambda
    content {
      lambda_function_arn = each.value.arn
      events              = ["s3:ObjectCreated:*"]
    }
  }
}

resource "aws_lambda_permission" "allow_s3_invocation" {
  for_each = aws_lambda_function.lambda
  
  statement_id  = "AllowS3Invoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}

data "archive_file" "lambda_zip" {
  for_each    = { for lambda in var.lambda_functions : lambda.name => lambda }
  
  type        = "zip"
  source_file = each.value.code_path
  output_path = "${path.module}/${each.value.name}.zip"
}