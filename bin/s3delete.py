#!/usr/bin/env python3
import boto3
import sys

s3 = boto3.resource("s3")

for v in sys.argv[1:]:
    print(f"deleting all object versions in: {v}")
    s3.Bucket(v).object_versions.all().delete()
