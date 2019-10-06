#copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_ml_LineSmoothing.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_ml_LineSmoothing.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_muelu_LineSmoothing.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_muelu_LineSmoothing.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_muelu_DecoupledLineSmoothing.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_muelu_DecoupledLineSmoothing.yaml COPYONLY)

#Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
  ${MESH_FILE_DIR}/ant-2-20km ${CMAKE_CURRENT_BINARY_DIR}/mesh)

#create test
add_test(${testName}_ml_line_np384 ${Np384Albany.exe} input_albany_ml_LineSmoothing.yaml)
add_test(${testName}_muelu_line_np384 ${Np384Albany.exe} input_albany_muelu_LineSmoothing.yaml)
add_test(${testName}_muelu_decoupled_line_np384 ${Np384Albany.exe} input_albany_muelu_DecoupledLineSmoothing.yaml)


