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
#      Bug: If you execute N times the script, it cause a problema with the backup file:  /tmp/teste/info.txt-backup-05022013-1360095125-backup-05022013-1360095126-backup-05022013-1360095126-backup-05022013-1360095127-backup-05022013-1360095127-backup-05022013-1360095127-backup-05022013-1360095255 /tmp/teste/info.txt-backup-05022013-1360095125-backup-05022013-1360095126-backup-05022013-1360095126-backup-05022013-1360095127-backup-05022013-1360095127-backup-05022013-1360095127-backup-05022013-1360095255-backup-05022013-1360095256
# It creates a lot of backups with strange names.
#===============================================================================

getHelp(){
    echo -e "
    Usage: ./change_words_in_files_with_sed.sh -d[for directory] or -f[for file] file -o oldWord -n newWord
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
    TMP_FILE="/tmp/tmp.file"
    DATA=`egrep ${OLD} ${DIR} -R  | awk -F \: '{print $1}' | sed 's/ //g'`
    echo $DATA | tr ' ' '\n' > ${TMP_FILE}

    # Get each file and execute the file backup and change the content
    for i in `cat ${TMP_FILE}`;do
        cp -a ${i[@]} ${i[@]}-backup-`date +%d%m%Y-%s`;
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
