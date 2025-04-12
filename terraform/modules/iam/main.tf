resource "aws_iam_role" "lambda_exec_role" {
    name = var.lambda_exec_role_name

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
               
            }
        ]
    })
}

resource "aws_iam_role_policy" "lambda_exec_policy" {
    name = var.lambda_exec_policy_name
    role = aws_iam_role.lambda_exec_role.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            { 
                Action = [
                    "s3:GetObject",
                    "s3:ListBucket",
                    "s3:PutObject",
                    "s3:PutObjectAcl"
                ]
                Effect = "Allow"
                Resource = [
                    var.s3_input_bucket_arn,
                    var.s3_output_bucket_arn,
                    "${var.s3_input_bucket_arn}/*",
                    "${var.s3_output_bucket_arn}/*"
                ]
                
            }, 
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Effect = "Allow"
                Resource = "*"
            }
        ]
    })
}


