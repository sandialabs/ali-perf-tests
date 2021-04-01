#!/bin/bash
# Download, build, install lapack
PWD_PATH=`pwd`
CMAKE_PATH=${PWD_PATH}/cmake/3.20.0/gnu
LAPACK_PATH=${PWD_PATH}/lapack/3.9.0/gnu
mkdir -p ${LAPACK_PATH}

wget -c https://github.com/Reference-LAPACK/lapack/archive/v3.9.0.tar.gz
tar -xvf v3.9.0.tar.gz
cd lapack-3.9.0

mkdir -p build
cd build
${CMAKE_PATH}/bin/cmake \
  -DCMAKE_INSTALL_PREFIX=${LAPACK_PATH} \
  -DCMAKE_BUILD_TYPE:STRING=RELEASE \
  -DCBLAS:BOOL=ON \
  ..
make -j 4
make install
cd ${PWD_PATH}

