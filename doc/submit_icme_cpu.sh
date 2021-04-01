#!/bin/bash -login

#SBATCH --job-name=GISRun
#SBATCH --output=GISRun.%j.out
#SBATCH --error=GISRun.%j.err
#SBATCH --nodes=4
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=12
#SBATCH --time=02:00:00
#SBATCH --exclusive

# Run
ctest -V

