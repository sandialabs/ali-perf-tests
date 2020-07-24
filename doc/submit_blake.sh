#!/bin/bash -login

#SBATCH --job-name=GISRun
#SBATCH --output=GISRun.%j.out
#SBATCH --error=GISRun.%j.err
#SBATCH --nodes=8
#SBATCH --ntasks=384
#SBATCH --ntasks-per-node=48
#SBATCH --time=04:00:00
#SBATCH --exclusive
## SBATCH --exclude=node03,node06,node10,node27,node15

# Load modules
source ${HOME}/bin/blake_intel_modules.sh

# Env variables
#export KOKKOS_PROFILE_LIBRARY=/home/projects/albany/nightlyCDashAlbanyBlake/kokkos-tools/profiling/space-time-stack-mem-only/kp_space_time_stack.so
unset KOKKOS_PROFILE_LIBRARY

# Run
ctest -V

