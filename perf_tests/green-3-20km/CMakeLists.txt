# Copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_PopulateMesh_Tetrahedron.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_PopulateMesh_Tetrahedron.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_PopulateMesh_Wedge.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_PopulateMesh_Wedge.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_PopulateMesh_Tetrahedron.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_PopulateMesh_Tetrahedron.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_PopulateMesh_Wedge.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_PopulateMesh_Wedge.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_FiniteElementAssembly_Memoization_Tetrahedron.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_FiniteElementAssembly_Memoization_Tetrahedron.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_FiniteElementAssembly_Memoization_Wedge.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_FiniteElementAssembly_Memoization_Wedge.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_FiniteElementAssembly_Memoization_Tetrahedron.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_FiniteElementAssembly_Memoization_Tetrahedron.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_FiniteElementAssembly_Memoization_Wedge.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_FiniteElementAssembly_Memoization_Wedge.yaml COPYONLY)

IF (NOT ALBANY_ENABLE_CUDA)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_BasalFrictionInit_SingleWorkset.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_albany_BasalFrictionInit_SingleWorkset.yaml COPYONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_BasalFrictionInit_Memoization.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_albany_BasalFrictionInit_Memoization.yaml COPYONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_BasalFrictionInit_MemoizationForParams.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_albany_BasalFrictionInit_MemoizationForParams.yaml COPYONLY)
ENDIF()


# Create symlink for mesh directory
SET(MESH_PATH "${MESH_FILE_DIR}/green-3-20km")
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${MESH_PATH} ${CMAKE_CURRENT_BINARY_DIR}/mesh)

# Decompose the mesh
execute_process(COMMAND ${ALBANY_SEACAS_DECOMP} --processors ${ALBANY_NUM_PROCS} --root ${CMAKE_CURRENT_BINARY_DIR}/ --subdir mesh-decomp
                ${MESH_PATH}/gis_1k_2d.exo)

# Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

# Add test to populate mesh with ascii inputs
add_test(${testName}_vel_pop_tet_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_Velocity_PopulateMesh_Tetrahedron.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_vel_pop_wdg_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD12_EXE} input_albany_Velocity_PopulateMesh_Wedge.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_ent_pop_tet_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD4_EXE} input_albany_Enthalpy_PopulateMesh_Tetrahedron.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_ent_pop_wdg_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD6_EXE} input_albany_Enthalpy_PopulateMesh_Wedge.yaml ${ALBANY_EXTRA_ARGS})

# Add tests for performance
add_test(${testName}_vel_fea_mem_tet_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_Velocity_FiniteElementAssembly_Memoization_Tetrahedron.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_vel_fea_mem_wdg_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD12_EXE} input_albany_Velocity_FiniteElementAssembly_Memoization_Wedge.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_ent_fea_mem_tet_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD4_EXE} input_albany_Enthalpy_FiniteElementAssembly_Memoization_Tetrahedron.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_ent_fea_mem_wdg_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD6_EXE} input_albany_Enthalpy_FiniteElementAssembly_Memoization_Wedge.yaml ${ALBANY_EXTRA_ARGS})

IF (NOT ALBANY_ENABLE_CUDA)
  add_test(${testName}_beta_1ws_np${ALBANY_NUM_PROCS} ${ALBANY_ANALYSIS_SFAD8_EXE} input_albany_BasalFrictionInit_SingleWorkset.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_beta_mem_np${ALBANY_NUM_PROCS} ${ALBANY_ANALYSIS_SFAD8_EXE} input_albany_BasalFrictionInit_Memoization.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_beta_memp_np${ALBANY_NUM_PROCS} ${ALBANY_ANALYSIS_SFAD8_EXE} input_albany_BasalFrictionInit_MemoizationForParams.yaml ${ALBANY_EXTRA_ARGS})
ENDIF()


# Add dependencies
set_tests_properties(${testName}_vel_pop_tet_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_SETUP ${testName}_vel_pop_tet)
set_tests_properties(${testName}_vel_fea_mem_tet_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_REQUIRED ${testName}_vel_pop_tet)
set_tests_properties(${testName}_vel_pop_wdg_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_SETUP ${testName}_vel_pop_wdg)
set_tests_properties(${testName}_vel_fea_mem_wdg_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_REQUIRED ${testName}_vel_pop_wdg)
set_tests_properties(${testName}_ent_pop_tet_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_SETUP ${testName}_ent_pop_tet)
set_tests_properties(${testName}_ent_fea_mem_tet_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_REQUIRED ${testName}_ent_pop_tet)
set_tests_properties(${testName}_ent_pop_wdg_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_SETUP ${testName}_ent_pop_wdg)
set_tests_properties(${testName}_ent_fea_mem_wdg_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_REQUIRED ${testName}_ent_pop_wdg)

IF (NOT ALBANY_ENABLE_CUDA)
  set_tests_properties(${testName}_beta_1ws_np${ALBANY_NUM_PROCS}
                       ${testName}_beta_mem_np${ALBANY_NUM_PROCS}
                       ${testName}_beta_memp_np${ALBANY_NUM_PROCS}
                       PROPERTIES FIXTURES_REQUIRED ${testName}_vel_pop_tet)
ENDIF()

