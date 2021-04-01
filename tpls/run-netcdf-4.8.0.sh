#!/bin/bash
# Download, build, install netcdf
PWD_PATH=`pwd`
ZLIB_PATH=${PWD_PATH}/zlib/1.2.11/gnu
HDF5_PATH=${PWD_PATH}/hdf5/1.12.0/gnu
PNETCDF_PATH=${PWD_PATH}/pnetcdf/1.12.2/gnu
NETCDF_PATH=${PWD_PATH}/netcdf/4.8.0/gnu
mkdir -p ${NETCDF_PATH}

wget -c https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.8.0.tar.gz
tar -xvf netcdf-c-4.8.0.tar.gz
cd netcdf-c-4.8.0

./configure CC=mpicc FC=mpifort CXX=mpicxx \
    CXXFLAGS="-I${ZLIB_PATH}/include -I${HDF5_PATH}/include -I${PNETCDF_PATH}/include -O3 -fPIC" \
    CFLAGS="-I${ZLIB_PATH}/include -I${HDF5_PATH}/include -I${PNETCDF_PATH}/include -O3 -fPIC" \
    FCFLAGS="-I${ZLIB_PATH}/include -I${HDF5_PATH}/include -I${PNETCDF_PATH}/include -O3 -fPIC" \
    LDFLAGS="-L${ZLIB_PATH}/lib -L${HDF5_PATH}/lib -L${PNETCDF_PATH}/lib -O3 -fPIC" \
    --disable-doxygen --enable-netcdf4 --enable-pnetcdf --disable-dap \
    --prefix=${NETCDF_PATH}
make -j 4 LDFLAGS="-L${ZLIB_PATH}/lib -L${HDF5_PATH}/lib -L${PNETCDF_PATH}/lib -O3 -fPIC"
make install
cd ${PWD_PATH}

