# S3 Serverless Log Analyzer

This project sets up an AWS infrastructure that includes an S3 bucket for storing AWS account logs obtained via CloudTrail. When a log file is uploaded to this bucket, it automatically triggers an AWS Lambda function, which processes the logs, extracting and analyzing the data to get insights about the usage of the AWS account. The processed data is then converted into JSON and CSV formats and stored in a designated output S3 bucket.

## Features
- **CloudTrail Logs**: Cloudtrail logs are automatically uploaded into the input S3 bucket.
- **Lambda Function**: The Lambda function is automatically triggered by new objects in the input S3 bucket.
- **Log Processing**: Analyzes and processes log files, and writes the insights into a new file in the output S3 bucket.

## Project Structure

- **lambda/handler.py**: The lambda function that is triggered by the S3 bucket.
- **lambda/exporter.py**: Handles exporting of logs to JSON and CSV formats.
- **terraform/**: Contains the Terraform code to create the Lambda function and the S3 bucket.

## License

Copyright © 2025 Samuel Lincoln. All rights reserved.


