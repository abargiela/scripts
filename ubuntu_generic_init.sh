#! /bin/sh

# Generic init tested in ubuntu 12 >
SERVICE_NAME="my_app"
PATH=/opt/ruby/bin/:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON="/opt/ruby/bin/ruby /my/path/${SERVICE_NAME}/app"
DAEMON_OPTS="-E environment -c /etc/app/${SERVICE_NAME}.rb"

. /lib/lsb/init-functions

case "$1" in
        start)
                echo -n "Starting ${SERVICE_NAME}:\n "
                start-stop-daemon --start --quiet --background --make-pidfile --pidfile /var/run/${SERVICE_NAME}.pid --exec ${DAEMON} -- ${DAEMON_OPTS}
        ;;
        stop)
                echo -n "Stopping ${SERVICE_NAME}:\n "
                start-stop-daemon --stop --quiet --oknodo --retry 5 --pidfile /var/run/${SERVICE_NAME}.pid --exec $DAEMON
        ;;
        restart|force-reload)
                echo -n "Restarting ${SERVICE_NAME}:\n "
                start-stop-daemon --stop --quiet --oknodo --retry 5 --pidfile /var/run/${SERVICE_NAME}.pid --exec $DAEMON
                sleep 1
                start-stop-daemon --start --quiet --background --make-pidfile --pidfile /var/run/${SERVICE_NAME}.pid --exec ${DAEMON} -- ${DAEMON_OPTS}
        ;;
        status)
                status_of_proc -p /var/run/${SERVICE_NAME}.pid "$DAEMON" ${NAME} && exit 0 || exit $?
        ;;
        *)
                N=/etc/init.d/${SERVICE_NAME}
                echo "Usage: ${N} {start|stop|restart|force-reload|status}" >&2
                exit 1
        ;;
esac

exit 0
