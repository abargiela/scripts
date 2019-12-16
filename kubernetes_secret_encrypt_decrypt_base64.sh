#!/bin/bash

function backup(){
    cp "${FILE}" "${FILE}"-bkp-"$(date +"%m-%d-%Y_%H-%M-%S")"
    echo "Backup file created at: ${FILE}-bkp-$(date +"%m-%d-%Y_%H-%M-%S")"
}

function encrypt(){
    tmpfile=$(mktemp)
    sed 's/^ *//; s/ *$//; /^$/d'  "${FILE}" | awk '{ system ("var1=`echo "$1"`;var2=`echo "$2" | base64`; echo $var1 $var2") }' > "${tmpfile}"
    cat "${tmpfile}" > "${FILE}"
    rm -f "${tmpfile}"
}

function decrypt(){
    tmpfile=$(mktemp)
    awk '{ system ("var1=`echo "$1"`;var2=`echo "$2" | base64 -d`; echo $var1 $var2") }' "${FILE}" > "${tmpfile}"
    cat "${tmpfile}" > "${FILE}"
    rm -f  "${tmpfile}" 

}

function helper(){
    echo -n "Usage: $0 [-e encrypt] [-d decrypt] file
Example: $0 -e /tmp/file_with_plain_passwords.txt"
}

function check_params(){
if [ -z "${FILE}" ]; then
   echo "You didin't pass the file"; 
   helper
   exit 1;
fi   
}

while getopts ":ed" opt; do
  case ${opt} in
    e ) backup &&
        FILE=$2;
        check_params && 
        encrypt
      ;;
    d ) 
        FILE=$2;
        check_params &&
        decrypt
      ;;
    *|h ) helper
      ;;
  esac
done
shift $((OPTIND -1))
