locals {
  lambda_arns = { for name, lambda in aws_lambda_function.lambda : name => lambda.arn }
}

data "archive_file" "lambda_zip" {
  for_each = { for lambda in var.lambda_functions : lambda.name => lambda }

  type        = "zip"
  source_file = "${path.module}/lambda_code/${each.value.code_file}"
  output_path = "${path.module}/${each.value.name}.zip"
}

resource "aws_lambda_function" "lambda" {
  for_each = { for lambda in var.lambda_functions : lambda.name => lambda }

  function_name = each.value.name
  role          = each.value.role_arn
  handler       = each.value.handler
  runtime       = each.value.runtime
  filename      = data.archive_file.lambda_zip[each.key].output_path

  environment {
    variables = lookup(each.value, "environment", {})
  }
}

resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  bucket = var.bucket_id

  dynamic "lambda_function" {
    for_each = var.lambda_functions
    content {
      lambda_function_arn = local.lambda_arns[lambda_function.value.name]
      events              = ["s3:ObjectCreated:*"]
      filter_prefix       = lookup(lambda_function.value, "trigger_loc", null) != null ? "${lookup(lambda_function.value, "trigger_loc", "")}/" : null
    }
  }
}

resource "aws_lambda_permission" "allow_s3_invocation" {
  for_each = aws_lambda_function.lambda

  statement_id  = "AllowS3Invoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_arn
}