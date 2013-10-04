#!/bin/bash

# Referência: http://www.gnu.org/software/gawk/manual/html_node/Using-BEGIN_002fEND.html

FILE=$1;
STRING=$2;

function procura_palavra(){

    awk 'BEGIN { 
            print "Analisando arquivo '${FILE}'" }
            /'${STRING}'/ { ++valor }
          END{ 
            print "'${2}' aparece " valor " vezes." }' $1

}



function ajuda(){
echo -e "

    Uso: count_string_in_a_file.sh -a ARQUIVO -s STRING_QUE_DESEJA_CONTAR

    -a | -f : Passar o arquivo (ex.: file.txt).
    -s      : String que deseja procurar no arquivo.
"
}

procura_palavra $1 $2
