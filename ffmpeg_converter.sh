#!/bin/bash

####################################################################
# Usage: sh /path/script/ffmpeg_converter.sh                       #
#                                                                  #
# Os arquivos para serem convertidos devem estar na pasta UPLOADS. #
# Obs.: Caso você baixe esse script do http://pastebin.com/        #
# execute: dos2unix /path/script/ffmpeg_converter.sh               #   
####################################################################

#Caminho principal aonde será criada a estrutura de pastas.
CAMINHO_PRINCIPAL="/home/alexandre/Desktop/teste_ffmpeg"
#Pasta aonde serão feito os uploads dos arquivos através da aplicação, FTP, whatever.
UPLOADS="${CAMINHO_PRINCIPAL}/uploads"
#Variável apenas utilizada para verificar se existe um arquivo e assim executar o script.
UPLOADS_TEST=$(ls ${CAMINHO_PRINCIPAL}/uploads/ | tail -n1);
#Pasta que guardará uma cópia do arquivo original antes de realizar a conversão.
ORIGINAL="${CAMINHO_PRINCIPAL}/original/"
#Pasta aonde estarão localizados os arquivos já processados pelo ffmpeg.
PROCESSADOS="${CAMINHO_PRINCIPAL}/processados"
#Log de saída do script.
LOG="${CAMINHO_PRINCIPAL}/processados/output.log"
#Arquivo que contém o timestamp e nome do arquivo para ser processado.
TXT_FILE="${CAMINHO_PRINCIPAL}/processados/processados.txt"
#Extensões que o script verifica, para verificar outras basta adiciona-las com espaço.
EXTENSOES=" *.3gp *.mpg *.mov *.mpeg4 *.mp4 *.wmv *.wma *.flv *.avi *.mpeg"
#Timestamp.
DATA=$(date +%d\|%m\|%Y\|%H\|%M);
#Pasta aonde serão criadas e convertidas as capas referente a cada vídeo convertido.
UPLOADS_IMG="${CAMINHO_PRINCIPAL}/uploads_img"
FFMPEG="/usr/bin/ffmpeg";
LOCK_FILE="/tmp/ffmpeg-sp.lock"

mkdir ${CAMINHO_PRINCIPAL} ${UPLOADS} ${UPLOADS_TEST} ${ORIGINAL} ${PROCESSADOS} ${UPLOADS_IMG};
touch ${TXT_FILE} ${LOG};
chmod 777 ${UPLOADS} ${UPLOADS_TEST} ${ORIGINAL} ${PROCESSADOS} ${UPLOADS_IMG} ${TXT_FILE} ${LOG};

#Verifica a existência do arquivo de lock, caso exista ele para o script e não executa
#para não ocasionar perda de dados.
if [ -e ${LOCK_FILE} ];then
    exit 1;
else
    touch ${LOCK_FILE};

cd ${UPLOADS};

#Mantem uma cópia do arquivo original.
\cp -rf ${EXTENSOES} ${ORIGINAL} > /dev/null 2>&1 ;

for i in `ls ${UPLOADS}/${EXTENSOES}`;do
    if [ -e "${UPLOADS_TEST}" ];then
        echo "Existem arquivos a serem processados!";
        #Realiza a conversão para flv.
        ${FFMPEG}            -y              \
                        -i ${i}         \
                        -ar 22050       \
                        -f flv          \
                        -s 300x220 ${PROCESSADOS}/${i} >> ${LOG} 2>&1;

        #Cria a capa do vídeo
        ${FFMPEG}            -i ${i}         \
                        -an             \
                        -ss 00:00:05    \
                        -t 00:00:01     \
                        -r 1            \
                        -y              \
                        -f image2     \
                        -s 63x35 ${UPLOADS_IMG}/${i} 2>&1;

        #Ajusta a extensão do arquivo convertido para .flv.
        FILE=`ls ${i}| awk -F . {'print $1".flv"'}`;
        mv ${PROCESSADOS}/${i} ${PROCESSADOS}/${FILE};

        #Ajusta a extensão da imagem capturada. 
        FILE2=`ls ${i}| awk -F . {'print "thumb_"$1".jpg"'}`;
        mv ${UPLOADS_IMG}/${i} ${UPLOADS_IMG}/${FILE2};

        #Joga para o log a saída.
        echo "${i} ${DATA} " >> ${TXT_FILE};
        #Remove arquivos antigos da pasta uploads.
        rm -rf  ${UPLOADS}/${i};
       
        #Remove o arquivo de lock.
        rm -rf ${LOCK_FILE};

    else
        echo "Não existem arquivos a serem processados!";
        #Remove o arquivo de lock.
        rm -rf ${LOCK_FILE};
    fi
done
fi