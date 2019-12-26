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
add_test(${testName}_fea_1ws_np384 ${Np384Albany.exe} input_albany_FiniteElementAssembly_SingleWorkset.yaml)
add_test(${testName}_ml_ls_1ws_np384 ${Np384Albany.exe} input_albany_ML_LineSmoothing_SingleWorkset.yaml)
add_test(${testName}_mu_ls_1ws_np384 ${Np384Albany.exe} input_albany_MueLu_LineSmoothing_SingleWorkset.yaml)
add_test(${testName}_mu_dls_1ws_np384 ${Np384Albany.exe} input_albany_MueLu_DecoupledLineSmoothing_SingleWorkset.yaml)
add_test(${testName}_fea_mem_np384 ${Np384Albany.exe} input_albany_FiniteElementAssembly_Memoization.yaml)
add_test(${testName}_ml_ls_mem_np384 ${Np384Albany.exe} input_albany_ML_LineSmoothing_Memoization.yaml)
add_test(${testName}_mu_ls_mem_np384 ${Np384Albany.exe} input_albany_MueLu_LineSmoothing_Memoization.yaml)
add_test(${testName}_mu_dls_mem_np384 ${Np384Albany.exe} input_albany_MueLu_DecoupledLineSmoothing_Memoization.yaml)

