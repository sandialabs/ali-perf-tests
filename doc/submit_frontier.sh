#!/bin/bash -login

#SBATCH -A CLI193
#SBATCH --job-name=ALIPT
#SBATCH --output=ALIPT.%j.out
#SBATCH --error=ALIPT.%j.err
#SBATCH -p batch
#SBATCH --nodes=2
#SBATCH --time=02:00:00
#SBATCH --exclusive

# Load modules
source frontier_gpu_modules.sh

# Env variables
export KOKKOS_TOOLS_LIBS=/lustre/orion/cli193/proj-shared/automated_testing/kokkos-tools/profiling/space-time-stack-mem-only/hip/kp_space_time_stack.so
#unset KOKKOS_TOOLS_LIBS

# Run
ctest -V

