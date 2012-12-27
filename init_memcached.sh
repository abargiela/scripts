#!/bin/bash
MC_PATH=/opt/memcached-1.4.5;

. /lib/lsb/init-functions

start (){
# Verifica se a pasta de log existe, se não existir a cria.
if [ -d ${MC_PATH}/log/ ]; then
        echo "";
        else
                mkdir ${MC_PATH}/log/;
                chmod 775 ${MC_PATH}/log/
                chown nobody.root ${MC_PATH}/log/;
fi

# Verifica se o arquivo de log existe, caso não ele o cria.
if [ -f ${MC_PATH}/log/memcached_log.txt ]; then
        echo "";
        else
                touch ${MC_PATH}/log/memcached_log.txt;
                chmod 775 ${MC_PATH}/log/memcached_log.txt
                chown nobody.root ${MC_PATH}/log/memcached_log.txt;
fi

VEFICA_PROCESS=$(ps aux  | grep -i memcached | awk '{print $11}' | grep -v grep)
if [ -e "${VEFICA_PROCESS}" ] || [ -f ${MC_PATH}/memcached.pid ] ; then
    echo "Processo no ar.";
    exit 1;
    else
# Finalmente dou um start no processo.

${MC_PATH}/bin/memcached        -u nobody                       \
                                -d                              \
                                -l 127.0.0.1                    \
                                -p 11211                        \
                                -P ${MC_PATH}/memcached.pid \
                                -vv >> ${MC_PATH}/log/memcached_log.txt 2>&1;

    echo "Inicializado.";
fi

}

stop  () {

rm -rf ${MC_PATH}/memcached.pid;
killall -9 memcached;
echo "Processo Finalizado";

}

status (){

if [ -f /opt/memcached-1.4.5/memcached.pid ]; then
    echo "Processo está rodando";
    else
    echo "Processo não está rodando";
fi
}

case $1 in

start)
    start;
;;
stop)
    stop;
;;
status)
    status;
;;
*)
    echo "Como usar: /etc/init.d/memcached-init {start|stop|status}";
esac
# Duvidas sobre os parametros consulte man page:
# man /opt/memcached-1.4.5/share/man/man1/memcached.1