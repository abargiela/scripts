#!/bin/bash

# Usage: bash update_nvim.sh

# Tested on Debian 11
# Use on your own risk

check_packages(){
	dpkg -s gh > /dev/null 2>&1 ;
	if [[ $? -eq 0 ]]; then
		update_nvim;
	else
		echo -e "ERROR: gh package is not installed, please install it first: https://github.com/cli/cli/releases";
		exit 1;
	fi
}

check_symlink(){
	if  [[ -L `which vim` ]] ; then
		echo -e "WARNING: Seems you are using a symlink on vim: `ls -lahS $(which vim)`, make sure there is no other installation of neovim otherwise you maybe is not using the installed version by this script.\n";
	else
		nvim -v;
	fi
	exit 0;
}

update_nvim(){
	TEMP_PATH="/tmp"
	REPO_URL="https://github.com/neovim/neovim"

	if [ -e ${TEMP_PATH}/nvim*deb ]; then rm ${TEMP_PATH}/nvim*deb; fi

	echo -e "INFO: Downloading Neovim...\n";
	gh release download -R ${REPO_URL}  \
						-p '*.deb'	    \
						-p 'Latest'		\
						-D ${TEMP_PATH}/

	echo -e "INFO: Installing Neovim...\n";sudo dpkg -i ${TEMP_PATH}/nvim*deb > /dev/null 2>&1 && echo -e "INFO: Neovim installed with sucess!\n"
	check_symlink
	echo -e "INFO: Neovim installed with sucess!"
	exit 0
}

check_packages
