#!/usr/bin/python
import csv
import json
import sys

with open(sys.argv[1]) as f:
    output = { 'instances': [] }
    reader = csv.reader(f)
    headers = next(reader)
    headers.insert(0, 'CheckType')
    for row in reader:
        row.insert(0, 'CardSerialNumberMismatch')
        output['instances'].append(dict(zip(headers, row)))

with open(sys.argv[2], 'w') as f:
    f.write(json.dumps(output, indent=4))
