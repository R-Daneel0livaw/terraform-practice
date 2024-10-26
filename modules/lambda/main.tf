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
  count  = var.bucket.id != null && var.bucket.arn != null ? 1 : 0
  bucket = var.bucket.id

  dynamic "lambda_function" {
    for_each = aws_lambda_function.lambda
    content {
      lambda_function_arn = lambda_function.value.arn
      events              = ["s3:ObjectCreated:*"]
      filter_prefix       = lookup(lambda_function.value, "trigger_loc", null) != null ? "${lookup(lambda_function.value, "trigger_loc", "")}/" : null
    }
  }
}

resource "aws_lambda_permission" "allow_s3_invocation" {
  count = var.bucket.id != null && var.bucket.arn != null ? length(aws_lambda_function.lambda) : 0

  statement_id  = "AllowS3Invoke-${aws_lambda_function.lambda[count.index].function_name}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[count.index].function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket.arn
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  count           = var.sqs_queue_arn != null ? length(aws_lambda_function.lambda) : 0

  event_source_arn = var.sqs_queue_arn
  function_name    = aws_lambda_function.lambda[count.index].arn
}