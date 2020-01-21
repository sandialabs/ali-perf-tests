#!/bin/csh

BASE_DIR=/home/projects/albany/waterman/aliPerfTests
cd $BASE_DIR

rm -rf build
rm -rf repos 
rm -rf *log*
rm -rf results
rm -rf ctest_nightly.cmake 
rm -rf modules.out 
rm -rf slurm*

unset http_proxy
unset https_proxy

export OMP_NUM_THREADS=1

source waterman_modules_cuda.sh >& modules.out  

cat ali ctest_nightly.cmake.frag >& ctest_nightly.cmake  

now=$(date +"%m_%d_%Y-%H_%M")
LOG_FILE=$BASE_DIR/nightly_log_watermanAliPerfTests.txt

eval "env  TEST_DIRECTORY=$BASE_DIR SCRIPT_DIRECTORY=$BASE_DIR ctest -VV -S $BASE_DIR/ctest_nightly.cmake" > $LOG_FILE 2>&1

