
variable "s3_input_bucket_name" {
    type = string
    description = "The name of the S3 bucket for input logs"
}   

variable "s3_output_bucket_name" {
    type = string
    description = "The name of the S3 bucket for output logs"
}

variable "s3_input_bucket_tag" {
    type = string
    description = "The tag of the S3 bucket for input logs"
}

variable "s3_output_bucket_tag" {
    type = string
    description = "The tag of the S3 bucket for output logs"
}


