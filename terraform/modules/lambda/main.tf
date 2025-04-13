resource "aws_lambda_function" "log_processor" {
  function_name = var.lambda_function_name
  role          = var.lambda_exec_role_arn
  handler       = var.lambda_function_handler
  runtime       = "python3.11"
  filename         = "${path.module}/../../../lambda-analyzer.zip"
  source_code_hash = filebase64sha256("${path.module}/../../../lambda-analyzer.zip")
  timeout = 30

  environment {
    variables = {
      BUCKET_NAME = var.s3_input_bucket_name
    }
  }

  tags = {
    Project = "log-processor"
  }
}

resource "aws_s3_bucket_notification" "log_upload_notification" {
  bucket = var.s3_input_bucket_bucket

  lambda_function {
    events = ["s3:ObjectCreated:*"]
    lambda_function_arn = aws_lambda_function.log_processor.arn
  }

  depends_on = [aws_lambda_permission.allow_s3_trigger]
}

resource "aws_lambda_permission" "allow_s3_trigger" {
  statement_id = "AllowExecutionFromS3"
  action = "lambda:InvokeFunction"
  principal = "s3.amazonaws.com"
  function_name = aws_lambda_function.log_processor.function_name
  source_arn = var.s3_input_bucket_arn
}

resource "aws_lambda_function" "log_aggregator" {
  function_name = var.lambda_function_name_aggregator
  role          = var.lambda_exec_role_arn
  handler       = var.lambda_function_handler_aggregator
  runtime       = "python3.11"
  filename         = "${path.module}/../../../lambda-aggregator.zip"
  source_code_hash = filebase64sha256("${path.module}/../../../lambda-aggregator.zip")
  timeout = 30

  environment {
    variables = {
      BUCKET_NAME = var.s3_input_bucket_name
    }
  }

  tags = {
    Project = "log-aggregator"
  }
}





