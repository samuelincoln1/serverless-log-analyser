output "lambda_function_aggregator_arn" {
    value = aws_lambda_function.log_aggregator.arn
}

output "lambda_function_aggregator_name" {
    value = aws_lambda_function.log_aggregator.function_name
}