#!/bin/bash

#Script Tested in Ubuntu 12.04.2 LTS

DOWNLOAD_PATH="/tmp"

COMPANY="YOUR_COMPANY_HERE"
BUILD_PATH="${DOWNLOAD_PATH}/${VERSION}/"

VARNISH_VERSION="3.0.5";
VARNISH_PATH="${DOWNLOAD_PATH}/varnish-${VARNISH_VERSION}/";

LIB_DIGEST_VERSION="0.3";
LIB_DIGEST_PATH="${DOWNLOAD_PATH}/libvmod-digest/";

function test_packages(){
#0 = installed
#1= not installed

  PKG_LIBMHASH=$(dpkg-query -l libmhash-dev; echo $?);
  PKG_GIT=$(dpkg-query -l git && echo $?);
  PKG_RUBY=$(gem list|grep fpm && echo $?);
  PKG_LIBVARNISHAPI=$(dpkg-query -l libvarnishapi-dev && echo $?);
  PKG_PYTHON-DOCUTILS=$(dpkg-query -l python-docutils && echo $?);

  if [ "${PKG_LIBMHASH}" -ne "0" ]; then
    apt-get install libmhash-dev;
  fi 

  if [ "${PKG_PYTHON-DOCUTILS}" -ne "0" ]; then
    apt-get install python-docutils;
  fi 

  if [ "${PKG_LIBVARNISHAPI}" -ne "0" ]; then
    apt-get install libvarnishapi-dev;
  fi 

  if [ "${PKG_GIT}" -ne "0" ]; then
    apt-get install git;
  fi

  if [ "${PKG_RUBY}" -ne "0" ]; then
    apt-get install ruby && gem install fpm --no-ri --no-rdoc;
  fi
}

function compile_varnish(){

  if [ -d ${VARNISH_PATH}]; then
    cd ${VARNISH_PATH};
    make clean;
  fi

  cd ${DOWNLOAD_PATH} \

  wget -c http://repo.varnish-cache.org/source/varnish-${VARNISH_VERSION}.tar.gz && \ 

  tar -xzvf varnish-${VARNISH_VERSION}.tar.gz && \

  cd ${VARNISH_PATH} && \
  ./autogen.sh && \
  /configure --bindir="/usr/bin/" --libdir="/usr/lib/varnish/" --sysconfdir="/etc/varnish" --prefix="/opt/varnish-${VARNISH_VERSION}" && \
  make
}

function compile_libvmod_digest(){

  if [ -d ${LIB_DIGEST_PATH}]; then
    cd ${LIB_DIGEST_PATH};
    make clean;
  fi

  cd ${DOWNLOAD_PATH} && \
  git clone https://github.com/varnish/libvmod-digest.git 
  cd ${LIB_DIGEST_PATH} && \
  ./autogen.sh && \
  ./configure VARNISHSRC=${DOWNLOAD_PATH}/varnish-${VARNISH_VERSION}/ && \
  make
}

function make_deb_varnish(){
  find  ${VARNISH_PATH} -name "*.deb" -exec rm -f {} \;
  cd ${VARNISH_PATH}
  fpm -s dir -n ${COMPANY}-varnish -v ${VARNISH_VERSION} --prefix ${COMPANY} --description "Varnish ${COMPANY} custom"  -t deb ${VARNISH_PATH}
}

function make_deb_libvmod_digest(){
  find  ${LIB_DIGEST_PATH} -name "*.deb" -exec rm -f {} \;
  cd ${LIB_DIGEST_PATH}
  fpm -s dir -n ${COMPANY}-libvmod-digest -v ${LIB_DIGEST_VERSION} --prefix ${COMPANY} --description "libvmod-digest ${COMPANY} custom"  -t deb ${LIB_DIGEST_PATH}
}

test_packages;
compile_varnish;
compile_libvmod_digest;
make_deb_varnish;
make_deb_libvmod_digest;

