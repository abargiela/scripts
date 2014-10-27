#!/bin/bash

function extract {
cd /tmp/;
wget -c http://www1.caixa.gov.br/loterias/_arquivos/loterias/D_$1.zip;
unzip D_$1.zip
egrep ">[0-9][0-9]<" D_$LOTO.HTM | \
  awk -F \> '{print $2}' | \
  awk -F \< '{print $1}' | \
  sort | \
  uniq -c |sort;

rm -rf  LOT*.GIF T*.GIF D_$LOTO.HTM D_$1.zip;
exit 1;
}

case "$1" in
  megase)
    LOTO="MEGA";
    extract $1 $LOTO;
    ;;

  lotfac)
    LOTO="LOTFAC";
    extract $1 $LOTO;
    ;;

  quina)
    LOTO="QUINA";
    extract $1 $LOTO;
    ;;

  *)
    echo "Usage: $0 { megase | quina | lotfac }";
    exit 1;
esac
