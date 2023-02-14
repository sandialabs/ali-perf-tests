# Copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_PopulateMesh.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_PopulateMesh.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_FiniteElementAssembly_SingleWorkset.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_FiniteElementAssembly_SingleWorkset.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_FiniteElementAssembly_Memoization.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_FiniteElementAssembly_Memoization.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_MueLuKokkos.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_MueLuKokkos.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_FiniteElementAssembly_SingleWorkset.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_FiniteElementAssembly_SingleWorkset.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_FiniteElementAssembly_Memoization.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_FiniteElementAssembly_Memoization.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Enthalpy_MueLuKokkos.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Enthalpy_MueLuKokkos.yaml COPYONLY)

IF (NOT ALBANY_ENABLE_CUDA)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_Velocity_MueLu.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_albany_Velocity_MueLu.yaml COPYONLY)
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
add_test(${testName}_pop_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD12_EXE} input_albany_PopulateMesh.yaml ${ALBANY_EXTRA_ARGS})

# Add tests for performance
add_test(${testName}_vel_fea_1ws_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD12_EXE} input_albany_Velocity_FiniteElementAssembly_SingleWorkset.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_vel_fea_mem_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD12_EXE} input_albany_Velocity_FiniteElementAssembly_Memoization.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_vel_muk_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD12_EXE} input_albany_Velocity_MueLuKokkos.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_ent_fea_1ws_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD6_EXE} input_albany_Enthalpy_FiniteElementAssembly_SingleWorkset.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_ent_fea_mem_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD6_EXE} input_albany_Enthalpy_FiniteElementAssembly_Memoization.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_ent_muk_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD6_EXE} input_albany_Enthalpy_MueLuKokkos.yaml ${ALBANY_EXTRA_ARGS})

IF (NOT ALBANY_ENABLE_CUDA)
  add_test(${testName}_vel_mu_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD12_EXE} input_albany_Velocity_MueLu.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_beta_1ws_np${ALBANY_NUM_PROCS} ${ALBANY_ANALYSIS_SFAD12_EXE} input_albany_BasalFrictionInit_SingleWorkset.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_beta_mem_np${ALBANY_NUM_PROCS} ${ALBANY_ANALYSIS_SFAD12_EXE} input_albany_BasalFrictionInit_Memoization.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_beta_memp_np${ALBANY_NUM_PROCS} ${ALBANY_ANALYSIS_SFAD12_EXE} input_albany_BasalFrictionInit_MemoizationForParams.yaml ${ALBANY_EXTRA_ARGS})
ENDIF()


# Add dependencies
set_tests_properties(${testName}_pop_np${ALBANY_NUM_PROCS}
                     PROPERTIES
                     FIXTURES_SETUP ${testName}_pop
                     LABELS "pop")
set_tests_properties(${testName}_vel_fea_1ws_np${ALBANY_NUM_PROCS}
                     ${testName}_vel_fea_mem_np${ALBANY_NUM_PROCS}
                     ${testName}_vel_muk_np${ALBANY_NUM_PROCS}
                     ${testName}_ent_fea_1ws_np${ALBANY_NUM_PROCS}
                     ${testName}_ent_fea_mem_np${ALBANY_NUM_PROCS}
                     ${testName}_ent_muk_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_REQUIRED ${testName}_pop)

IF (NOT ALBANY_ENABLE_CUDA)
  set_tests_properties(${testName}_vel_mu_np${ALBANY_NUM_PROCS}
                       ${testName}_beta_1ws_np${ALBANY_NUM_PROCS}
                       ${testName}_beta_mem_np${ALBANY_NUM_PROCS}
                       ${testName}_beta_memp_np${ALBANY_NUM_PROCS}
                       PROPERTIES FIXTURES_REQUIRED ${testName}_pop)
ENDIF()

