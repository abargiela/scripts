#!/bin/bash
#===============================================================================
#
#          FILE:  getTwitter.sh
# 
#         USAGE:  ./getTwitter.sh 
# 
#   DESCRIPTION:  Insert, search data at mongoDB
# 
#       OPTIONS:  ./getTwitter.sh -h
#  REQUIREMENTS:  curl, mongodb
#          BUGS:  ---
#         NOTES:  Your sugestion is welcome to improve this script.
#        AUTHOR:  Alexandre Bargiela [ abargiela@gmail.com ]
#       COMPANY:  
#       VERSION:  1.0
#       CREATED:  07/22/2012 11:39:52 PM BRT
#      REVISION:  ---
#===============================================================================

DB="bancoteste";
COLLECTION="colecaoteste";
FILE="/tmp/getTwitter.txt";
HOST="127.0.0.1";
PORT="27017";

insertData() {
 curl -k --silent https://search.twitter.com/search.json?q=$1 &gt; /tmp/getTwitter.txt;
 mongoimport --host ${HOST} --port ${PORT}  -d ${DB} -c ${COLLECTION} ${FILE};
}

getAllData(){
 mongoexport --host ${HOST} --port ${PORT} -d ${DB} -c ${COLLECTION} #| python -mjson.tool 
}

getSpecificData(){
 mongoexport --host ${HOST} --port ${PORT} -d ${DB} -c ${COLLECTION} -q '{"_id" : ObjectId("'$1'")}' #| python -mjson.tool
}

getHelp(){
echo "

options:
  -i Insert Data ( ./getTwitter.sh -i wordThatMustBeSearchedOnTwitter )
  -ga Search all data on mongo, seems the db.collection.find()
  -gs Search for ID, to use it, put only the ID example:
   { "_id" : ObjectId("5007107c6e955206f5000000"), "teste" : "1" } input only: 5007107c6e955206f5000000
   ./getTwitter.sh -gs 5007107c6e955206f5000000

"
}

case "$1" in
 -i)
 insertData $2 
 ;;
 -ga)
 getAllData
 ;;
 -gs)
 getSpecificData $2
 ;;
 -h)
 getHelp
 ;;
 *)
 echo "Invalid option! Try ./getTwitter.sh -h"
 ;;
esac
