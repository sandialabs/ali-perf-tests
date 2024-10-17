# Copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_pop.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_pop.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_vel_cheby.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_vel_cheby.yaml COPYONLY)

IF (NOT ALBANY_ENABLE_CUDA)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_vel_lsgs.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_vel_lsgs.yaml COPYONLY)
ENDIF()

# Create symlink for mesh directory
SET(MESH_PATH "${MESH_FILE_DIR}/ant-struct/ant-1km")
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${MESH_PATH} ${CMAKE_CURRENT_BINARY_DIR}/mesh)

# Decompose the mesh
execute_process(COMMAND ${ALBANY_SEACAS_DECOMP} --processors ${ALBANY_NUM_PROCS} --root ${CMAKE_CURRENT_BINARY_DIR}/ --subdir mesh-decomp
                ${MESH_PATH}/antarctica_2d.exo)

# Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

# Add test to populate mesh with ascii inputs
add_test(${testName}_pop_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD12_EXE} input_pop.yaml ${ALBANY_EXTRA_ARGS}")

# Add tests for performance
add_test(${testName}_vel_cheby_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD12_EXE} input_vel_cheby.yaml ${ALBANY_EXTRA_ARGS}")

IF (NOT ALBANY_ENABLE_CUDA)
  add_test(${testName}_vel_lsgs_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD12_EXE} input_vel_lsgs.yaml ${ALBANY_EXTRA_ARGS}")
ENDIF()

# Add dependencies
set_tests_properties(${testName}_pop_np${ALBANY_NUM_PROCS}
                     PROPERTIES
                     FIXTURES_SETUP ${testName}_pop
                     LABELS "pop")
set_tests_properties(${testName}_vel_cheby_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_REQUIRED ${testName}_pop)

IF (NOT ALBANY_ENABLE_CUDA)
  set_tests_properties(${testName}_vel_lsgs_np${ALBANY_NUM_PROCS}
                       PROPERTIES FIXTURES_REQUIRED ${testName}_pop)
ENDIF()

