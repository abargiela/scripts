#!/bin/bash

# Coloque a porta a testar.
PORTA="80"

# Coloque o ou os IPs desejados no teste.
LISTA="72.32.231.8
128.242.245.157
128.242.240.116
168.143.162.36
209.85.195.104
69.63.189.11
69.63.190.22
69.63.181.47
69.63.181.12
72.246.64.161
69.63.178.31
69.63.181.20
74.125.45.85
209.85.195.104
74.125.65.85"


for i in `echo ${LISTA}`; do
   telnet -e x $i ${PORTA} << EOF
   x
EOF
done