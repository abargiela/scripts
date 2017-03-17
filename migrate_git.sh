#!/bin/bash  

function get_help {
echo '
Usage: ./migrate_git.sh -o old_repo_url -n new_repo_url 
Ex.:   ./migrate_git.sh -o git@git_old.organization.com.br:devops/old_repository.git -n git@git_new.organization.com.br:devops/new_repository.git

Options:
-p      Local path where is your actual repository.
-u      path of your new repository in your new git.
-h      Show help.
'
}

while getopts "o:n:h" opt; do
	case $opt in
		o)
			OLD_URL=${OPTARG};
			;;
		n)
			NEW_URL=${OPTARG};
			;;
		*)  
			get_help;
			;;
	esac
done
shift $((OPTIND -1))

function check {
	if [[ -z ${OLD_URL} ]] || [[ -z ${NEW_URL}  ]]; then 
		echo "Missing parameter."
		exit 1;
	fi
}

function migration {
	DIR=$(echo /tmp/$RANDOM)
	echo $DIR
	mkdir $DIR
	cd ${DIR}
	git clone --mirror ${OLD_URL}

	REPO_MIRROR=$(echo ${OLD_URL} | awk -F \: '{print $(NF);}' | awk -F / '{print $(NF)}')
	cd ${DIR}/$REPO_MIRROR
	git remote set-url --push origin ${NEW_URL}
	git push --mirror
}

check
migration

OLD_URL=
NEW_URL=
