#!/bin/bash
#

# The idea of this script is to have a local git repo where you have you annotations always versioned, so everything you create inside ANNOTATIONS_PATH will be locally versioned when you run this script.
# I use it as an alias for the files I want to version and after close it it runs the function commit_annotation.
# It's useful for me hope it is for you, use on your own risk I don't garantee you are versioning your files or that you are not going to lose it, so be careful.

ANNOTATIONS_PATH="/home/${USER}/Documents/annotations"

check_if_its_git_repo(){
	if [[ ! -d ${ANNOTATIONS_PATH} ]]; then
		echo "Directory ${ANNOTATIONS_PATH} does not exists."
		exit 1;
	fi

	if [[ ! -d ${ANNOTATIONS_PATH}/.git ]]; then
		echo "Directory ${ANNOTATIONS_PATH} is not a git repo."
		exit 1;
	fi
}

commit_annotation()
{
	check_if_its_git_repo

	cd ${ANNOTATIONS_PATH}
	git diff --exit-code ${ANNOTATIONS_PATH}
	if [[ $? -eq 1 ]]; then
		cd ${ANNOTATIONS_PATH}
		BRANCH_NAME=`date "+%F_%H-%M-%S"`
		git checkout -b ${BRANCH_NAME}
		git add -A
		git commit -m "`git diff HEAD`"
		git checkout master
		git merge ${BRANCH_NAME}
	fi
}

commit_annotation
