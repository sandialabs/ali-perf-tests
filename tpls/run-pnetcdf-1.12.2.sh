#!/bin/bash
# Download, build, install pnetcdf
PWD_PATH=`pwd`
PNETCDF_PATH=${PWD_PATH}/pnetcdf/1.12.2/gnu
mkdir -p ${PNETCDF_PATH}

wget -c https://parallel-netcdf.github.io/Release/pnetcdf-1.12.2.tar.gz
tar -xvf pnetcdf-1.12.2.tar.gz
cd pnetcdf-1.12.2

./configure MPICC=mpicc MPICXX=mpicxx MPIF77=mpif77 MPIF90=mpif90 \
    CXXFLAGS="-O3 -fPIC" CFLAGS="-O3 -fPIC" F77FLAGS="-O3 -fPIC" F90FLAGS="-O3 -fPIC" \
    --build=x86_64 \
    --prefix=${PNETCDF_PATH}
make -j 4
make install
cd ${PWD_PATH}

