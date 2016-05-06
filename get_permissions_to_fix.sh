#!/bin/bash 

function help {
  echo -e "
  Usage: bash `basename "$0"` FILE|DIR 
"
}

function get_permissions {
for i in `find $1` ;do 
        echo -e "chmod `stat -c '%a %n' $i` \nchown `stat -c '%U:%G' $i` $i" >> /tmp/permissions_$(date "+%Y%m%d").sh
done
        echo "Execute: bash /tmp/permissions_$(date "+%Y%m%d").sh"
}

case $1 in
    -h|--help)
    help
    ;;
  $1)
    get_permissions $1
    ;;
  *)
    echo "Type a valid option or help for help"
    exit 1
    ;;
esac
