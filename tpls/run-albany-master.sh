#!/bin/bash
# Download, build, install albany
PWD_PATH=`pwd`
CMAKE_PATH=${PWD_PATH}/cmake/3.20.0/gnu
TRILINOS_PATH=${PWD_PATH}/trilinos/develop/gnu
ALBANY_PATH=${PWD_PATH}/albany/master/gnu
mkdir -p ${ALBANY_PATH}

git clone https://github.com/snlcomputation/albany.git AlbanySrc
cd AlbanySrc
git pull
mkdir -p build-gcc
cd build-gcc

rm -rf CMake*
${CMAKE_PATH}/bin/cmake \
  -D CMAKE_INSTALL_PREFIX:PATH=${ALBANY_PATH} \
  -D ALBANY_TRILINOS_DIR:FILEPATH=${TRILINOS_PATH} \
  -D CMAKE_CXX_FLAGS:STRING="" \
  -D CMAKE_VERBOSE_MAKEFILE:BOOL=OFF \
  -D ENABLE_DEMO_PDES:BOOL=OFF \
  -D ENABLE_LANDICE:BOOL=ON \
  -D ENABLE_PERFORMANCE_TESTS:BOOL=OFF \
  -D ALBANY_LIBRARIES_ONLY=OFF \
  -D ENABLE_KOKKOS_UNDER_DEVELOPMENT:BOOL=ON \
  -D INSTALL_ALBANY:BOOL=ON \
..
make -j 4
make install
cd ${PWD_PATH}

