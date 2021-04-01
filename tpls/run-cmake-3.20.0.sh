#!/bin/bash
# Download, build, install cmake
PWD_PATH=`pwd`
CMAKE_PATH=${PWD_PATH}/cmake/3.20.0/gnu
mkdir -p ${CMAKE_PATH}

wget -c https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0-Linux-x86_64.sh
chmod +x cmake-3.20.0-Linux-x86_64.sh
./cmake-3.20.0-Linux-x86_64.sh --prefix=${CMAKE_PATH} --exclude-subdir --skip-license
cd ${PWD_PATH}

