#!/bin/csh

BASE_DIR=/home/projects/albany/nightlyCDashAlbanyBlake/aliPerfTests/nightlyCDash
cd $BASE_DIR

unset http_proxy
unset https_proxy

rm -rf *slurm*
rm -rf repos
rm -rf build
rm -rf *txt
rm -rf modules.out
rm -rf results
rm -rf batch.openmp.bash 

export OMP_NUM_THREADS=1

source blake_intel_modules.sh >& modules.out  

printenv |& tee out-env.txt

now=$(date +"%m_%d_%Y-%H_%M")
LOG_FILE=$BASE_DIR/nightly_log_blakeAliPerfTests.txt

eval "env  TEST_DIRECTORY=$BASE_DIR SCRIPT_DIRECTORY=$BASE_DIR ctest -VV -S $BASE_DIR/ctest_nightly.cmake" > $LOG_FILE 2>&1

