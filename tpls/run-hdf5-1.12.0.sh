#!/bin/bash
# Download, build, install hdf5
PWD_PATH=`pwd`
ZLIB_PATH=${PWD_PATH}/zlib/1.2.11/gnu
HDF5_PATH=${PWD_PATH}/hdf5/1.12.0/gnu
mkdir -p ${HDF5_PATH}

wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz
tar -xvf hdf5-1.12.0.tar.gz
cd hdf5-1.12.0

./configure CC=mpicc FC=mpifort CXX=mpicxx CXXFLAGS="-O3 -fPIC" CFLAGS="-O3 -fPIC" FCFLAGS="-O3 -fPIC" \
    --enable-parallel --build=x86_64 --with-default-api-version=v18 \
    --with-zlib=${ZLIB_PATH} --prefix=${HDF5_PATH}
make -j 4
make install
cd ${PWD_PATH}

