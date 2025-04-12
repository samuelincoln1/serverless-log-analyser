from collections import Counter

def count_by_field(logs, field):
    counter = Counter()
    for log in logs: 
        value = log.get(field)
        if value:
            counter[value] += 1
    return counter