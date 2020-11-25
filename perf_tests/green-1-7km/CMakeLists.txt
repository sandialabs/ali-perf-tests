# Copy files to build directory
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_PopulateMesh.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_PopulateMesh.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_FiniteElementAssembly_SingleWorkset.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_FiniteElementAssembly_SingleWorkset.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_FiniteElementAssembly_Memoization.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_FiniteElementAssembly_Memoization.yaml COPYONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_MueLuKokkos_LineSmoothing_Memoization.yaml
               ${CMAKE_CURRENT_BINARY_DIR}/input_albany_MueLuKokkos_LineSmoothing_Memoization.yaml COPYONLY)
IF (NOT ALBANY_ENABLE_CUDA)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_MueLu_DecoupledLineSmoothing_SingleWorkset.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_albany_MueLu_DecoupledLineSmoothing_SingleWorkset.yaml COPYONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_ML_LineSmoothing_Memoization.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_albany_ML_LineSmoothing_Memoization.yaml COPYONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_MueLu_LineSmoothing_Memoization.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_albany_MueLu_LineSmoothing_Memoization.yaml COPYONLY)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input_albany_MueLu_DecoupledLineSmoothing_Memoization.yaml
                 ${CMAKE_CURRENT_BINARY_DIR}/input_albany_MueLu_DecoupledLineSmoothing_Memoization.yaml COPYONLY)
ENDIF()

# Create symlink for mesh directory
SET(MESH_PATH "${MESH_FILE_DIR}/green-1-7km")
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
                ${MESH_PATH} ${CMAKE_CURRENT_BINARY_DIR}/mesh)

# Decompose the mesh
execute_process(COMMAND ${ALBANY_SEACAS_DECOMP} --processors ${ALBANY_NUM_PROCS} --root ${CMAKE_CURRENT_BINARY_DIR}/ --subdir mesh-decomp
                ${MESH_PATH}/Greenland.exo)

# Name the test with the directory name
get_filename_component(testName ${CMAKE_CURRENT_SOURCE_DIR} NAME)

# Add test to populate mesh with ascii inputs
add_test(${testName}_pop_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_PopulateMesh.yaml ${ALBANY_EXTRA_ARGS})

# Add tests for performance
add_test(${testName}_fea_1ws_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_FiniteElementAssembly_SingleWorkset.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_fea_mem_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_FiniteElementAssembly_Memoization.yaml ${ALBANY_EXTRA_ARGS})
add_test(${testName}_muk_ls_mem_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_MueLuKokkos_LineSmoothing_Memoization.yaml ${ALBANY_EXTRA_ARGS})
IF (NOT ALBANY_ENABLE_CUDA)
  add_test(${testName}_mu_dls_1ws_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_MueLu_DecoupledLineSmoothing_SingleWorkset.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_ml_ls_mem_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_ML_LineSmoothing_Memoization.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_mu_ls_mem_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_MueLu_LineSmoothing_Memoization.yaml ${ALBANY_EXTRA_ARGS})
  add_test(${testName}_mu_dls_mem_np${ALBANY_NUM_PROCS} ${ALBANY_SFAD8_EXE} input_albany_MueLu_DecoupledLineSmoothing_Memoization.yaml ${ALBANY_EXTRA_ARGS})
ENDIF()

# Add dependencies
set_tests_properties(${testName}_pop_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_SETUP ${testName}_pop)
set_tests_properties(${testName}_fea_1ws_np${ALBANY_NUM_PROCS}
                     ${testName}_fea_mem_np${ALBANY_NUM_PROCS}
                     ${testName}_muk_ls_mem_np${ALBANY_NUM_PROCS}
                     PROPERTIES FIXTURES_REQUIRED ${testName}_pop)
IF (NOT ALBANY_ENABLE_CUDA)
  set_tests_properties(${testName}_mu_dls_1ws_np${ALBANY_NUM_PROCS}
                       ${testName}_ml_ls_mem_np${ALBANY_NUM_PROCS}
                       ${testName}_mu_ls_mem_np${ALBANY_NUM_PROCS}
                       ${testName}_mu_dls_mem_np${ALBANY_NUM_PROCS}
                       PROPERTIES FIXTURES_REQUIRED ${testName}_pop)
ENDIF()

