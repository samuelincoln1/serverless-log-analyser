import boto3
import json
import gzip
import os
from urllib.parse import unquote

from exporter import export_to_json, export_to_csv
from analyzer import process_logs
s3 = boto3.client("s3")

def lambda_handler(event, context):
    bucket_name = event["Records"][0]["s3"]["bucket"]["name"]
    print(f"[+] Bucket name: {bucket_name}")
    key = event["Records"][0]["s3"]["object"]["key"]
    print(f"[+] Key: {key}")
    

    key = unquote(key)
    
  
    base_filename = os.path.splitext(key.split('/')[-1])[0]
    
    local_gz_path = f"/tmp/{key.split('/')[-1]}"
    print(f"[+] Local gz path: {local_gz_path}")
    
    print(f"[+] Downloading file from s3")
    s3.download_file(bucket_name, key, local_gz_path)
    print(f"[+] File downloaded from s3")
    
    local_json_path = local_gz_path.replace('.gz', '')
    print(f"[+] Local json path: {local_json_path}")
    
    print(f"[+] Unzipping file")
    with gzip.open(local_gz_path, 'rt') as gz_file:
        with open(local_json_path, 'w') as json_file:
            json_file.write(gz_file.read())
    print(f"[+] File unzipped")
    if os.path.exists(local_json_path):
        print(f"[+] JSON file created at {local_json_path}")
    else:
        print(f"[-] JSON file not found at {local_json_path}")
    
    if "aggregated" in base_filename:
        insights = process_logs(local_json_path)
        
        base_filename = base_filename.replace('-aggregated.json', '')
        json_path = f"{local_json_path.rsplit('/', 1)[0]}/{base_filename}-insights.json"
        csv_path = f"{local_json_path.rsplit('/', 1)[0]}/{base_filename}-insights.csv"
      
        export_to_json(insights, json_path)
        export_to_csv(insights, csv_path)
        
        directory = '/'.join(key.split('/')[:-1])
        
        new_key_json = f"{directory}/{base_filename}-insights.json"
        new_key_csv = f"{directory}/{base_filename}-insights.csv"

        print(f"[+] Uploading insights to output s3 in path {new_key_json} and {new_key_csv}")
        s3.upload_file(json_path, "samuellincoln-log-analyzer-output", new_key_json)
        s3.upload_file(csv_path, "samuellincoln-log-analyzer-output", new_key_csv)
        print(f"[+] Insights uploaded to s3")
    else:
        print(f"[-] File {base_filename} does not contain 'aggregated', skipping processing.")
    
    
   
