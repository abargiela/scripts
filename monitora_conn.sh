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
	echo "When you want to exit type CTRL+C, but wait to collect some data at ${LOG_FILE}."
        DATA=$(date +%d\/%m\/%Y\_%H\:%M);
        MONITORA=$(netstat -ntau | egrep -i "${STATE}" | egrep -i "${PORT}" | wc -l);
	echo "Established Connections: "${MONITORA} "|" "Date: "${DATA} >> ${LOG_FILE};
        sleep 60;        
done
