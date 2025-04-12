output "s3_input_bucket_name" {
    value = aws_s3_bucket.serverless_log_analyzer_bucket.bucket
}

output "s3_output_bucket_name" {
    value = aws_s3_bucket.serverless_log_analyzer_output.bucket
}

output "s3_input_bucket_arn" {
    value = aws_s3_bucket.serverless_log_analyzer_bucket.arn
}

output "s3_output_bucket_arn" {
    value = aws_s3_bucket.serverless_log_analyzer_output.arn
}

output "s3_input_bucket_bucket" {
    value = aws_s3_bucket.serverless_log_analyzer_bucket.bucket
}
