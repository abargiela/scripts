#!/bin/bash

LOG_FILE="/tmp/log_conn_80.txt";
STATE="ESTABLISHED";
PORT=":80";

if [ -e ${LOG_FILE} ]; then
        echo "";
else
        touch ${LOG_FILE};
fi

while :
do
        DATA=$(date +%d\|%m\|%Y\|%H\|%M);
        MONITORA=$(netstat -ntau | egrep -i "${STATE}" | egrep -i "${PORT}" | wc -l);

        sleep 60;
        echo "${MONITORA} ${DATA}" >> ${LOG_FILE};
done