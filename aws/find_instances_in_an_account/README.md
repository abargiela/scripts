This script will search inside your ~/.aws/credentials, so you need configure all profiles you want, for now if you have more than one region you will need first search in one than in the credentials file change for another to search again,  example if you have an account and use us-east-1 as default but have some machines in São Paulo region you first can search in us-east-1 region then if doesn't find anythins change the region in your credential file to sa-east-1 and search again.


Download de desired script


> Install dependencies

`apt-get install python3-pip python3`

> Create an virtualenv

`virtualenv --python=python3 myVirtualEnv`

> load the virtualenv

`source myVirtualEnv/bin/source`

> Install script dependencies

`pip install boto3`

> Exemples of usage

`python find_private.py xxx.xxx.xxx.xxx` (change for the IP you want to search in your infrastructure)

`python find_public.py xxx.xxx.xxx.xxx` (change for the IP you want to search in your infrastructure)

 `python find_instances.py i-xxxxxxx i-xxxxxxx i-xxxxxxx i-xxxxxxx` (Where i-xxxxxxx = your instances IDs)
