#!/bin/bash
# Download, build, install zlib
PWD_PATH=`pwd`
ZLIB_PATH=${PWD_PATH}/zlib/1.2.11/gnu
mkdir -p ${ZLIB_PATH}

wget -c https://zlib.net/zlib-1.2.11.tar.gz
tar -xvf zlib-1.2.11.tar.gz
cd zlib-1.2.11

CFLAGS=-O3 ./configure --prefix=${ZLIB_PATH}
make -j 4
make install
cd ${PWD_PATH}

