import json
import csv
import os

def export_to_json(logs, path):
    with open(path, "w") as f:
        json.dump(logs, f, indent=2)
    print(f"[+] Exported JSON logs to {path}")

def export_to_csv(logs, path):
    with open(path, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["event_name", "count"])
        for event_name, count in logs["event_counts"].items():
            writer.writerow([event_name, count])
    print(f"[+] Exported CSV logs to {path}")
    
    
    