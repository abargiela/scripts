import boto3
import re

# Requirements: python3
# pip install boto3 re

# Add the instances you want to search
instances_ids = ['i-xxxxx', "i-xxxxxx"]
# Add the credentials path must be the full path
cred="/home/user/.aws/credentials"
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

        try:
            for instancesids in instances_ids:
                response = client.describe_instances(
                InstanceIds = [instancesids],
                )
                print(f"\nFOUND IN PROFILE: {profile}\n{response}\n" )
        except: 
            print(f"Not found in {profile}" )
