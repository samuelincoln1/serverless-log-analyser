import boto3
import gzip
import json
from datetime import datetime
from io import BytesIO

s3 = boto3.client('s3')

def lambda_handler(event, context):
    print("aggregator called")
    bucket_name = 'samuellincoln-log-analyzer-input'
    
    # Supondo que o evento contenha as informações necessárias
    account_id = event['account_id']
    year = event['year']
    month = event['month']
    day = event['day']
    
    # Criar o prefixo dinâmico
    prefix = f'AWSLogs/{account_id}/CloudTrail/us-east-1/{year}/{month}/{day}/'
    print(f"prefix dinamico: {prefix}")
    
    aggregated_data = []

    # Listar objetos no bucket com o prefixo especificado
    response = s3.list_objects_v2(Bucket=bucket_name, Prefix=prefix)
    print(f"resposta do list_objects_v2: {response['Contents']}")
    for obj in response.get('Contents', []):
        print(f"objeto sendo analisado: {obj}")
        key = obj['Key']
        print(f"Key sendo analisada: {key}")
        if key.endswith('.json.gz') and 'aggregated' not in key:
            # Ler e descompactar o arquivo
            obj_data = s3.get_object(Bucket=bucket_name, Key=key)
            with gzip.GzipFile(fileobj=BytesIO(obj_data['Body'].read())) as gz:
                log_content = json.load(gz)
                aggregated_data.extend(log_content['Records'])

    # Obter a data e hora atual para nomear o arquivo
    now = datetime.utcnow()
    output_key = f"{now.strftime('%Y-%m-%d-%H:%M')}-aggregated.json.gz"
    print(f"vai salvar no bucket com o caminho: {prefix}{output_key}")

    # Compactar e escrever o arquivo agregado
    out_buffer = BytesIO()
    with gzip.GzipFile(fileobj=out_buffer, mode='w') as gz:
        gz.write(json.dumps({'Records': aggregated_data}).encode('utf-8'))

    # Salvar o arquivo agregado no S3
    s3.put_object(Bucket=bucket_name, Key=f"{prefix}{output_key}", Body=out_buffer.getvalue())
    

    # Deletar arquivos antigos de logs
    for obj in response.get('Contents', []):
        key = obj['Key']
        print(f"vai deletar o arquivo: {key}")
        if key.endswith('.json.gz') and 'aggregated' not in key:
            s3.delete_object(Bucket=bucket_name, Key=key)

    print("Logs aggregated and old logs deleted successfully")
    return {
        'statusCode': 200,
        'body': json.dumps('Logs aggregated and old logs deleted successfully')
    }