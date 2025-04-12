data "aws_caller_identity" "current" {}

terraform {
    backend "s3" {
        bucket = "samuellincoln-serverless-log-analyzer-state"
        key = "terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "serverless-log-analyzer-locks"
        encrypt = true
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

module "s3" {
    source = "./modules/s3"
    s3_input_bucket_name = "samuellincoln-log-analyzer-input"
    s3_output_bucket_name = "samuellincoln-log-analyzer-output"
    s3_input_bucket_tag = "log-analyzer-input"
    s3_output_bucket_tag = "log-analyzer-output"
}

module "iam" {
    source = "./modules/iam"
    lambda_exec_role_name = "log-analyzer-role"
    lambda_exec_policy_name = "log-analyzer-policy"
    s3_input_bucket_arn = module.s3.s3_input_bucket_arn
    s3_output_bucket_arn = module.s3.s3_output_bucket_arn
}

module "lambda" {
    source = "./modules/lambda"
    lambda_function_name = "log-analyzer-function"
    lambda_function_handler = "handler.lambda_handler"
    lambda_exec_role_arn = module.iam.lambda_exec_role_arn
    s3_input_bucket_name = module.s3.s3_input_bucket_name
    s3_input_bucket_arn = module.s3.s3_input_bucket_arn
    s3_input_bucket_bucket = module.s3.s3_input_bucket_bucket
}   

module "cloudtrail" {
    source = "./modules/cloudtrail"
    cloudtrail_name = "log-analyzer-cloudtrail"
    s3_input_bucket_name = module.s3.s3_input_bucket_name
    s3_input_bucket_arn = module.s3.s3_input_bucket_arn
    s3_input_bucket_bucket = module.s3.s3_input_bucket_bucket
    is_multi_region_trail = true
    include_global_service_events = true
    enable_logging = true
    include_management_events = true
    read_write_type = "All"
    data_resource_type = "AWS::S3::Object"
    data_resource_values = ["arn:aws:s3:::${module.s3.s3_input_bucket_arn}/*"]
    account_id = data.aws_caller_identity.current.account_id    
   
}

