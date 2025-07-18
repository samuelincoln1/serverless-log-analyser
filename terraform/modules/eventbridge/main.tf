resource "aws_cloudwatch_event_rule" "every_12_hours" {
  name        = var.eventbridge_name
  description = var.eventbridge_description
  schedule_expression = var.eventbridge_schedule_expression
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_12_hours.name
  target_id = "logAggregator"
  arn       = var.lambda_function_arn

  input = jsonencode({
    account_id = var.account_id
  })
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_12_hours.arn
}