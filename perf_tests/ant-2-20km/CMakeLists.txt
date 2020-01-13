#copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_ML_LineSmoothing.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_ML_LineSmoothing.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_MueLu_LineSmoothing.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_MueLu_LineSmoothing.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_MueLu_DecoupledLineSmoothing.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_MueLu_DecoupledLineSmoothing.yaml COPYONLY)

#Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
  ${MESH_FILE_DIR}/ant-2-20km-pop ${CMAKE_CURRENT_BINARY_DIR}/mesh)

#create test
IF (NOT ALBANY_ENABLE_CUDA)
  add_test(${testName}_ml_ls_np384 ${ALBANY_EXE} input_albany_ML_LineSmoothing.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_mu_ls_np384 ${ALBANY_EXE} input_albany_MueLu_LineSmoothing.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_mu_dls_np384 ${ALBANY_EXE} input_albany_MueLu_DecoupledLineSmoothing.yaml ${ALBANY_EXTRA_ARGS})
ENDIF()
