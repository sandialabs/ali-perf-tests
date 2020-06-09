#copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_BasalFrictionInit_SingleWorkset.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_BasalFrictionInit_SingleWorkset.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_BasalFrictionInit_Memoization.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_BasalFrictionInit_Memoization.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_BasalFrictionInit_MemoizationForParams.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_BasalFrictionInit_MemoizationForParams.yaml COPYONLY)

#Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
  ${MESH_FILE_DIR}/green-3-20km-pop ${CMAKE_CURRENT_BINARY_DIR}/mesh)

#create test
IF (NOT ALBANY_ENABLE_CUDA)  
  add_test(${testName}_beta_1ws_np${ALBANY_NUM_PROCS} ${ALBANY_ANALYSIS_SFAD8_EXE} input_albany_BasalFrictionInit_SingleWorkset.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_beta_mem_np${ALBANY_NUM_PROCS} ${ALBANY_ANALYSIS_SFAD8_EXE} input_albany_BasalFrictionInit_Memoization.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_beta_memp_np${ALBANY_NUM_PROCS} ${ALBANY_ANALYSIS_SFAD8_EXE} input_albany_BasalFrictionInit_MemoizationForParams.yaml ${ALBANY_EXTRA_ARGS})
ENDIF()

