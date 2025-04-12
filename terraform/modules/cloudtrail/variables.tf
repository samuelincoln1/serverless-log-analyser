variable "cloudtrail_name" {
    type = string
    description = "The name of the CloudTrail"
}

variable "s3_input_bucket_name" {
    type = string
    description = "The name of the S3 bucket"
}

variable "s3_input_bucket_arn" {
    type = string
    description = "The ARN of the S3 bucket"
}

variable "is_multi_region_trail" {
    type = bool
    description = "Whether the trail is multi-region"
}

variable "include_global_service_events" {
    type = bool 
    description = "Whether to include global service events"
}

variable "enable_logging" {
    type = bool
    description = "Whether logging is enabled"
}

variable "include_management_events" {
    type = bool
    description = "Whether to include management events"
}

variable "read_write_type" {
    type = string
    description = "The read/write type of the trail"
}

variable "data_resource_type" {
    type = string
    description = "The type of the data resource"
}

variable "data_resource_values" {
    type = list(string)
    description = "The values of the data resource"
}

variable "s3_input_bucket_bucket" {
    type = string
    description = "The bucket of the S3 bucket"
}

variable "account_id" {
    type = string
    description = "The account ID"
}


    







