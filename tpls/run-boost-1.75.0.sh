#!/bin/bash
# Download, build, install boost
PWD_PATH=`pwd`
BOOST_PATH=${PWD_PATH}/boost/1.75.0/gnu
mkdir -p ${BOOST_PATH}

wget -c https://dl.bintray.com/boostorg/release/1.75.0/source/boost_1_75_0.tar.gz
tar -xvf boost_1_75_0.tar.gz
cd boost_1_75_0

./bootstrap.sh --prefix=${BOOST_PATH} --with-toolset=gcc
./b2 -j 4 --without-python --without-stacktrace link=static install
cd ${PWD_PATH}

