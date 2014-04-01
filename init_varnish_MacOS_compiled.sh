#!/bin/bash

# Created: 03/31/2014

##########################################
# Read carefully the instructions below. #
##########################################
# This script was created for a specific situation. I compiled so that developers can have the varnish locally on their development machines in this case MacOS. 
# The main idea was they had the varnish without having to install it. 
# I can not guarantee that this script will work perfectly for your environment.
# After compile Varnish, I suggest you to put this file into /opt/varnish-dev/etc/

# Varnish compilation method that I used in this case:
# wget -c http://repo.varnish-cache.org/source/varnish-3.0.5.tar.gz
# tar -xzvf varnish-3.0.5.tar.gz && cd varnish-3.0.5
# sudo ./autogen.sh
# ./configure --prefix=/opt/varnish-dev --bindir=/opt/varnish-dev/bin --sbindir=/opt/varnish-dev/sbin --libexecdir=/opt/varnish-dev/libexec --sysconfdir=/opt/varnish-dev/etc --localstatedir=/opt/varnish-dev/var --libdir=/opt/varnish-dev/lib
# make
# make install
# Do not forget to copy yout VCL to /opt/varnish-dev/etc and set it at variable MAIN_VCL.

VARNISH_PATH="/opt/varnish-dev";
MAIN_VCL="default.vcl";
BIND_ADDR="127.0.0.1";

if [ $UID -ne 0 ]; then
  echo "You need to be root to run";
  exit 1;
fi

if [ ! -d "/etc/varnish" ]; then
  ln -s ${VARNISH_PATH}/etc /etc/varnish
fi

if [ ! -d "${VARNISH_PATH}/var/varnish/$HOSTNAME" ]; then
  mkdir -p ${VARNISH_PATH}/var/varnish/$HOSTNAME;
fi

start(){
  nc -z ${BIND_ADDR} 80 > /dev/null 2>&1;
  if [ $? -eq 1 ]; then
    ${VARNISH_PATH}/sbin/varnishd  -P ${VARNISH_PATH}/var/varnishd.pid -a :80 -f ${VARNISH_PATH}/etc/${MAIN_VCL} -T ${BIND_ADDR}:79 -u nobody -g nobody -t 120 -w 5,500,300 -s file,${VARNISH_PATH}/var/varnish-dev_storage.bin,1G &
    test $? -eq 0 &&  echo "Varnish started! \o/" || echo "FAILED to start!!! :(" 
  else
    echo "Port 80 is already running, check it!"
  fi
}

stop(){
  for i in `/usr/bin/pgrep varnishd`; do 
    kill -9 $i;

    if [ -a ${VARNISH_PATH}/var/varnishd.pid ] ; then
      rm ${VARNISH_PATH}/var/varnishd.pid;
    fi

  done
  test $? -eq 0 &&  echo "Varnish stopped!" || echo "Varnish still running..."
}

status(){
  pgrep varnishd > /dev/null 2>&1;
  test $? -eq 0 &&  echo "Varnish is running..." || echo "Varnish is stopped"
}

restart(){
  stop;
  start;
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
  restart)
    restart;
    ;;
  *)
    echo "Usage: ${VARNISH_PATH}/etc/init_varnish_MacOS_compiled.sh (start|stop|restart|status)";
esac
