#!/bin/bash
# Download, build, install Trilinos
PWD_PATH=`pwd`
CMAKE_PATH=${PWD_PATH}/cmake/3.20.0/gnu
BLAS_PATH=${PWD_PATH}/lapack/3.9.0/gnu
LAPACK_PATH=${PWD_PATH}/lapack/3.9.0/gnu
BOOST_PATH=${PWD_PATH}/boost/1.75.0/gnu
NETCDF_PATH=${PWD_PATH}/netcdf/4.8.0/gnu
PNETCDF_PATH=${PWD_PATH}/pnetcdf/1.12.2/gnu
HDF5_PATH=${PWD_PATH}/hdf5/1.12.0/gnu
ZLIB_PATH=${PWD_PATH}/zlib/1.2.11/gnu
TRILINOS_PATH=${PWD_PATH}/trilinos/develop/gnu
mkdir -p ${TRILINOS_PATH}

git clone https://github.com/trilinos/Trilinos.git TrilinosSrc
cd TrilinosSrc
git checkout develop
git pull
mkdir -p build-gcc
cd build-gcc

rm -rf CMake*
${CMAKE_PATH}/bin/cmake \
      -DCMAKE_INSTALL_PREFIX:PATH=${TRILINOS_PATH} \
      -DCMAKE_BUILD_TYPE:STRING=RELEASE \
      \
      -DCMAKE_CXX_COMPILER:FILEPATH=mpicxx \
      -DCMAKE_C_COMPILER=mpicc \
      -DCMAKE_Fortran_COMPILER=mpif90 \
      -D CMAKE_C_FLAGS:STRING="-fPIC" \
      -D CMAKE_CXX_FLAGS:STRING="-fPIC" \
      -D CMAKE_Fortran_FLAGS:STRING="-fPIC" \
      -D CMAKE_EXE_LINKER_FLAGS="-fPIC -ldl" \
      -DCMAKE_SKIP_RULE_DEPENDENCY=ON \
      \
      -DTPL_ENABLE_MPI:BOOL=ON \
      -DMPI_EXEC=srun \
      -DMPI_EXEC_NUMPROCS_FLAG:STRING=-n \
      \
      -DTPL_ENABLE_BLAS:BOOL=ON \
      -DBLAS_LIBRARY_DIRS:PATH=${BLAS_PATH}/lib64 \
      -DBLAS_LIBRARY_NAMES:STRING=blas \
      \
      -DTPL_ENABLE_LAPACK:BOOL=ON \
      -DLAPACK_LIBRARY_DIRS:PATH=${LAPACK_PATH}/lib64 \
      -DLAPACK_LIBRARY_NAMES:STRING=lapack \
      \
      -DTPL_ENABLE_Boost:BOOL=ON \
      -DBoost_INCLUDE_DIRS:PATH=${BOOST_PATH}/include \
      -DBoost_LIBRARY_DIRS:PATH=${BOOST_PATH}/lib \
      \
      -DTPL_ENABLE_BoostLib:BOOL=ON \
      -DBoostLib_INCLUDE_DIRS:PATH=${BOOST_PATH}/include \
      -DBoostLib_LIBRARY_DIRS:PATH=${BOOST_PATH}/lib \
      \
      -DTPL_ENABLE_Netcdf:BOOL=ON \
      -DTPL_Netcdf_PARALLEL:BOOL=ON \
      -DNetcdf_INCLUDE_DIRS:PATH=${NETCDF_PATH}/include \
      -DNetcdf_LIBRARY_DIRS:PATH=${NETCDF_PATH}/lib \
      \
      -DTPL_ENABLE_Pnetcdf:STRING=ON \
      -DPnetcdf_INCLUDE_DIRS:PATH=${PNETCDF_PATH}/include \
      -DPnetcdf_LIBRARY_DIRS:PATH=${PNETCDF_PATH}/lib \
      \
      -DTPL_ENABLE_HDF5:STRING=ON \
      -DHDF5_INCLUDE_DIRS:PATH=${HDF5_PATH}/include \
      -DHDF5_LIBRARY_DIRS:PATH="${HDF5_PATH}/lib;${ZLIB_PATH}/lib" \
