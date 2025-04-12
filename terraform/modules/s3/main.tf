resource "aws_s3_bucket" "serverless_log_analyzer_bucket" {
    bucket = var.s3_input_bucket_name
    force_destroy = true

    tags = {
        Name = var.s3_input_bucket_tag
    }
}

resource "aws_s3_bucket_versioning" "serverless_log_analyzer_bucket_versioning" {
    bucket = aws_s3_bucket.serverless_log_analyzer_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "serverless_log_analyzer_bucket_encryption" {
  bucket = aws_s3_bucket.serverless_log_analyzer_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "serverless_log_analyzer_bucket_block" {
  bucket = aws_s3_bucket.serverless_log_analyzer_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "serverless_log_analyzer_output" {
    bucket = var.s3_output_bucket_name
    force_destroy = true

    tags = {
        Name = var.s3_output_bucket_tag
    }
}

resource "aws_s3_bucket_versioning" "serverless_log_analyzer_output_versioning" {
    bucket = aws_s3_bucket.serverless_log_analyzer_output.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "serverless_log_analyzer_output_encryption" {
  bucket = aws_s3_bucket.serverless_log_analyzer_output.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "serverless_log_analyzer_output_block" {
  bucket = aws_s3_bucket.serverless_log_analyzer_output.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}