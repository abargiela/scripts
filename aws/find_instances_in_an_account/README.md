Usage: 
```
 $ python find_instances.py i-xxxxxxx i-xxxxxxx i-xxxxxxx i-xxxxxxx`
 Where i-xxxxxxx = your instances IDs
``` 

> Python3 required. 

> boto3 and re required, install using pip

How it works, the script will search in your ~/.aws/credentials profiles and based on it will search the instances in each account.
