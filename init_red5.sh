 #!/bin/bash

RED5_PATH_PROD="/opt/red5-prod/";
RED5_PATH_QA="/opt/red5-qa/";

start () {
	cd ${RED5_PATH_PROD};
	(sh red5.sh &);
	cd ${RED5_PATH_QA};
	(sh red5.sh &);
}

stop () {
	for i in `ps auxwww | grep -i red5 | awk '{print $2}'`; do
		kill -9 $i;
	done
}

case $1 in
	start)
		start;
		;;
	stop)
		stop;
		;;
	*)
		echo "Como usar: /etc/init.d/red5-init {start|stop}";
esac
