# AWS CloudTrail Serverless Log Analyzer

A comprehensive serverless solution for automated AWS CloudTrail log analysis that provides real-time insights into AWS account activities, security events, and resource utilization patterns. This project leverages AWS Lambda, S3, CloudTrail, and EventBridge to create an event-driven analytics pipeline that processes CloudTrail logs and generates actionable insights.

📖 **For complete documentation and implementation details, visit: samuellincoln.com/projects/serverless-logs-analyzer**

## 🏗️ Architecture Overview

The system implements a multi-stage processing pipeline:

1. **CloudTrail** captures AWS account activities across all regions
2. **S3 Input Bucket** receives and stores raw CloudTrail logs
3. **Lambda Aggregator** consolidates daily logs every 12 hours
4. **Lambda Analyzer** processes aggregated logs and generates insights
5. **S3 Output Bucket** stores processed insights in JSON/CSV formats

## ✨ Key Features

### 🔄 **Automated Log Processing**
- Real-time CloudTrail log ingestion and processing
- Event-driven architecture with S3 triggers
- Scheduled log aggregation every 12 hours
- Automatic cleanup of processed files

### 📊 **Comprehensive Analytics**
- **Event Analysis**: Tracks AWS API calls and service operations
- **Resource Monitoring**: Analyzes resource types and usage patterns
- **Geographic Insights**: Maps activities across AWS regions
- **Security Monitoring**: Identifies source IPs and access patterns
- **User Activity**: Categorizes actions by identity types (IAM users, roles, services)

### 🛡️ **Security & Compliance**
- Multi-region CloudTrail monitoring
- Encrypted storage with AES256
- IAM roles with least privilege principles
- Complete audit trail for all account activities

### 📈 **Data Export**
- Dual format output (JSON for programmatic access, CSV for analysis)
- Real-time insights into account usage and security events

## 🏛️ Infrastructure Components

### **Terraform Modules**
- **S3 Module**: Creates input/output buckets with encryption and versioning
- **IAM Module**: Manages permissions with least privilege access
- **Lambda Module**: Deploys processing functions with proper triggers
- **CloudTrail Module**: Configures multi-region audit logging
- **EventBridge Module**: Schedules automated log aggregation

### **Lambda Functions**
- **Aggregator**: Consolidates daily CloudTrail logs (Python 3.11)
- **Analyzer**: Processes aggregated logs and generates insights (Python 3.11)

## 📁 Project Structure

```
├── terraform/
│   ├── main.tf                     # Main infrastructure configuration
│   └── modules/
│       ├── s3/                     # S3 bucket configurations
│       ├── iam/                    # IAM roles and policies
│       ├── lambda/                 # Lambda function deployments
│       ├── cloudtrail/             # CloudTrail setup
│       └── eventbridge/            # Event scheduling
├── lambda-aggregator/
│   └── handler.py                  # Log consolidation function
├── lambda-analyzer/
│   ├── handler.py                  # Main processing orchestrator
│   ├── analyzer.py                 # Statistical analysis engine
│   └── exporter.py                 # Data export utilities
├── lambda-analyzer.zip             # Analyzer deployment package
├── lambda-aggregator.zip           # Aggregator deployment package
└── README.md
```

## 🚀 Getting Started

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- Python 3.11+
- AWS account with CloudTrail permissions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd log-analyser
   ```

2. **Configure Terraform backend** (optional)
   ```bash
   # Update terraform/main.tf with your S3 backend configuration
   ```

3. **Deploy infrastructure**
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

4. **Package Lambda functions** (if needed)
   ```bash
   # Lambda packages to build:
   cd lambda-aggregator && zip -r ../lambda-aggregator.zip .
   cd ../lambda-analyzer && zip -r ../lambda-analyzer.zip .
   ```

## 📊 Data Output Structure

### Insights JSON Format
```json
{
  "event_counts": {"AssumeRole": 43, "DescribeAlarms": 86, ...},
  "resource_counts": {"AWS::S3::Bucket": 105, "AWS::IAM::Role": 43, ...},
  "account_counts": {"IAMUser": 475, "Root": 271, "AssumedRole": 52, ...},
  "region_counts": {"us-east-1": 849, ...},
  "source_ip_counts": {"177.55.229.104": 679, "AWS Internal": 32, ...},
  "event_type_counts": {"AwsApiCall": 847, "AwsServiceEvent": 2},
  "event_category_counts": {"Management": 849},
  "total_events": 849
}
```

### CSV Format
Simplified format focusing on event names and frequencies for spreadsheet analysis.

## 🛠️ Technology Stack

- **Infrastructure**: AWS (S3, Lambda, CloudTrail, EventBridge, IAM)
- **IaC**: Terraform with modular architecture
- **Runtime**: Python 3.11
- **Data Processing**: boto3, gzip, json, collections
- **Monitoring**: CloudWatch Logs
- **Storage**: S3 with encryption and versioning

## 🔧 Configuration

### Key Settings
- **Aggregation Schedule**: Every 12 hours (configurable via cron expression)
- **Processing Region**: us-east-1 (configurable)
- **Log Retention**: Configurable via S3 lifecycle policies
- **Timeout**: 30 seconds per Lambda execution

## 🔒 Security Considerations

- All S3 buckets use AES256 encryption
- Public access completely blocked on all buckets
- IAM roles follow least privilege principles
- CloudTrail captures all management and data events
- Source ARN restrictions on Lambda permissions

## 📋 Monitoring & Troubleshooting

- CloudWatch Logs provide detailed execution logs
- S3 event notifications ensure reliable triggering
- Terraform state management for infrastructure consistency
- Built-in error handling and validation

## 🤝 Contributing

This project serves as a portfolio demonstration of AWS serverless architecture and infrastructure as code best practices. For questions or discussions about the implementation, feel free to reach out.

## 📄 License

Copyright © 2025 Samuel Lincoln. All rights reserved.


