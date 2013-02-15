#!/bin/bash
# Reload a varnish config
# Author: Kristian Lyngstol

# Modificated by A. Bargiela (alexandre@bargiela.com.br) in 15/02/2013
# Adjusted to work getting the vcl(FILE)/varnishadm port(HOSTPORT) without intervention, just plug and play

FILE=$(cat /etc/default/varnish|grep "\-f"|head -1| awk '{print $2}')

# Hostname and management port
# (defined in /etc/default/varnish or on startup)
HOSTPORT=$(cat /etc/default/varnish|grep "\-T" | awk '{print $3}')
NOW=`date +%s`

error()
{
	echo 1>&2 "Failed to reload $FILE."
	exit 1
}

varnishadm -T $HOSTPORT vcl.load reload$NOW $FILE || error
varnishadm -T $HOSTPORT vcl.use reload$NOW || error
echo Current configs:
varnishadm -T $HOSTPORT vcl.list

