import json
from collections import Counter, defaultdict

def process_logs(filepath):
    with open(filepath, "r") as file:
        logs = json.load(file)
        
    event_counter = Counter()
    resource_counter = Counter()
    account_counter = Counter()
    region_counter = Counter()
    source_ip_counter = Counter()
    event_type_counter = Counter()
    event_category_counter = Counter()
    
    for record in logs["Records"]:
        event_name = record["eventName"]
        event_counter[event_name] += 1
        
        for resource in record.get("resources", []): 
            resource_name = resource.get("type") 
            resource_counter[resource_name] += 1
            
        region = record.get("awsRegion", None)
        if region:
            region_counter[region] += 1
            
        source_ip = record.get("sourceIPAddress", None)
        if source_ip:
            source_ip_counter[source_ip] += 1
            
        event_type = record.get("eventType", None)
        if event_type:
            event_type_counter[event_type] += 1
            
        event_category = record.get("eventCategory", None)
        if event_category:
            event_category_counter[event_category] += 1
    
        account_type = record["userIdentity"]["type"] 
        account_counter[account_type] += 1
                   
    return {
        "event_counts": dict(event_counter),      
        "resource_counts": dict(resource_counter),
        "account_counts": dict(account_counter),       
        "region_counts": dict(region_counter),       
        "source_ip_counts": dict(source_ip_counter),        
        "event_type_counts": dict(event_type_counter),
        "event_category_counts": dict(event_category_counter),
        "total_events": len(logs["Records"]),
    }
    