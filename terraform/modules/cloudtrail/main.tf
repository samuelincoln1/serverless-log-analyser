resource "aws_cloudtrail" "cloudtrail" {
    name = var.cloudtrail_name
    s3_bucket_name = var.s3_input_bucket_bucket
    is_multi_region_trail = var.is_multi_region_trail
    include_global_service_events = var.include_global_service_events
    enable_logging = var.enable_logging

    event_selector {
        include_management_events = var.include_management_events
        read_write_type = var.read_write_type
        data_resource {
            type = var.data_resource_type
            values = var.data_resource_values
        }
    }
    depends_on = [aws_s3_bucket_policy.logs_input]
}

resource "aws_s3_bucket_policy" "logs_input" {
  bucket = var.s3_input_bucket_bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudTrailWrite",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action    = "s3:PutObject",
        Resource  = "${var.s3_input_bucket_arn}/AWSLogs/${var.account_id}/*", 
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid       = "AWSCloudTrailRead",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action    = "s3:GetBucketAcl",
        Resource  = "${var.s3_input_bucket_arn}"
      }
    ]
  })
}