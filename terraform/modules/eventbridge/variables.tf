variable "eventbridge_name" {
    type = string
    description = "The name of the EventBridge rule"
}


variable "eventbridge_description" {
    type = string
    description = "The description of the EventBridge rule"
}


variable "eventbridge_schedule_expression" {
    type = string
    description = "The schedule expression of the EventBridge rule"
}


variable "lambda_function_arn" {
    type = string
    description = "The ARN of the Lambda function"
}


variable "lambda_function_name" {
    type = string
    description = "The name of the Lambda function"
}


