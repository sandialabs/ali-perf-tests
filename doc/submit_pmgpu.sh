#!/bin/bash -login

#SBATCH -A m4274
#SBATCH --job-name=ALIPT
#SBATCH --output=ALIPT.%j.out
#SBATCH --error=ALIPT.%j.err
#SBATCH --constraint=gpu
#SBATCH --qos=regular
#SBATCH --nodes=2
#SBATCH --time=02:00:00
#SBATCH --exclusive

# Load modules
source pm_gpu_gnu_modules.sh

# Env variables
export KOKKOS_TOOLS_LIBS=/global/cfs/cdirs/fanssie/automated_testing/kokkos-tools/profiling/space-time-stack-mem-only/cuda/kp_space_time_stack.so
#unset KOKKOS_TOOLS_LIBS

# Run
ctest -V

