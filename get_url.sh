#!/bin/bash

#===============================================================================
#
#          FILE:  get_url.sh
# 
#         USAGE:  ./get_url.sh -u URL
# 
#   DESCRIPTION:  Monitore the response time of a specific URL, I used to 
#                 monitoring the time and answer of a URL that was in a 
#                 different datacenters, you can put the command 
#                 watch "nohup (/get_url.sh -u URL &) and look the log.
# 
#       OPTIONS:  ./get_url.sh -h
#  REQUIREMENTS:  curl
#          BUGS:  ---
#         NOTES:  Your sugestion is welcome to improve this script.
#        AUTHOR:  Alexandre Bargiela [ abargiela@gmail.com ]
#       COMPANY:  
#       VERSION:  1.0
#       CREATED:  02/10/2013 19:19:52 PM BRT
#      REVISION:  ---
#===============================================================================

LOG="/tmp/log_curl.log";
HOST1="${2}";
DATA=$(date);

function get_data(){
if [ -n "${HOST1}" ]; then
    URL1=$(/usr/bin/time --format="\t|\tResponse Time: %e" curl -s ${HOST1} 2>&1 | tr "\n" " ");
    echo -e "$DATA\t|\t$HOST1\t|\t$URL1"   >>   ${LOG};
    echo -e "Log: ${LOG}"
else
    echo -e "Pass a valid URL."
    exit 1;
fi
}

function getHelp(){
echo -e "
\tOptions:
\t\t-u URL (http://mysite/ or http://mysite/myURI)\n
\tUsage: ./get_url.sh -u http://mysite/
"
}

case "$1" in
    -u)
        get_data $2
        ;;
    -h)
        getHelp
        ;;
    *)
        echo "Invalid option! Try ./get_url.sh -h"
        ;;
esac
