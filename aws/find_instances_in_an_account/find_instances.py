import boto3
import re

# Requirements: python3
# pip install boto3 re

# Add the instances you want to search, accept instances in multiple accounts
instances_ids = ['i-xxxxxxxxx', 'i-xxxxxxxxx','i-xxxxxxxxx','i-xxxxxxxxx']
# Add the credentials path must be the full path
cred="/home/alexandre.bargiela/.aws/credentials"
# Region you want
region='us-east-1'

with open(cred) as file:
    data = file.read()
    # get only the credentials [my-credential]
    data = re.findall(r"\[.*\]",data)
    for i in data:
        # Removes [] from the profile
        profile = re.sub(r'\[|\]','',i)
        # uses the profile in the session
        session = boto3.Session(profile_name=profile,region_name=region)
        client = session.client('ec2')

        for instancesids in instances_ids:
            try:
                response = client.describe_instances(
                InstanceIds = [instancesids],
                )
                print(f"\nInstance: {instancesids} found: {profile}\n{response}\n" )
            except: 
                print(f"Instance: {instancesids} not found: {profile}" )
