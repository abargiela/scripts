import boto3
import re
import sys

# Requirements: python3
# pip install boto3 re


instances_ids = list(sys.argv[1:])
instances_len = len(sys.argv)

x = 0

# Add the credentials path must be the full path
cred = "/home/user/.aws/credentials"
# Region you want
region = "us-east-1"


if instances_len <= 1:
    sys.exit("You need pass at least one id argument")
else:
    pass

# import pdb; pdb.set_trace()
with open(cred) as file:
    data = file.read()
    # get only the credentials [my-credential]
    data = re.findall(r"\[.*\]", data)

    for i in data:
        # Count the parameters passed
        while instances_len >= x:
            x += 1
        # Removes [] from the profile
        profile = re.sub(r"\[|\]", "", i)
        # uses the profile in the session
        session = boto3.Session(profile_name=profile, region_name=region)
        client = session.client("ec2")
        for instancesids in instances_ids:
            try:
                response = client.describe_instances(InstanceIds=[instancesids])
                print(f"\nInstance: {instancesids} found: {profile}\n{response}\n")
            except:
                print(f"Instance: {instancesids} not found: {profile}")
