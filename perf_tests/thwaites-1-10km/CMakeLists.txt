# Copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_PopulateMesh.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_PopulateMesh.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_MueLu.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_MueLu.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_MueLu.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_MueLu.yaml COPYONLY)

# Create symlink for mesh directory
SET(MESH_PATH "${MESH_FILE_DIR}/thwaites-1-10km")
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${MESH_PATH} ${CMAKE_CURRENT_BINARY_DIR}/mesh)

# Decompose the mesh
execute_process(COMMAND ${ALBANY_SEACAS_DECOMP} --processors ${ALBANY_NUM_PROCS} --root ${CMAKE_CURRENT_BINARY_DIR}/ --subdir mesh-decomp
                ${MESH_PATH}/thwaites_2d.exo)

# Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

# Add tests to populate mesh with ascii inputs
add_test(${testName}_pop_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD24_EXE} input_albany_PopulateMesh.yaml ${ALBANY_EXTRA_ARGS}")

# Add tests for performance
add_test(${testName}_vel_mu_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD12_EXE} input_albany_Velocity_MueLu.yaml ${ALBANY_EXTRA_ARGS}")
add_test(${testName}_ent_mu_np${ALBANY_NUM_PROCS} ${ALBANY_BASH} "${ALBANY_SFAD6_EXE} input_albany_Enthalpy_MueLu.yaml ${ALBANY_EXTRA_ARGS}")

# Add dependencies
set_tests_properties(${testName}_pop_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_SETUP ${testName}_pop)
set_tests_properties(${testName}_vel_mu_np${ALBANY_NUM_PROCS}
                     ${testName}_ent_mu_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_REQUIRED ${testName}_pop)

