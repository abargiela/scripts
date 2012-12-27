#!/bin/bash

# This script list the vhost in multiple instances of apache, or in just one.

for i in `ps wwwaux  | egrep -i "apache|http" | grep -v rotatelog | awk '{print $11}' | sort -u`
do 

echo "
-----------------------------------------------------
   $($i -t -D DUMP_VHOSTS);    
-----------------------------------------------------";
done