\
      -DTPL_ENABLE_Zlib:BOOL=ON \
      -DZlib_INCLUDE_DIRS:PATH=${ZLIB_PATH}/include \
      -DZlib_LIBRARY_DIRS:PATH=${ZLIB_PATH}/lib \
      \
      -DTrilinos_ASSERT_MISSING_PACKAGES:BOOL=OFF \
      -DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF \
      -DTrilinos_ENABLE_ALL_PACKAGES:BOOL=OFF \
      -DTrilinos_ENABLE_CXX11:BOOL=ON \
      -DTrilinos_ENABLE_EXAMPLES:BOOL=OFF \
      -DTrilinos_ENABLE_EXPLICIT_INSTANTIATION:BOOL=ON \
      -DTrilinos_VERBOSE_CONFIGURE:BOOL=OFF \
      \
      -DKokkos_ENABLE_EXAMPLES:BOOL=OFF \
      -DKokkos_ENABLE_OPENMP:BOOL=OFF \
      -DKokkos_ENABLE_PTHREAD:BOOL=OFF \
      -DKokkos_ENABLE_SERIAL:BOOL=ON \
      -DKokkos_ENABLE_TESTS:BOOL=OFF \
      -DKokkos_ARCH_SNB:BOOL=ON \
      \
      -DAmesos2_ENABLE_KLU2:BOOL=ON \
      -DEpetraExt_USING_HDF5:BOOL=OFF \
      -DIntrepid_ENABLE_TESTS:BOOL=OFF \
      -DIntrepid2_ENABLE_TESTS:BOOL=OFF \
      -DPhalanx_INDEX_SIZE_TYPE:STRING=INT \
      -DPhalanx_KOKKOS_DEVICE_TYPE:STRING=SERIAL \
      -DSacado_ENABLE_COMPLEX:BOOL=OFF \
      -DTeuchos_ENABLE_COMPLEX:BOOL=OFF \
      -DTpetra_ENABLE_Kokkos_Refactor:BOOL=ON \
      -DTpetra_INST_INT_LONG_LONG:BOOL=ON \
      -DTpetra_INST_INT_INT:BOOL=OFF \
      -DXpetra_ENABLE_Epetra=OFF \
      -DMueLu_ENABLE_Epetra=OFF \
      -DBelos_ENABLE_Epetra=OFF \
      -DMueLu_ENABLE_Tutorial:BOOL=OFF \
      \
      -DTPL_ENABLE_Matio:BOOL=OFF \
      -DTPL_ENABLE_X11:BOOL=OFF \
      \
      -DTrilinos_ENABLE_Amesos2:BOOL=ON \
      -DTrilinos_ENABLE_Amesos:BOOL=ON \
      -DTrilinos_ENABLE_Anasazi:BOOL=ON \
      -DTrilinos_ENABLE_AztecOO:BOOL=ON \
      -DTrilinos_ENABLE_Belos:BOOL=ON \
      -DTrilinos_ENABLE_EXAMPLES:BOOL=OFF \
      -DTrilinos_ENABLE_Epetra:BOOL=ON \
      -DTrilinos_ENABLE_EpetraExt:BOOL=ON \
      -DTrilinos_ENABLE_Ifpack2:BOOL=ON \
      -DTrilinos_ENABLE_Ifpack:BOOL=ON \
      -DTrilinos_ENABLE_Intrepid:BOOL=ON \
      -DTrilinos_ENABLE_Intrepid2:BOOL=ON \
      -DTrilinos_ENABLE_Kokkos:BOOL=ON \
      -DTrilinos_ENABLE_KokkosAlgorithms:BOOL=ON \
      -DTrilinos_ENABLE_KokkosContainers:BOOL=ON \
      -DTrilinos_ENABLE_KokkosCore:BOOL=ON \
      -DTrilinos_ENABLE_ML:BOOL=ON \
      -DTrilinos_ENABLE_OpenMP:BOOL=OFF \
      -DTrilinos_ENABLE_MiniTensor:BOOL=ON \
      -DTrilinos_ENABLE_MueLu:BOOL=ON \
      -DTrilinos_ENABLE_NOX:BOOL=ON \
      -DTrilinos_ENABLE_Pamgen:BOOL=ON \
      -DTrilinos_ENABLE_PanzerExprEval:BOOL=ON \
      -DTrilinos_ENABLE_Phalanx:BOOL=ON \
      -DTrilinos_ENABLE_Piro:BOOL=ON \
      -DTrilinos_ENABLE_Rythmos:BOOL=ON \
      -DTrilinos_ENABLE_SEACAS:BOOL=ON \
      -DTrilinos_ENABLE_SEACASAprepro_lib:BOOL=OFF \
      -DTrilinos_ENABLE_STKDoc_tests:BOOL=OFF \
      -DTrilinos_ENABLE_STKIO:BOOL=ON \
      -DTrilinos_ENABLE_STKMesh:BOOL=ON \
      -DTrilinos_ENABLE_Sacado:BOOL=ON \
      -DTrilinos_ENABLE_Shards:BOOL=ON \
      -DTrilinos_ENABLE_Stokhos:BOOL=OFF \
      -DTrilinos_ENABLE_Stratimikos:BOOL=ON \
      -DTrilinos_ENABLE_TESTS:BOOL=OFF \
      -DTrilinos_ENABLE_Teko:BOOL=ON \
      -DTrilinos_ENABLE_Teuchos:BOOL=ON \
      -DTrilinos_ENABLE_Thyra:BOOL=ON \
      -DTrilinos_ENABLE_ThyraEpetraAdapters:BOOL=ON \
      -DTrilinos_ENABLE_ThyraTpetraAdapters:BOOL=ON \
      -DTrilinos_ENABLE_Tpetra:BOOL=ON \
      -DTrilinos_ENABLE_Zoltan2:BOOL=ON \
      -DTrilinos_ENABLE_Zoltan:BOOL=ON \
      -DTrilinos_ENABLE_Tempus:BOOL=ON \
      -DTempus_ENABLE_EXPLICIT_INSTANTIATION:BOOL=ON \
      \
      -DHAVE_dggsvd3_POST=1 \
      \
      -DTpetra_ENABLE_DEPRECATED_CODE:BOOL=OFF \
      -DXpetra_ENABLE_DEPRECATED_CODE:BOOL=OFF \
      -DKokkos_ENABLE_LIBDL:BOOL=ON \
      -DTrilinos_ENABLE_PanzerDofMgr:BOOL=ON \
      \
..
make -j 4
make install
cd ${PWD_PATH}

