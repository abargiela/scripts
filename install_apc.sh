#!/bin/bash

 ##############################################################################
#                                                                             #
# Nome: install_apc_auto.sh - Instala APC automaticamente.                    #
# Site: http://abargiela.blogspot.com/2010/08/script-para-instalar-apc.html   #
#                                                                             # 
# Dependencias: wget, make, php-devel, pcre-devel, php                        #
#                                                                             #
# --------------------------------------------------------------------------- #
# Atenção: Sugiro após a instalação remover por motivos de segurança o wget   #
# e o make.                                                                   #
# --------------------------------------------------------------------------- #
#                                                                             #
#                                                                             #
# --------------------------------------------------------------------------- #
#                                                                             #
# - Voce poderia utilizar para realizar a instalação o PCEL install apc fica  #
# a sua  escolha, segue um exemplo:                                           #
# http://www.jainsachin.com/php_manual_tutorial/install.pecl.html             #
# - Porém por motivos de estudo resolvi criar um script.                      #
# - Certifique-se que quando voce dá um php -ini voce não tem nenhum retorno, #
# warning ou error, caso exista sugiro corrigi-lo antes de continuar.         #
# - Este é um script que deve ser melhorado, portanto críticas construtivas   #
# são muito, bem vindas utilize por sua conta e risco.                        #
#                                                                             #
# --------------------------------------------------------------------------- #
#                                                                             #
# Licença GPL                                                                 #
#                                                                             #
 ##############################################################################


unset WGET MV TAR RM AWK WHEREIS LDCONFIG LN CD SED EGREP;

WGET=$(type -p wget);
MV=$(type -p mv);
TAR=$(type -p tar);
RM=$(type -p rm);
AWK=$(type -p awk);
WHEREIS=$(type -p whereis);
LDCONFIG=$(type -p ldconfig);
LN=$(type -p ln);
CD=$(type -p cd);
SED=$(type -p sed);
EGREP=$(type -p egrep);
HEAD=$(type -p head);
MAKE=$(type -p make);

clear

echo "--> Downloading apc...";
${WGET} -c http://pecl.php.net/get/APC > /dev/null 2>&1

${MV} -f APC apc-last.tgz;
echo "--> Renomeando pasta.";

${TAR} -xzf apc-last.tgz;
echo "--> Descompactando APC";

${RM} apc-last.tgz > /dev/null 2>&1
echo "--> Removendo arquivos desnecessários";

${LDCONFIG};
echo "--> Atualizando bibliotecas";

# Pega a versão do APC.
APC_VERSION=$(ls -d APC*);

${MV} -f ${APC_VERSION} /opt/${APC_VERSION} > /dev/null 2>&1
echo "--> Movendo APC para o diretório /opt";

# Pega o caminho do php, para eventuais usos como php -i ou phpize
PHP_PATH=$(${WHEREIS} php\.*[a-zA-Z]\* | awk '{print $2}');
PHPIZE_PATH=$(${WHEREIS} phpize | ${AWK} '{print $2}');

cd /opt/${APC_VERSION};

echo "--> Compilando APC...";
${PHPIZE_PATH} > /dev/null 2>&1
./configure --with-php-config=${PHP_PATH}-config --enable-apc > /dev/null  2>&1
${MAKE} > /dev/null  2>&1
${MAKE} install > /dev/null  2>&1
echo "--> Compilado!";

# Pega o caminho aonde o php.ini se encontra, isso será usado no sed.
PHP_INI=$($PHP_PATH --ini | $EGREP "^.*\/php.ini$" | $AWK '{print $4}');

# Pega o caminho aonde está o apc.so, isso será usado para poder adicionar
# no php.ini o extension=/caminho/apc.so
APC_PATH='extension='$($PHP_PATH -i | $EGREP -i extension_dir | $HEAD -n1 | $AWK '{print $3"/apc.so"}')

cp -rf ${PHP_INI} ${PHP_INI}-$(date +%F);
echo "--> BACKUP do php.ini feito ${PHP_INI}-$(date +%F)";

echo "--> Habilitando apc.so no php.ini..."
$SED -i "s,\[PHP\],\
\[PHP\]\n\[apc\]\n\
apc\.enabled\=1\n\
apc\.shm_segments\=1\n\
apc\.shm_size\=128\n\
apc\.ttl\=7200\n\
apc\.user\_ttl\=7200\n\
apc\.num\_files_hint\=1024\n\
apc\.mmap\_file_mask\=\/tmp\/apc\.XXXXXX\n\
apc\.enable\_cli\=1\n\
apc\.max\_file_size=2M\n\
${APC_PATH},g" $PHP_INI > /dev/null  2>&1
echo "--> Habilitado apc.so no php.ini!";

# Mostra se o apc está ou não enable no php.
${PHP_PATH} -i | ${EGREP} -i "APC Support";

unset WGET MV TAR RM AWK WHEREIS LDCONFIG LN CD SED EGREP; 