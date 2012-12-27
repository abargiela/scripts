#!/bin/bash

PATH_ISO="$HOME" #This path should be the partition where you want to stress

read_file(){
	echo "
		Initializing io reading...
		When you want to terminate the test type CTRL+C
	     "
	while : ; do
		md5sum ${PATH_ISO}/teste.iso; sleep 1;
       done
}

read_file
