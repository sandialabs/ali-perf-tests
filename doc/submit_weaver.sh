#!/bin/bash -login

#BSUB -J GISRun
#BSUB -o GISRun.%J.out
#BSUB -e GISRun.%J.err
#BSUB -q rhel7W
## BSUB -q dev
## BSUB -m "weaver2"
#BSUB -n 8
#BSUB -R "span[ptile=4]"
#BSUB -W 08:00
#BSUB -x

# Limit disk usage for large files
ulimit -c 0

# Load modules
source $HOME/bin/weaver_modules.sh

# Env variables
export KOKKOS_PROFILE_LIBRARY=/home/projects/albany/nightlyCDashWeaver/kokkos-tools/profiling/space-time-stack-mem-only/kp_space_time_stack.so
#unset KOKKOS_PROFILE_LIBRARY
export CUDA_LAUNCH_BLOCKING=1
#unset CUDA_LAUNCH_BLOCKING
export TPETRA_ASSUME_CUDA_AWARE_MPI=0

# Run
ctest -V

