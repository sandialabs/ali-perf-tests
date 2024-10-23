#!/bin/bash -login

#BSUB -J ALIPT
#BSUB -o ALIPT.%J.out
#BSUB -e ALIPT.%J.err
#BSUB -q rhel8
#BSUB -n 4
#BSUB -R "span[ptile=4]"
#BSUB -W 08:00
#BSUB -x
#BSUB -gpu num=4

# Limit disk usage for large files
ulimit -c 0

# Load modules
source weaver_modules.sh

# Env variables
export KOKKOS_TOOLS_LIBS=/home/projects/albany/nightlyCDashWeaver/kokkos-tools/profiling/space-time-stack-mem-only/kp_space_time_stack.so
#unset KOKKOS_TOOLS_LIBS
export CUDA_LAUNCH_BLOCKING=1
#unset CUDA_LAUNCH_BLOCKING
export TPETRA_ASSUME_GPU_AWARE_MPI=0

# Run
ctest -V

