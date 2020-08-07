#!/bin/bash
module purge 
module load git
module load devpack/20190814/openmpi/4.0.1/gcc/7.2.0/cuda/10.1.105
module swap cmake cmake/3.12.3
module list

export CUDA_MANAGED_FORCE_DEVICE_ALLOC=1
export CUDA_LAUNCH_BLOCKING=1
 
