#!/bin/bash

# This script was used to stress a iscsi partition and get the performance of it.
# My ideia was write/read simultaneously in the iscsi mount point to see how it behaves.
# So basicly I use dd to write and a simple ls to read the partition.

PATH_ISO="$HOME" #This path should be the partition where you want to stress
OUTPUT_INFO="/tmp"

write_file(){
	echo "
	Initializing IO writing...
	when you want to terminate the test, type CTRL+C
	"
	while : ; do
		date >> ${OUTPUT_INFO}/dd.txt && dd if=/dev/zero  of=${PATH_ISO}/teste.iso count=1000000 bs=1048 >> ${OUTPUT_INFO}/dd.txt 2>&1 && echo "";
	done
     }

#read_file(){
#	echo "
#	Initializing io reading...
#	When you want to terminate the test type CTRL+C
#	"
#	while : ; do
#		ls ${PATH_ISO}/; sleep 1;
#	done
	echo "Not implemented yet."
#}

average(){
	if [ -e ${OUTPUT_INFO}/dd.txt ]; then
		TOTAL=$(egrep "byt" ${OUTPUT_INFO}/dd.txt | awk '{print $8}'|wc -l);
		VALORES=$(egrep "byt" ${OUTPUT_INFO}/dd.txt | awk '{print $8}'|tr "\n" "+"|sed "s/+$/ /g");
		SOMA=$(echo "${VALORES}"|bc)
		echo "Transmission Average:: $(echo "${SOMA}/${TOTAL}"|bc) MB/s "
	else
		echo "No data to execute the data collecting, please execute the test again."
	fi
}

lowestValue(){
	if [ -e ${OUTPUT_INFO}/dd.txt ]; then
		echo "low transmission rate: $(egrep "byt" ${OUTPUT_INFO}/dd.txt | awk '{print $8}'|sort -n|less|head -1) MB/s";
	else
		echo "No data to execute the data collecting, please execute the test again."
	fi
}

higherValue(){
	if [ -e ${OUTPUT_INFO}/dd.txt ]; then
		echo "Higher transmission rate: $(egrep "byt" ${OUTPUT_INFO}/dd.txt | awk '{print $8}'|sort -n|tail -1) MB/s";
	else
		echo "No data to execute the data collecting, please execute the test again."
	fi
}

case "$1" in
	-w|write)
			write_file
	;;
	-r|read)
			read_file
	;;
	-av|average)
			average
	;;
	-lv|lv)
			lowestValue
	;;
	-hv|hv)
			higherValue
	;;
	-h|-help|--help|help|*)
			echo "
			-w|write 		Start write test.
			-r|read 		Start read test.
			-av|average 	Display average of test.
			-lv|lv 			Display lowest value of the test.
			-hv|hv 			Display higher value of the test.
			-h|help			Help.

			Usage: ./io_stress.sh -w|-r|-av|-lv|-hv|-h|write|read|average|lv|hv|help"
    ;;
esac
