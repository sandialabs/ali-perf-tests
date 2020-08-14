# Copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_short.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_short.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_PopulateMesh.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_PopulateMesh.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_ML_LineSmoothing.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_ML_LineSmoothing.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_MueLu_LineSmoothing.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_MueLu_LineSmoothing.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_MueLu_DecoupledLineSmoothing.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_MueLu_DecoupledLineSmoothing.yaml COPYONLY)

# Create symlink for mesh directory
SET(MESH_PATH "${MESH_FILE_DIR}/ant-2-20km")
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${MESH_PATH} ${CMAKE_CURRENT_BINARY_DIR}/mesh)

# Decompose the mesh
execute_process(COMMAND ${ALBANY_SEACAS_DECOMP} --processors ${ALBANY_NUM_PROCS} --root ${CMAKE_CURRENT_BINARY_DIR}/ --subdir mesh-decomp
                ${MESH_PATH}/antarctica_2d.exo)

# Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

# First test on blake seems to fail, adding a short test to fail instead
add_test(${testName}_a_test_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_short.yaml ${ALBANY_EXTRA_ARGS})

# Add test to populate mesh with ascii inputs
add_test(${testName}_pop_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_PopulateMesh.yaml ${ALBANY_EXTRA_ARGS})

# Add tests for performance
add_test(${testName}_ml_ls_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_ML_LineSmoothing.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_mu_ls_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_MueLu_LineSmoothing.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_mu_dls_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_MueLu_DecoupledLineSmoothing.yaml ${ALBANY_EXTRA_ARGS})

# Add dependencies
set_tests_properties(${testName}_pop_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_SETUP ${testName}_pop)
set_tests_properties(${testName}_ml_ls_np${ALBANY_NUM_PROCS}
                     ${testName}_mu_ls_np${ALBANY_NUM_PROCS}
                     ${testName}_mu_dls_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_REQUIRED ${testName}_pop)

