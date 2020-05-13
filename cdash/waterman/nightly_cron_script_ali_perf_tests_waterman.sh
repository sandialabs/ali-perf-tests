#!/bin/csh

BASE_DIR=/home/projects/albany/waterman/aliPerfTests
cd $BASE_DIR

rm -rf build
rm -rf repos 
rm -rf *log*
rm -rf results
rm -rf modules.out 
rm -rf slurm*

unset http_proxy
unset https_proxy

export OMP_NUM_THREADS=1
export KOKKOS_PROFILE_LIBRARY=/home/projects/albany/waterman/kokkos-tools/profiling/space-time-stack-mem-only/kp_space_time_stack.so
source waterman_modules_cuda.sh >& modules.out  

printenv |& tee out-env.txt

now=$(date +"%m_%d_%Y-%H_%M")
LOG_FILE=$BASE_DIR/nightly_log_watermanAliPerfTests.txt

eval "env  TEST_DIRECTORY=$BASE_DIR SCRIPT_DIRECTORY=$BASE_DIR ctest -VV -S $BASE_DIR/ctest_nightly_perfTests.cmake" > $LOG_FILE 2>&1

