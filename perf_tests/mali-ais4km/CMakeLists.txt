# Copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/albany_input_gpu.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/albany_input_gpu.yaml COPYONLY)

IF (NOT Kokkos_ENABLE_CUDA)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/albany_input_cpu.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/albany_input_cpu.yaml COPYONLY)
ENDIF()


# Create copy/symlink for case files
set(CASE_PATH "${MESH_FILE_DIR}/mali-ais4km")
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${CASE_PATH}/rst.2050-01-01.nc ${CMAKE_CURRENT_BINARY_DIR}/rst.2050-01-01.nc)
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${CASE_PATH}/graph.info.part.${ALBANY_NUM_PROCS} ${CMAKE_CURRENT_BINARY_DIR}/graph.info.part.${ALBANY_NUM_PROCS})
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${CASE_PATH}/resampled_calving_mask.nc ${CMAKE_CURRENT_BINARY_DIR}/resampled_calving_mask.nc)
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${CASE_PATH}/resampled_smb.nc ${CMAKE_CURRENT_BINARY_DIR}/resampled_smb.nc)
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${CASE_PATH}/resampled_tf.nc ${CMAKE_CURRENT_BINARY_DIR}/resampled_tf.nc)
execute_process(COMMAND ${CMAKE_COMMAND} -E copy
                ${CASE_PATH}/namelist.landice_${ALBANY_NUM_PROCS} ${CMAKE_CURRENT_BINARY_DIR}/namelist.landice)
execute_process(COMMAND ${CMAKE_COMMAND} -E copy
                ${CASE_PATH}/streams.landice ${CMAKE_CURRENT_BINARY_DIR}/streams.landice)

# Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

# Add tests for performance
set(MALI_PRE_TEST "rm -rf log.landice.* log.albany.* rst.2051-01-01.nc rst.2052-01-01.nc mali-output ; cp ${CMAKE_CURRENT_SOURCE_DIR}/restart_timestamp ${CMAKE_CURRENT_BINARY_DIR}/restart_timestamp")
set(MALI_POST_TEST "cat ${CMAKE_CURRENT_BINARY_DIR}/log.landice.* ${CMAKE_CURRENT_BINARY_DIR}/log.albany.0000.out ${CMAKE_CURRENT_BINARY_DIR}/log.albany.timers.out")

add_test(${testName}_gpu_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${MALI_PRE_TEST} ; cp albany_input_gpu.yaml albany_input.yaml ; ${MALI_EXE} ; ${MALI_POST_TEST}")
IF (NOT Kokkos_ENABLE_CUDA)
  add_test(${testName}_cpu_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${MALI_PRE_TEST} ; cp albany_input_cpu.yaml albany_input.yaml ; ${MALI_EXE} ; ${MALI_POST_TEST}")
ENDIF()

