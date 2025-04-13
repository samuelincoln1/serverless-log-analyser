import json
from collections import Counter, defaultdict

def process_logs(filepath):
    with open(filepath, "r") as file:
        logs = json.load(file)
        
    event_counter = Counter()
    resource_counter = Counter()
    account_counter = Counter()
    
    for record in logs["Records"]:
        event_name = record["eventName"]
        event_counter[event_name] += 1
        
        for resource in record.get("resources", []):
            resource_name = resource.get("type", resource["ARN"])
            resource_counter[resource_name] += 1
            
        most_accessed_resource = resource_counter.most_common(1)
        most_used_account = account_counter.most_common(1)
            
            
        account_type = record["userIdentity"]["type"]
        account_counter[account_type] += 1
        
    return {
        "event_counts": dict(event_counter),
        "total_events": len(logs["Records"]),
        "resource_counts": dict(resource_counter),
        "most_accessed_resource": most_accessed_resource,
        "account_counts": dict(account_counter),
        "most_used_account": most_used_account,
    }
    