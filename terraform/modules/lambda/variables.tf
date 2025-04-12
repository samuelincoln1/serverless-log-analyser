variable "lambda_function_name" {
    type = string
    description = "The name of the Lambda function"
}

variable "lambda_function_handler" {
    type = string
    description = "The handler of the Lambda function"
}

variable "lambda_exec_role_arn" {
    type = string
    description = "The ARN of the IAM role for the Lambda function"
}


variable "s3_input_bucket_arn" {
    type = string
    description = "The ARN of the S3 bucket for input logs"
}

variable "s3_input_bucket_name" {
    type = string
    description = "The name of the S3 bucket for input logs"
}

variable "s3_input_bucket_bucket" {
    type = string
    description = "The bucket of the S3 bucket for input logs"
}

