data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.source_file_path
  output_path = "${path.module}/${var.function_name}.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  filename      = data.archive_file.lambda_zip.output_path

  environment {
    variables = var.environment_variables
  }
}