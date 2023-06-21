#!/bin/bash -login

#SBATCH --job-name=ALIPT
#SBATCH --output=ALIPT.%j.out
#SBATCH --error=ALIPT.%j.err
#SBATCH --nodes=8
#SBATCH --ntasks=384
#SBATCH --ntasks-per-node=48
#SBATCH --time=04:00:00
#SBATCH --exclusive
## SBATCH --exclude=node03,node06,node10,node27,node15

# Load modules
source ${HOME}/bin/blake_gcc_modules.sh

# Env variables
export KOKKOS_TOOLS_LIBS=/home/projects/albany/nightlyCDashAlbanyBlake/kokkos-tools/profiling/space-time-stack-mem-only/kp_space_time_stack.so
#unset KOKKOS_TOOLS_LIBS

# Run
ctest -V

