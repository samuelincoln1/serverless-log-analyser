import boto3
import gzip
import json
from datetime import datetime
from io import BytesIO

s3 = boto3.client('s3')

def lambda_handler(event, context):
    print("aggregator called")
    bucket_name = 'samuellincoln-log-analyzer-input'
    
    # Calculate current date
    current_date = datetime.utcnow()
    year = current_date.strftime("%Y")
    month = current_date.strftime("%m")
    day = current_date.strftime("%d")
    
    
    # Create dynamic prefix
    prefix = f'AWSLogs/{event["account_id"]}/CloudTrail/us-east-1/{year}/{month}/{day}/'
    print(f"dynamic prefix: {prefix}")
    
    aggregated_data = []

    # List objects in bucket with specified prefix
    response = s3.list_objects_v2(Bucket=bucket_name, Prefix=prefix)
    print(f"list_objects_v2 response: {response.get('Contents', [])}")
    for obj in response.get('Contents', []):
        print(f"analyzing object: {obj}")
        key = obj['Key']
        print(f"analyzing key: {key}")
        if key.endswith('.json.gz') and 'aggregated' not in key:
            # Read and decompress file
            obj_data = s3.get_object(Bucket=bucket_name, Key=key)
            with gzip.GzipFile(fileobj=BytesIO(obj_data['Body'].read())) as gz:
                log_content = json.load(gz)
                aggregated_data.extend(log_content['Records'])

    # Get current date and time to name the file
    now = datetime.utcnow()
    output_key = f"{now.strftime('%Y-%m-%d-%H:%M')}-aggregated.json.gz"
    print(f"will save to bucket with path: {prefix}{output_key}")

    # Compress and write aggregated file
    out_buffer = BytesIO()
    with gzip.GzipFile(fileobj=out_buffer, mode='w') as gz:
        gz.write(json.dumps({'Records': aggregated_data}).encode('utf-8'))

    # Save aggregated file to S3
    s3.put_object(Bucket=bucket_name, Key=f"{prefix}{output_key}", Body=out_buffer.getvalue())
    
    # Delete old log files
    for obj in response.get('Contents', []):
        key = obj['Key']
        print(f"will delete file: {key}")
        if key.endswith('.json.gz') and 'aggregated' not in key:
            s3.delete_object(Bucket=bucket_name, Key=key)

    print("Logs aggregated and old logs deleted successfully")
    return {
        'statusCode': 200,
        'body': json.dumps('Logs aggregated and old logs deleted successfully')
    }