#!/bin/bash
#===============================================================================
#
#          FILE:  change_words_in_files_with_sed.sh
# 
#         USAGE:  ./change_words_in_files_with_sed.sh
# 
#   DESCRIPTION:  Change words in multiple files 
# 
#       OPTIONS:  ./getTwitter.sh -h
#         NOTES:  Your sugestion is welcome to improve this script.
#        AUTHOR:  Alexandre Bargiela [ abargiela@gmail.com ]
#       VERSION:  1.0
#       CREATED:  30/01/2013 15:08:52 PM BRT
#      REVISION:  ---
#===============================================================================

#Directory you want scan and make the sed.
DIR="/tmp"
#What do you want to search
SEARCH="oldStuff";
#Generally you will change what you search, so, I put the variable FROM only for readability.
FROM="${SEARCH}";
#As will be.
TO="newStuff";

for i in `egrep ${SEARCH} ${DIR}/* -R | awk -F \: '{print $1}'`;do
	sed -i "s/${FROM}/${TO}/g" $i
done
