#!/bin/csh

BASE_DIR=/home/projects/albany/nightlyCDashAlbanyBlake/aliPerfTests/nightlyCDash
cd $BASE_DIR

unset http_proxy
unset https_proxy

rm -rf *slurm*
rm -rf *.txt
rm -rf gcc_modules.out

export OMP_NUM_THREADS=1

export KOKKOS_TOOLS_LIBS=/home/projects/albany/nightlyCDashAlbanyBlake/kokkos-tools/profiling/space-time-stack-mem-only/kp_space_time_stack.so
source blake_gcc_modules.sh >& gcc_modules.out  

printenv |& tee out-env.txt

LOG_FILE=$BASE_DIR/nightly_log_blakeAliPerfTests.txt

eval "env  TEST_DIRECTORY=$BASE_DIR SCRIPT_DIRECTORY=$BASE_DIR ctest -VV -S $BASE_DIR/ctest_nightly.cmake" > $LOG_FILE 2>&1

