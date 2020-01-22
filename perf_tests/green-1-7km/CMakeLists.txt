#copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_FiniteElementAssembly_SingleWorkset.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_FiniteElementAssembly_SingleWorkset.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_ML_LineSmoothing_SingleWorkset.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_ML_LineSmoothing_SingleWorkset.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_MueLu_LineSmoothing_SingleWorkset.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_MueLu_LineSmoothing_SingleWorkset.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_MueLu_DecoupledLineSmoothing_SingleWorkset.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_MueLu_DecoupledLineSmoothing_SingleWorkset.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_FiniteElementAssembly_Memoization.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_FiniteElementAssembly_Memoization.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_ML_LineSmoothing_Memoization.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_ML_LineSmoothing_Memoization.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_MueLu_LineSmoothing_Memoization.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_MueLu_LineSmoothing_Memoization.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_MueLu_DecoupledLineSmoothing_Memoization.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_MueLu_DecoupledLineSmoothing_Memoization.yaml COPYONLY)

#Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
  ${MESH_FILE_DIR}/green-1-7km-pop ${CMAKE_CURRENT_BINARY_DIR}/mesh)

#create test
add_test(${testName}_fea_1ws_np${ALBANY_NUM_PROCS} ${ALBANY_EXE} input_albany_FiniteElementAssembly_SingleWorkset.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_fea_mem_np${ALBANY_NUM_PROCS} ${ALBANY_EXE} input_albany_FiniteElementAssembly_Memoization.yaml ${ALBANY_EXTRA_ARGS})
IF (NOT ALBANY_ENABLE_CUDA)  
  add_test(${testName}_ml_ls_1ws_np${ALBANY_NUM_PROCS} ${ALBANY_EXE} input_albany_ML_LineSmoothing_SingleWorkset.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_mu_ls_1ws_np${ALBANY_NUM_PROCS} ${ALBANY_EXE} input_albany_MueLu_LineSmoothing_SingleWorkset.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_mu_dls_1ws_np${ALBANY_NUM_PROCS} ${ALBANY_EXE} input_albany_MueLu_DecoupledLineSmoothing_SingleWorkset.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_ml_ls_mem_np${ALBANY_NUM_PROCS} ${ALBANY_EXE} input_albany_ML_LineSmoothing_Memoization.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_mu_ls_mem_np${ALBANY_NUM_PROCS} ${ALBANY_EXE} input_albany_MueLu_LineSmoothing_Memoization.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_mu_dls_mem_np${ALBANY_NUM_PROCS} ${ALBANY_EXE} input_albany_MueLu_DecoupledLineSmoothing_Memoization.yaml ${ALBANY_EXTRA_ARGS})
ENDIF()
