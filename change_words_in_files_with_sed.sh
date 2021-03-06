#!/bin/bash
#===============================================================================
#
#          FILE:  change_words_in_files_with_sed.sh
# 
#         USAGE:  ./change_words_in_files_with_sed.sh
# 
#   DESCRIPTION:  Change words in multiple files 
# 
#       OPTIONS:  ./change_words_in_files_with_sed.sh -h
#         NOTES:  Your sugestion is welcome to improve this script.
#        AUTHOR:  Alexandre Bargiela [ abargiela@gmail.com ]
#       VERSION:  1.2
#       CREATED:  30/01/2013 15:08:52 PM BRT
#      REVISION:  ---
#      Bug:	./change_words_in_files_with_sed.sh -f /tmp/test.txt -o /home\/something\/somethingelse -n /home/www Doesn't word yet need to something like: ./change_words_in_files_with_sed.sh -f /tmp/test.txt -o "\/home\/something\/somethingelse" -n "\/home\/www" 
#===============================================================================

getHelp(){
    echo -e "
        Usage:   ./change_words_in_files_with_sed.sh -d[for directory] -o oldWord -n newWord # Used to search in whole directories
           Or:   ./change_words_in_files_with_sed.sh -f[for file] file -o oldWord -n newWord # Used to search in a specific files

     Examples:
            Directory: ./change_words_in_files_with_sed.sh -d /tmp -o oldStuff -n newStuff
                 File: ./change_words_in_files_with_sed.sh -f /tmp/file1.txt -o oldStuff -n newStuff 

    -d Directory you want scan to make.
    -f Especific file to change.	
    -o Old word to search and replace.
    -n New word to be replaced.";
}

# Clean variables
DIR=
FILE=
OLD=
NEW=

# Get parameters
while getopts "d:f:n:o:h" file ; do
    case ${file} in
        d)
            DIR="${OPTARG}";
            ;;
        f)
            FILE="${OPTARG}";
            ;;
        o) 
            OLD="${OPTARG}";
            ;;
        n)
            NEW="${OPTARG}";
            ;;
        h)
            getHelp;
            ;;
        *)
            echo -e "\nInvalid option, please choose a valid one.\n";
            getHelp;
            exit;
            ;;
    esac
done

search_dir(){
    # Get data and parse
    TMP_FILE="/tmp/tmp.file";
    DATA=`egrep ${OLD} ${DIR} -R  | awk -F \: '{print $1}' | sed 's/ //g'`;
    echo $DATA | tr ' ' '\n' > ${TMP_FILE};

    for x in `cat ${TMP_FILE}`; do
        cp -a  ${x[@]} ${x[@]}-backup-`date +%d%m%Y-%s`;
    done

    # Get each file and execute the file backup and change the content
    for i in `cat ${TMP_FILE}`;do        
        sed -i "s/"${OLD}"/"${NEW}"/g" ${i[@]};
    done
}

# Modify a specific file
search_file(){
    cp -a ${FILE} "${FILE}_backup_`date +%d%m%Y_%s`";
    sed -i "s/"${OLD}"/"${NEW}"/g" ${FILE};
}

# Make the basic verifications.
if [[ -d $DIR ]]; then
    search_dir;
elif [[ -f ${FILE} ]]; then
    search_file;
elif [[ -z ${DIR} ]] || [[ -z ${FILE} ]] || [[ -z ${OLD} ]] || [[ -z ${NEW} ]]; then
    getHelp;
    exit 1;
fi
