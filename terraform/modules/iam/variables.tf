variable "lambda_exec_role_name" {
    type = string
    description = "The name of the IAM role for the Lambda function"
}

variable "lambda_exec_policy_name" {
    type = string
    description = "The name of the IAM policy for the Lambda function"
}

variable "s3_input_bucket_arn" {
    type = string
    description = "The ARN of the S3 bucket for input logs"
}       
    
variable "s3_output_bucket_arn" {
    type = string
    description = "The ARN of the S3 bucket for output logs"
}





