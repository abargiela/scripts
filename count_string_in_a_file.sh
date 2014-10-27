#!/bin/bash

# Referência: http://www.gnu.org/software/gawk/manual/html_node/Using-BEGIN_002fEND.html
while getopts "a:f:s:h" opt; do
  case $opt in
    h)
      HELP=${OPTARG};
      ;;
    a|f)
      FILE=${OPTARG};
      ;;
    s)
      STRING=${OPTARG};
      ;;
    *)
      echo "Parameter not found, try -h to help"
      ;;
  esac
done

function procura_palavra(){

    awk 'BEGIN { 
            print "Analisando arquivo '${FILE}'" }
            /'${STRING}'/ { ++valor }
          END{ 
            print "'${STRING}' aparece " valor " vezes." }' ${FILE}

}

function ajuda(){
echo -e "

    Uso: count_string_in_a_file.sh -a ARQUIVO -s STRING_QUE_DESEJA_CONTAR

    -a | -f : Passar o arquivo (ex.: file.txt).
    -s      : String que deseja procurar no arquivo.
"
}

# Make the basic verifications.
if [[ -f ${FILE} ]]; then
    procura_palavra;
elif [[ -n ${STRING} ]]; then
    procura_palavra;
elif [[ -z ${FILE} ]] || [[ -z ${STRING} ]]; then
    ajuda;
    exit 1;
fi
