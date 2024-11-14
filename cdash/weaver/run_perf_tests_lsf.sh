#!/bin/bash                                           

rm -rf repos
rm -rf build
rm -rf ctest_nightly.cmake
rm -rf nightly_log*
rm -rf results*
rm -rf slurm* 
rm -rf modules*out 

ulimit -c 0
export CUDA_VISIBLE_DEVICES=0,1,2,3

unset http_proxy
unset https_proxy
bash -c -l "source weaver_modules_cuda.sh >& modules.out; bash nightly_cron_script_ali_perf_tests_weaver.sh; bash nightly_cron_script_ali_perf_tests_weaver_bzip2_save.sh >& nightly_log_weaverAliPerfTests_saveResults.txt"
