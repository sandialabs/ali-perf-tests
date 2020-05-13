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

export INTEL_LICENSE_FILE=/home/projects/x86-64/intel/licenses/USE_SERVER-ohpc.lic
export KOKKOS_PROFILE_LIBRARY=/home/projects/albany/nightlyCDashAlbanyBlake/kokkos-tools/profiling/space-time-stack-mem-only/kp_space_time_stack.so
source blake_intel_modules.sh >& modules.out  

printenv |& tee out-env.txt

LOG_FILE=$BASE_DIR/nightly_log_blakeAliPerfTests.txt

eval "env  TEST_DIRECTORY=$BASE_DIR SCRIPT_DIRECTORY=$BASE_DIR ctest -VV -S $BASE_DIR/ctest_nightly.cmake" > $LOG_FILE 2>&1

