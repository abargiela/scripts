#!/bin/bash

# This script just list all crontabs of all users
# It can be util if you don't know how user have crons.

for i in `cat /etc/passwd | awk -F : '{print $1}'`
do

echo "
------------------
### $i ###
$(crontab -l -u $i)
------------------";

done
